----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 09.04.2025 16:56:07
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ReceiverUART is
    port (
        RX_CLK : in STD_LOGIC;
        RX_RESET : in STD_LOGIC;
        RX_IN : in STD_LOGIC;
        RX_STATUS : out STD_LOGIC;
        RX_DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0) := (others => '0')
    );
end ReceiverUART;

architecture Behavioral of ReceiverUART is

    type state_type is (IDLE, DATA, PARITY, STOP);
    signal PS, NS : state_type;
    signal data_reg : STD_LOGIC_VECTOR(7 downto 0);
    signal bit_count : integer range 0 to 7 := 0;

    signal computed_parity : STD_LOGIC := '0';
    signal received_parity : STD_LOGIC := '0';
    signal rx_status_reg : STD_LOGIC := '0';

begin
    -- output signal assignment
    RX_STATUS <= rx_status_reg;
    RX_DATA_OUT <= data_reg;

    sync_process: process(RX_CLK, RX_RESET)
    begin
        if RX_RESET = '1' then
            PS <= IDLE;
            bit_count <= 0;
            data_reg <= (others => '0');
            computed_parity <= '0';
            received_parity <= '0';
        elsif rising_edge(RX_CLK) then
            PS <= NS;

            case PS is
                when IDLE =>
                    if RX_IN = '0' then  -- Start bit detected
                        bit_count <= 0;
                        computed_parity <= '0';
                    end if;
                
                when DATA =>
                    data_reg(bit_count) <= RX_IN;
                    if RX_IN = '1' then
                        computed_parity <= computed_parity xor '1';
                    end if;
                    if bit_count < 7 then
                        bit_count <= bit_count + 1;
                    end if;
                
                when PARITY =>
                    received_parity <= RX_IN;
                
                when STOP =>
                    null;
                
                when others =>
                    null;  -- No action in other states
            end case;
        end if;
    end process sync_process;

    comb_process: process(PS, RX_IN, bit_count, computed_parity, received_parity)
    begin

        -- assign default values
        NS <= PS;
        rx_status_reg <= '1';

        case PS is
            when IDLE =>
                rx_status_reg <= '0';  -- Not busy
                if RX_IN = '0' then
                    NS <= DATA;  -- Start receiving data
                else
                    NS <= IDLE;  -- Wait for start bit
                end if;
            
            when DATA =>
                if bit_count = 7 then
                    NS <= PARITY;
                else
                    NS <= DATA;  -- Continue receiving data
                end if;
            
            when PARITY =>
                if (not computed_parity) = received_parity then
                    NS <= STOP;  -- Parity check passed
                else
                    NS <= IDLE;  -- Parity check failed, go back to IDLE
                end if;

            when STOP =>
                if RX_IN = '1' then
                    NS <= IDLE;  -- Go back to IDLE state
                else
                    NS <= STOP;  -- Wait for stop bit
                end if;
            
            when others =>
                NS <= IDLE;  -- Default case
        end case;
    end process comb_process;                  
end Behavioral;
