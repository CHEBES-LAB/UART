----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 09.04.2025 20:11:50
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity UART_tb is
end UART_tb;

architecture Behavioral of UART_tb is

    -- General signals
    signal SIM_RESET : STD_LOGIC;

    -- Signals for the transmitter
    signal SIM_TX_START : STD_LOGIC;
    signal SIM_TX_STATUS : STD_LOGIC;
    signal SIM_TX_OUT : STD_LOGIC;
    signal SIM_TX_DATA_IN : STD_LOGIC_VECTOR(7 downto 0);
    
    -- Signals for the receiver
    signal SIM_RX_IN : STD_LOGIC;
    signal SIM_RX_STATUS : STD_LOGIC;
    signal SIM_RX_DATA_OUT : STD_LOGIC_VECTOR(7 downto 0);

    -- Baud generator signals
    signal SIM_BAUD_OUT_TX : STD_LOGIC;
    signal SIM_BAUD_OUT_RX : STD_LOGIC;
    signal SIM_BAUD_CLK : STD_LOGIC;

begin
    -- Data to be transmitted
    SIM_TX_DATA_IN <= B"01011001"; -- X""59"

    -- Connect the transmitter output to the receiver input
    SIM_RX_IN <= SIM_TX_OUT;


    -- Baud generator
    BaudGenerator : entity work.BaudGenerator(Behavioral)
        generic map (
            BAUD_RATE => 9_600,
            CLOCK_FREQ => 20_000_000
        )
        Port map ( 
            CLK => SIM_BAUD_CLK,
            RESET => SIM_RESET,
            BAUD_OUT_TX => SIM_BAUD_OUT_TX,
            BAUD_OUT_RX => SIM_BAUD_OUT_RX
        );
    
    -- Transmitter
    Transmitter : entity work.TransmitterUART(Behavioral)
        Port map (
            TX_CLK => SIM_BAUD_OUT_TX,
            TX_RESET => SIM_RESET,
            TX_START => SIM_TX_START,
            TX_DATA_IN => SIM_TX_DATA_IN, 
            TX_STATUS => SIM_TX_STATUS,
            TX_OUT => SIM_TX_OUT
        );
    
    -- Receiver
    Receiver : entity work.ReceiverUART(Behavioral)
        Port map (
            RX_CLK => SIM_BAUD_OUT_RX,
            RX_RESET => SIM_RESET,
            RX_IN => SIM_RX_IN,
            RX_STATUS => SIM_RX_STATUS,
            RX_DATA_OUT => SIM_RX_DATA_OUT
        );
    
    
    -- Simulation of the reset signal
    SIM_RESET_GEN: process
    begin
        SIM_RESET <= '1';
        wait for 100 us;
        SIM_RESET <= '0';
        wait;
    end process SIM_RESET_GEN;

    -- Simulation of the transmitter start signal
    SIM_TX_START_GEN: process
    begin
        SIM_TX_START <= '0';
        wait for 100 us;
        SIM_TX_START <= '1';
        wait for 100 us;

        wait;
    end process SIM_TX_START_GEN;
    
    -- Simulation process
    SIM_GEN_CLK: process
    begin

        while true loop
            SIM_BAUD_CLK  <= '0';
            wait for 50 ns;
            SIM_BAUD_CLK  <= '1';
            wait for 50 ns;
        end loop;

        wait;
    end process SIM_GEN_CLK;

end Behavioral;
