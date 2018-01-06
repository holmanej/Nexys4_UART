library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_RX_Control is
	Port(
		clk			: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
		status		: in  STD_LOGIC_VECTOR (3 downto 0);	-- start delay, norm delay, done, rx
		control		: out STD_LOGIC_VECTOR (2 downto 0)		-- reset count, get bit, incr bit
	);
end UART_RX_Control;

architecture Behavioral of UART_RX_Control is

	type state is (
		RESET,
		WAIT_START,
		IDLE_START,
		IDLE_CYCLE,
		GET_BIT,
		INCR_INDEX,
		IDLE_STOP
	);
	
	signal presentState		:	state;
	signal nextState		:	state := RESET;

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				presentState <= RESET;
			else
				presentState <= nextState;
			end if;
		end if;
	end process;
	
	process(presentState, status)
	begin
	
		case presentState is
			when RESET		=> control <= "100";
			when WAIT_START	=> control <= "100";
			when IDLE_START	=> control <= "000";
			when IDLE_CYCLE	=> control <= "000";
			when GET_BIT	=> control <= "010";
			when INCR_INDEX	=> control <= "101";
			when IDLE_STOP	=> control <= "000";
			when others		=> control <= "000";
		end case;
		
		case presentState is
			when RESET =>
				nextState <= WAIT_START;
				
			when WAIT_START =>
				if (status(0) = '0') then
					nextState <= IDLE_START;
				else
					nextState <= presentState;
				end if;
				
			when IDLE_START	=>
				if (status(3) = '1') then
					nextState <= GET_BIT;
				else
					nextState <= presentState;
				end if;
				
			when IDLE_CYCLE	=>
				if (status(2) = '1') then
					nextState <= GET_BIT;
				else
					nextState <= presentState;
				end if;
				
			when GET_BIT =>
				nextState <= INCR_INDEX;
				
			when INCR_INDEX	=>
				if (status(1) = '1') then
					nextState <= IDLE_STOP;
				else
					nextState <= IDLE_CYCLE;
				end if;
				
			when IDLE_STOP =>
				if (status(2) = '1') then
					nextState <= WAIT_START;
				else
					nextState <= presentState;
				end if;
				
			when others =>
				nextState <= RESET;
		end case;
				
	end process;

end Behavioral;
