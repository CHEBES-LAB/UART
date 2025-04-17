----------------------------------------------------------------------------------
-- Company: Chebe's Lab
-- Engineer: Edgar Nyandoro
-- Create Date: 09.04.2025 20:11:50
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.NUMERIC_STD.ALL;

entity UART is
    Port (
        CLK : in STD_LOGIC;
        RESET : in STD_LOGIC;
        TX_START : in STD_LOGIC;
        TX_DATA_IN : in STD_LOGIC_VECTOR(7 downto 0);
        RX_IN : in STD_LOGIC;
        TX_STATUS : out STD_LOGIC;
        RX_STATUS : out STD_LOGIC;
        TX_OUT : out STD_LOGIC;
        RX_DATA_OUT : out STD_LOGIC_VECTOR(7 downto 0)
    );
end UART;

architecture Behavioral of UART is

    -- Baud generator signals
    signal SIM_BAUD_OUT_TX : STD_LOGIC;
    signal SIM_BAUD_OUT_RX : STD_LOGIC;

begin

    -- Baud generator
    BaudGenerator : entity work.BaudGenerator(Behavioral)
        generic map (
            BAUD_RATE => 9_600,
            CLOCK_FREQ => 20_000_000
        )
        Port map ( 
            CLK => CLK,
            RESET => RESET,
            BAUD_OUT_TX => SIM_BAUD_OUT_TX,
            BAUD_OUT_RX => SIM_BAUD_OUT_RX
        );
    
    -- Transmitter
    Transmitter : entity work.TransmitterUART(Behavioral)
        Port map (
            TX_CLK => SIM_BAUD_OUT_TX,
            TX_RESET => RESET,
            TX_START => TX_START,
            TX_DATA_IN => TX_DATA_IN, 
            TX_STATUS => TX_STATUS,
            TX_OUT => TX_OUT
        );
    
    -- Receiver
    Receiver : entity work.ReceiverUART(Behavioral)
        Port map (
            RX_CLK => SIM_BAUD_OUT_RX,
            RX_RESET => RESET,
            RX_IN => RX_IN,
            RX_STATUS => RX_STATUS,
            RX_DATA_OUT => RX_DATA_OUT
        );

end Behavioral;
