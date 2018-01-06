library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX_FSM is
	Port(
		clk			: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
		rx			: in  STD_LOGIC;
		rxData		: out STD_LOGIC_VECTOR (7 downto 0);
		rxDone		: out STD_LOGIC		
	);
end UART_RX_FSM;

architecture Behavioral of UART_RX_FSM is

	component UART_RX_Control is
		Port(
			clk			: in  STD_LOGIC;
			rst			: in  STD_LOGIC;
			status		: in  STD_LOGIC_VECTOR (3 downto 0);	-- start delay, norm delay, done, rx
			control		: out STD_LOGIC_VECTOR (2 downto 0)		-- reset count, get bit, incr bit
		);
	end component;
	
	component UART_RX_Datapath is
		Port(
			clk			: in  STD_LOGIC;
			rx			: in  STD_LOGIC;
			rxData		: out STD_LOGIC_VECTOR (7 downto 0);
			control		: in  STD_LOGIC_VECTOR (2 downto 0);
			status		: out STD_LOGIC_VECTOR (2 downto 0)
		);
	end component;
	
	signal status		:	STD_LOGIC_VECTOR (3 downto 0);
	signal status_DP	:	STD_LOGIC_VECTOR (2 downto 0);
	signal control		:	STD_LOGIC_VECTOR (2 downto 0);

begin

	status <= status_DP & rx;
	rxDone <= status_DP(0);

	rxControl: UART_RX_Control port map (
		clk		=> clk,
		rst		=> rst,
		status	=> status,
		control	=> control
	);
	
	rxDatapath: UART_RX_Datapath port map (
		clk		=> clk,
		rx		=> rx,
		rxData	=> rxData,
		control	=> control,
		status	=> status_DP
	);

end Behavioral;
