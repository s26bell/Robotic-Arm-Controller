LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity Extender is port 
		(
			Clk, rst_n, Extender_Toggle, Extend_enable          : in std_logic;
			grap_enable                                         : out std_logic_vector(3 downto 0); 
			extender_out                                        : out std_logic
		);
end Extender; 

ARCHITECTURE one OF Extender IS 

TYPE STATE_NAMES IS (retracting, extending);

SIGNAL  current_state, next_state: STATE_NAMES;

SIGNAL clk_en, left_right: std_logic;
SIGNAL Extend_pos: std_logic_vector(3 downto 0); 

component Bidir_shift_4bit 

    port(
			CLK_IN        : in std_logic := '0';
			RESET_n       : in std_logic := '0';
			CLK_EN        : in std_logic := '0';
			LEFT0_RIGHT1  : in std_logic := '0';
			REG_BITS      : out std_logic_vector(3 downto 0)
        );
end component;

------------------------------------------------------------------
BEGIN


register_extender : PROCESS (Extender_Toggle) is 

BEGIN 
		IF(rst_n = '0') THEN
		current_state <= retracting;
		
		ELSIF (falling_edge(Extender_Toggle)) THEN
		current_state <= next_state;
		
		END IF;	
END PROCESS;
		
--inst for bit shifter
shift : Bidir_shift_4bit port map ( Clk, rst_n, '1', left_right, Extend_pos );
		
		
		
transition_extender: PROCESS (Extender_Toggle, Extend_enable, current_state) is 

		BEGIN
	
		CASE current_state IS
		
		WHEN extending => 
		
		IF(Extend_enable = '1' AND Extender_Toggle = '1') THEN
			next_state <= retracting;
			
			
		ELSE
		   next_state <= extending;

		END IF;
--------------------------------------------------------------------------	
		WHEN retracting =>
		
		IF(Extend_enable = '1' AND Extender_Toggle = '1') THEN
			next_state <= extending;
			
			
		ELSE
		   next_state <= retracting;
			
		END IF;
		
		END CASE;
		
END PROCESS; 
--------------------------------------------------------------------------	
decoder_extender: PROCESS (current_state) is 

	BEGIN
	
	CASE current_state IS 
	
		WHEN extending =>
		left_right <= '1'; 
		
		IF(Extend_pos ="0000")THEN
				extender_out <= '0';
		ELSE
				extender_out <= '1'; 
		END IF;
		
		
		WHEN retracting =>
		
		left_right <= '0'; 
		
		IF(Extend_pos = "0000") THEN
				extender_out <= '0';
		ELSE
		      extender_out <= '1';
		END IF;	 
			 
			 
			
	END CASE;
		
		grap_enable <= Extend_pos;
		
END PROCESS; 		

END one; 