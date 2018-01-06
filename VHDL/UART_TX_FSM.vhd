library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_TX_FSM is
	Port(
		clk			: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
		tx			: out STD_LOGIC;
		txData		: in  STD_LOGIC_VECTOR (7 downto 0);
		fifoEmpty	: in  STD_LOGIC;
		txDone		: out STD_LOGIC
	);
end UART_TX_FSM;

architecture Behavioral of UART_TX_FSM is

	component UART_TX_Control is
		Port(
			clk			: in  STD_LOGIC;
			rst			: in  STD_LOGIC;
			status		: in  STD_LOGIC_VECTOR (2 downto 0);	-- empty, delay, done
			control		: out STD_LOGIC_VECTOR (2 downto 0)		-- reset counter, incr index, done
		);
	end component;
	
	component UART_TX_Datapath is
		Port(
			clk			: in  STD_LOGIC;
			tx			: out STD_LOGIC;
			txData		: in  STD_LOGIC_VECTOR (7 downto 0);
			control		: in  STD_LOGIC_VECTOR (2 downto 0);
			status		: out STD_LOGIC_VECTOR (1 downto 0)
		);
	end component;
	
	signal status			:	STD_LOGIC_VECTOR (2 downto 0);
	signal control			:	STD_LOGIC_VECTOR (2 downto 0);
	signal datapathStatus	:	STD_LOGIC_VECTOR (1 downto 0);

begin

	status <= datapathStatus & fifoEmpty;
	txDone <= control(0);

	txControl: UART_TX_Control port map (
		clk		=> clk,
		rst		=> rst,
		status	=> status,
		control	=> control
	);
		
	txDatapath: UART_TX_Datapath port map (
		clk		=> clk,
		tx		=> tx,
		txData	=> txData,
		control	=> control,
		status	=> datapathStatus
	);

end Behavioral;
