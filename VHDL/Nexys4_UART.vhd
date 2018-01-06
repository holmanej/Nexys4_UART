library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Nexys4_UART is
	port(
		CLK		: in  STD_LOGIC;
		-- UART --
		RX		: in  STD_LOGIC;
		TX		: out STD_LOGIC
	);
end Nexys4_UART;
	
architecture Behavioral of Nexys4_UART is

	component UART_FullDuplex_wFIFO is
		Port(
			clk			: in  STD_LOGIC;
			reset		: in  STD_LOGIC;
			-- UART --
			RX			: in  STD_LOGIC;
			TX			: out STD_LOGIC;
			-- RX --
			rxData		: out STD_LOGIC_VECTOR (7 downto 0);
			rxGet		: in  STD_LOGIC;
			rxEmpty		: out STD_LOGIC;
			rxFull		: out STD_LOGIC;
			-- TX --
			txData		: in  STD_LOGIC_VECTOR (7 downto 0);
			txLoad		: in  STD_LOGIC;
			txEmpty		: out STD_LOGIC;
			txFull		: out STD_LOGIC
		);
	end component;
	
	signal data		:	STD_LOGIC_VECTOR (7 downto 0);
	signal rxEmpty	:	STD_LOGIC;

begin

	UART: UART_FullDuplex_wFIFO port map (
		clk			=> CLK,
		reset		=> '0',
		RX			=> RX,
		TX			=> TX,
		rxData		=> data,
		rxGet		=> not rxEmpty,
		rxEmpty		=> rxEmpty,
		rxFull		=> open,
		txData		=> data,
		txLoad		=> not rxEmpty,
		txEmpty		=> open,
		txFull		=> open
	);

end Behavioral;