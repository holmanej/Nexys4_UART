library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_FullDuplex_wFIFO is
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
end UART_FullDuplex_wFIFO;

architecture Behavioral of UART_FullDuplex_wFIFO is

	component FIFO_8to8 is
		Port(
			clk		: in  STD_LOGIC;
			srst	: in  STD_LOGIC;
			din		: in  STD_LOGIC_VECTOR (7 downto 0);
			wr_en	: in  STD_LOGIC;
			rd_en	: in  STD_LOGIC;
			dout	: out STD_LOGIC_VECTOR (7 downto 0);
			full	: out STD_LOGIC;
			empty	: out STD_LOGIC
		);
	end component;
	
	component UART_TX_FSM is
		Port(
			clk			: in  STD_LOGIC;
			rst			: in  STD_LOGIC;
			tx			: out STD_LOGIC;
			txData		: in  STD_LOGIC_VECTOR (7 downto 0);
			fifoEmpty	: in  STD_LOGIC;
			txDone		: out STD_LOGIC
		);
	end component;
	
	component UART_RX_FSM is
		Port(
			clk			: in  STD_LOGIC;
			rst			: in  STD_LOGIC;
			rx			: in  STD_LOGIC;
			rxData		: out STD_LOGIC_VECTOR (7 downto 0);
			rxDone		: out STD_LOGIC		
		);
	end component;
	
	signal txFifo_dout		:	STD_LOGIC_VECTOR (7 downto 0);
	signal txFifo_empty		:	STD_LOGIC;
	signal txFifo_rdEn		:	STD_LOGIC;
	
	signal rxFifo_din		:	STD_LOGIC_VECTOR (7 downto 0);
	signal rxFifo_wrEn		:	STD_LOGIC;

begin

	rxFifo: FIFO_8to8 port map (
		clk		=> clk,
		srst	=> reset,
		din		=> rxFifo_din,
		wr_en	=> rxFifo_wrEn,
		rd_en	=> rxGet,
		dout	=> rxData,
		full	=> rxFull,
		empty	=> rxEmpty
	);
	
	rxFSM: UART_RX_FSM port map (
		clk			=> clk,
		rst			=> reset,
		rx			=> RX,
		rxData		=> rxFifo_din,
		rxDone		=> rxFifo_wrEn
	);
		
	txFifo: FIFO_8to8 port map (
		clk		=> clk,
		srst	=> reset,
		din		=> txData,
		wr_en	=> txLoad,
		rd_en	=> txFifo_rdEn,
		dout	=> txFifo_dout,
		full	=> txFull,
		empty	=> txFifo_empty
	);
	txEmpty <= txFifo_empty;
	
	txFSM: UART_TX_FSM port map (
		clk			=> clk,
		rst			=> reset,
		tx			=> TX,
		txData		=> txFifo_dout,
		fifoEmpty	=> txFifo_empty,
		txDone		=> txFifo_rdEn
	);

end Behavioral;
