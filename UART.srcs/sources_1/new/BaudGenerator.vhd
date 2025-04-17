----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 08.04.2025 18:52:16 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BaudGenerator is
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
end BaudGenerator;

architecture Behavioral of BaudGenerator is
    constant FULL_COUNT : integer := (CLOCK_FREQ / (2 * BAUD_RATE));
    constant HALF_COUNT : integer := FULL_COUNT / 2;

    signal counter : integer range 0 to FULL_COUNT - 1 := 0;
    signal baud_tick_tx : std_logic;
    signal baud_tick_rx : std_logic;
begin

    baud_process: process(CLK, RESET) is

    begin
        if (RESET = '1') then
            counter <= 0;
            baud_tick_tx <= '0';
            baud_tick_rx <= '0';
        elsif rising_edge(CLK) then
            if (counter = FULL_COUNT - 1) then
                baud_tick_tx <= not baud_tick_tx;
                counter<= 0;
            else
                counter <= counter + 1;
            end if;

            if (counter= HALF_COUNT - 1 and baud_tick_tx = '1') then
                baud_tick_rx <= '1';
            elsif (counter = FULL_COUNT - 1) then
                baud_tick_rx <= '0';
            end if;
        end if;
    end process baud_process;

    BAUD_OUT_TX <= baud_tick_tx;
    BAUD_OUT_RX <= baud_tick_rx;

end Behavioral;
