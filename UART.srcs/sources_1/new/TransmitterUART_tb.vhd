----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 09.04.2025 00:19:01
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TransmitterUART_tb is
end TransmitterUART_tb;

architecture TEST of TransmitterUART_tb is
    --signals
    signal SIM_CLK : STD_LOGIC;
    signal SIM_RESET : STD_LOGIC;
    signal SIM_TX_START : STD_LOGIC;
    signal SIM_TX_STATUS : STD_LOGIC;
    signal SIM_TX_OUT : STD_LOGIC;
    signal SIM_TX_DATA_IN : STD_LOGIC_VECTOR(7 downto 0);
    signal BAUD_OUT_TX_SIM : STD_LOGIC;
    signal BAUD_OUT_RX_SIM : STD_LOGIC;

begin
    -- Data to be transmitted
    SIM_TX_DATA_IN <= B"00011001";

    -- Baud generator
    BAUD_GEN : entity work.BaudGenerator(Behavioral)
        generic map (
            BAUD_RATE => 9_600,
            CLOCK_FREQ => 20_000_000
        )
        Port map ( 
            CLK => SIM_CLK,
            RESET => SIM_RESET,
            BAUD_OUT_TX => BAUD_OUT_TX_SIM,
            BAUD_OUT_RX => BAUD_OUT_RX_SIM
        );

    
    -- Transmitter
    TRANSMITTER : entity work.TransmitterUART(Behavioral)
        Port map (
            TX_CLK => BAUD_OUT_TX_SIM,
            TX_RESET => SIM_RESET,
            TX_START => SIM_TX_START,
            TX_DATA_IN => SIM_TX_DATA_IN, 
            TX_STATUS => SIM_TX_STATUS,
            TX_OUT => SIM_TX_OUT
        );
    
    
    -- simulation
    SIM: process
    begin
        SIM_RESET <= '1';
        wait for 1 ns;
        SIM_RESET <='0';

        SIM_TX_START <= '0';
        wait for 1 ns;
        SIM_TX_START <= '1';

        -- clock loop
        while true loop
            SIM_CLK <= '0';
            wait for 50 ns;
            SIM_CLK <= '1';
            wait for 50 ns;
        end loop;
            
        wait;
    end process SIM;
end TEST;
