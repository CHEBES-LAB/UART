----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 08.04.2025 21:35:32
------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity TransmitterUART is
    Port (
        TX_CLK : in STD_LOGIC;
        TX_RESET : in STD_LOGIC;
        TX_START : in STD_LOGIC;
        TX_DATA_IN : in STD_LOGIC_VECTOR(7 downto 0);
        TX_STATUS : out STD_LOGIC;
        TX_OUT : out STD_LOGIC
    );
end TransmitterUART;

architecture Behavioral of TransmitterUART is

    type state_type is (IDLE, START, DATA, PARITY, STOP);
    signal PS, NS : state_type;
    signal data_reg : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal bit_count : integer range 0 to 7 := 0;
    signal parity_bit : STD_LOGIC := '0';

    -- registered signals drive output ports
    signal tx_status_reg : STD_LOGIC := '0';
    signal tx_out_reg : STD_LOGIC := '1';

begin  
    -- output signal assignment
    TX_STATUS <= tx_status_reg;
    TX_OUT <= tx_out_reg;

    -- state machine synchronous process covering state transition, bit shifting and parity bit calculation
    sync_process: process(TX_CLK, TX_RESET)
    begin
        if (TX_RESET = '1') then
            PS <= IDLE;
            data_reg <= (others => '0');
            bit_count <= 0;
            parity_bit <= '0';
        elsif rising_edge(TX_CLK) then
            PS <= NS;

            case PS is
                when IDLE =>
                    if TX_START = '1' then
                        -- Load the data and initialize the bit count and parity accumulator
                        data_reg <= TX_DATA_IN;
                        bit_count <= 0;
                        parity_bit <= '0';
                    end if;
                
                when DATA =>
                    -- update the parity accumulator using XOR
                    if data_reg(bit_count) = '1' then
                        parity_bit <= parity_bit xor '1';
                    end if;
                    if bit_count < 7 then
                        bit_count <= bit_count + 1;
                    end if;
                
                when others =>
                    null; -- no action needed
            end case;
        end if;
    end process sync_process;

    -- state machine combinational process
    comb_process: process(PS, TX_START, TX_CLK, bit_count, parity_bit)
    begin
        -- assign default output values to avoid latches
        tx_status_reg <= '0'; -- assume not busy
        tx_out_reg <= '1'; -- idle state
        NS <= PS;
        
        case PS is
            when IDLE =>
                tx_status_reg <= '0'; -- not busy
                tx_out_reg <= '1'; -- idle state
                if (TX_START = '1') then
                    NS <= START;
                end if;

            when START =>
                tx_status_reg <= '1';
                tx_out_reg <= '0'; -- Transmit start bit
                NS <= DATA;

            when DATA =>
                tx_status_reg <= '1'; 
                -- Output current data bit
                tx_out_reg <= data_reg(bit_count);
                if bit_count = 7 then
                    NS <= PARITY;
                else
                    NS <= DATA;
                end if;

            when PARITY =>
                tx_status_reg <= '1';
                -- Must invert the parity bit '0' for odd and '1' for even
                tx_out_reg <= not parity_bit; 
                NS <= STOP;
            
            when STOP =>
                tx_status_reg <= '1';
                tx_out_reg <= '1'; -- Transmit stop bit
                NS <= IDLE;
            
            when others =>
                NS <= IDLE;
                tx_status_reg <= '0';
                tx_out_reg <= '1';
        end case; 
    end process comb_process;   
end Behavioral;
