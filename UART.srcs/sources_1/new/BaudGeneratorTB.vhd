----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 08.04.2025 19:17:11
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BaudGeneratorTB is
end BaudGeneratorTB;

architecture TEST of BaudGeneratorTB is

    component BaudGenerator is
        generic (
            BAUD_RATE : integer := 9_600;
            CLOCK_FREQ : integer := 20_000_000
        );
        Port ( 
            CLK : in STD_LOGIC;
            RESET : in STD_LOGIC;
            BAUD_OUT_TX : out STD_LOGIC;
            BAUD_OUT_RX : out STD_LOGIC
        );
    end component;

    signal CLK_SIM : STD_LOGIC;
    signal RESET_SIM : STD_LOGIC;
    signal BAUD_OUT_TX_SIM : STD_LOGIC;
    signal BAUD_OUT_RX_SIM : STD_LOGIC;

begin
    UUT: BaudGenerator
        generic map (
            BAUD_RATE => 9_600,
            CLOCK_FREQ => 20_000_000
        )
        Port map (
            CLK => CLK_SIM,
            RESET => RESET_SIM,
            BAUD_OUT_TX => BAUD_OUT_TX_SIM,
            BAUD_OUT_RX => BAUD_OUT_RX_SIM
        );

    SIM: process
    begin
        RESET_SIM <= '1';
        wait for 1 ns;
        RESET_SIM <= '0';

        while true loop
            CLK_SIM <= '0';
            wait for 50 ns;
            CLK_SIM <= '1';
            wait for 50 ns;
        end loop;
        
        wait;
    end process SIM;
end TEST;
