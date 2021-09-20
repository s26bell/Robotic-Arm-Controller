LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity Grappler is port 
		(
			grappler_ON    : in std_logic;
			EXTpos         : in std_logic_vector(3 downto 0); 
			grap_stat      : out std_logic
		);
end Grappler; 

ARCHITECTURE one OF Grappler IS 

TYPE STATE_NAMES IS (closed, opened);

SIGNAL current_state, next_state : STATE_NAMES :=closed;

BEGIN

register_grappler : PROCESS (grappler_ON) is 

BEGIN 
		
		IF (falling_edge(grappler_ON)) THEN
		current_state <= next_state;
		
		END IF;
		
END PROCESS;
		

transition_grappler: PROCESS (EXTpos, grappler_ON, current_state) is 

		BEGIN
	
		CASE current_state IS
		
		WHEN opened => 
		
		IF(EXTpos = "1111" and grappler_ON ='1') THEN
			next_state <= closed;
			
		ELSE
			next_state <= opened;
		END IF;
--------------------------------------------------------------------------	
		WHEN closed =>
		
		IF(EXTpos ="1111" AND grappler_ON = '1') THEN
			next_state <= opened;
		ELSE
			next_state <= current_state; 
		END IF;
		
		END CASE;
		
END PROCESS; 
		
decoder_grappler : PROCESS (current_state) is 

	BEGIN
	
	CASE current_state IS 
	
		WHEN opened =>
		
		grap_stat <= '1';
		
		WHEN closed =>
		grap_stat <= '0';
		
	END CASE;
		
END PROCESS; 		
		
END one; 
