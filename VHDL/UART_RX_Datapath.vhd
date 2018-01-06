library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX_Datapath is
	Port(
		clk			: in  STD_LOGIC;
		rx			: in  STD_LOGIC;
		rxData		: out STD_LOGIC_VECTOR (7 downto 0);
		control		: in  STD_LOGIC_VECTOR (2 downto 0);
		status		: out STD_LOGIC_VECTOR (2 downto 0)
	);
end UART_RX_Datapath;

architecture Behavioral of UART_RX_Datapath is

	-- delay counter --
	signal delayCnt			:	UNSIGNED (7 downto 0) := (others => '0');
	-- index counter --
	signal indexCnt			:	UNSIGNED (2 downto 0) := (others => '0');

begin

	status(2) <= '1' when (delayCnt = 150) else '0';
	status(1) <= '1' when (delayCnt = 100) else '0';
	status(0) <= '1' when (control(0) = '1' and indexCnt = 7) else '0';

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
	
	-- rx data register --
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (control(1) = '1') then
				rxData(to_integer(indexCnt)) <= rx;
			end if;
		end if;
	end process;				
	
	-- index counter --
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (control(0) = '1') then
				indexCnt <= indexCnt + 1;
			end if;
		end if;
	end process;

end Behavioral;
