----------------------------------------------------------------------------------
-- Company: Chebe's Lab 
-- Engineer: Edgar Nyandoro
-- Create Date: 09.04.2025 20:10:35
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity ReceiverUART_tb is
end ReceiverUART_tb;

architecture Behavioral of ReceiverUART_tb is

    signal SIM_CLK : STD_LOGIC;
    signal SIM_RESET : STD_LOGIC;
    signal SIM_RX_IN : STD_LOGIC;
    signal SIM_RX_STATUS : STD_LOGIC;
    signal SIM_RX_DATA_OUT : STD_LOGIC_VECTOR(7 downto 0);
    signal BAUD_OUT_TX_SIM : STD_LOGIC;
    signal BAUD_OUT_RX_SIM : STD_LOGIC;

begin

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
    
    -- Receiver
    RECEIVER : entity work.ReceiverUART(Behavioral)
        Port map (
            RX_CLK => BAUD_OUT_RX_SIM,
            RX_RESET => SIM_RESET,
            RX_IN => SIM_RX_IN,
            RX_STATUS => SIM_RX_STATUS,
            RX_DATA_OUT => SIM_RX_DATA_OUT
        );

    -- simulation
    SIM1: process
    begin
        SIM_RESET <= '1';
        wait for 100 ns;
        SIM_RESET <= '0';

        -- clock loop
        while true loop
            SIM_CLK <= '0';
            wait for 50 ns;
            SIM_CLK <= '1';
            wait for 50 ns;
        end loop;

        wait;
    end process SIM1;

    SIM2: process
    begin
        
        for i in 1 to 5 loop
            SIM_RX_IN <= '1'; -- Idle state
            wait until rising_edge(BAUD_OUT_TX_SIM);
        end loop;

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '0'; -- Start bit

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '1'; -- Data bit 0

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '0'; -- Data bit 1

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '0'; -- Data bit 2

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '1'; -- Data bit 3

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '1'; -- Data bit 4

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '0'; -- Data bit 5

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '0'; -- Data bit 6

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '1'; -- Data bit 7

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '1'; -- Parity bit

        wait until rising_edge(BAUD_OUT_TX_SIM);
        SIM_RX_IN <= '1'; -- Stop bit

        for i in 1 to 3 loop
            wait until rising_edge(BAUD_OUT_TX_SIM);
            SIM_RX_IN <= '1'; -- Idle state
        end loop;

        wait;
    end process SIM2;

end Behavioral;
