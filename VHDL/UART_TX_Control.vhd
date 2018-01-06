library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity UART_TX_Control is
	Port(
		clk			: in  STD_LOGIC;
		rst			: in  STD_LOGIC;
		status		: in  STD_LOGIC_VECTOR (2 downto 0);	-- empty, delay, done
		control		: out STD_LOGIC_VECTOR (2 downto 0)		-- reset counter, incr index, done
	);
end UART_TX_Control;

architecture Behavioral of UART_TX_Control is

	type state is (
		RESET,
		WAIT_DATA,
		SET_START,
		WAIT_CYCLE,
		INCR_INDEX,
		SET_STOP,
		TX_DONE
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
			when RESET		=> control <= "101";
			when WAIT_DATA	=> control <= "100";
			when SET_START	=> control <= "000";
			when WAIT_CYCLE	=> control <= "000";
			when INCR_INDEX	=> control <= "110";
			when SET_STOP	=> control <= "000";
			when TX_DONE	=> control <= "101";
			when others		=> control <= "000";
		end case;
	
		case presentState is					
			when RESET =>
				nextState <= WAIT_DATA;
				
			when WAIT_DATA =>
				if (status(0) = '0') then
					nextState <= SET_START;
				else
					nextState <= presentState;
				end if;
				
			when SET_START =>
				if (status(1) = '1') then
					nextState <= INCR_INDEX;
				else
					nextState <= presentState;
				end if;
			
			when WAIT_CYCLE =>
				if (status(1) = '1') then
					nextState <= INCR_INDEX;
				else
					nextState <= presentState;
				end if;
				
			when INCR_INDEX =>
				if (status(2) = '1') then
					nextState <= SET_STOP;
				else
					nextState <= WAIT_CYCLE;
				end if;
				
			when SET_STOP =>
				if (status(1) = '1') then
					nextState <= TX_DONE;
				else
					nextState <= presentState;
				end if;
								
			when TX_DONE =>
				nextState <= WAIT_DATA;
							
			when others =>
				nextState <= RESET; 			
		end case;
		
	end process;

end Behavioral;
