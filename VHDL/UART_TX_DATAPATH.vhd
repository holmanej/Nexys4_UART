library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_TX_Datapath is
	Port(
		clk			: in  STD_LOGIC;
		tx			: out STD_LOGIC;
		txData		: in  STD_LOGIC_VECTOR (7 downto 0);
		control		: in  STD_LOGIC_VECTOR (2 downto 0);
		status		: out STD_LOGIC_VECTOR (1 downto 0)
	);
end UART_TX_Datapath;

architecture Behavioral of UART_TX_Datapath is

	-- delay counter --
	signal delayCnt		:	UNSIGNED (6 downto 0) := (others => '0');
	-- index counter --
	signal indexCnt		:	UNSIGNED (3 downto 0) := (others => '0');
	-- tx frame --
	signal txFrame		:	STD_LOGIC_VECTOR (9 downto 0);

begin

	txFrame <= txData & "01";
	tx <= txFrame(to_integer(indexCnt));
	
	status(0) <= '1' when (delayCnt = 100) else '0';
	status(1) <= '1' when (indexCnt = 8) else '0';

	-- delay counter --
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (control(2) = '1') then
				delayCnt <= (others => '0');
			else
				delayCnt <= delayCnt + 1;
			end if;
		end if;
	end process;
	
	-- index counter --
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (control(0) = '1') then
				indexCnt <= (others => '0');
			elsif (control(1) = '1') then
				indexCnt <= indexCnt + 1;
			end if;
		end if;
	end process;
	

end Behavioral;