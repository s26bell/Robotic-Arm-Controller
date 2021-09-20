LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

Entity Mover is port 
		(
			motion_toggle, extender_out, clk, rst_n                 : in std_logic;
		   x_target, y_target                                      : in std_logic_vector(3 downto 0); 	
			x_pos, y_pos                                            : out std_logic_vector(3 downto 0); 
			System_Fault_ERROR, not_moving                          : out std_logic
		);
end Mover; 

ARCHITECTURE one OF Mover IS 


component Counter_4bit 
			port (
			CLK_IN            : in std_logic := '0';
			RESET_n           : in std_logic := '0';
			CLK_EN            : in std_logic := '0';
			UP1_DOWN0         : in std_logic := '0';
			COUNTER_BITS      : out std_logic_vector(3 downto 0)
        );
end component;

component Compx4 
			port (
			four_bitA, four_bitB            : in  std_logic_vector(3 downto 0);
			A_GT_B, A_EQ_B, A_LT_B          : out std_logic
        );
end component;




signal  clk_en_x, up_down_x, clk_en_y, up_down_y, not_move_signal : std_logic;
signal  X_EQ, X_GT, X_LT, Y_EQ, Y_GT, Y_LT : std_logic;   
signal  out_count_x, out_count_y, x_in, y_in : std_logic_vector(3 downto 0);  
------------------------------------------------------------------
BEGIN

x_pos <= out_count_x;
y_pos <= out_count_y;
not_moving <= not_move_signal;


Counter_X : Counter_4bit port map ( clk, rst_n, clk_en_x, up_down_x, out_count_x);  
Counter_Y : Counter_4bit port map ( clk, rst_n, clk_en_y, up_down_y, out_count_y); 

Comp_x: Compx4 port map (x_in, out_count_x, X_GT, X_EQ, X_LT);  
Comp_y: Compx4 port map (y_in, out_count_y, Y_GT, Y_EQ, Y_LT);  

------------------------------------------------------------------------------
moving: PROCESS (motion_toggle, extender_out, Y_EQ, X_EQ) is 

BEGIN
		IF(rst_n = '0')THEN
		x_in <= "0000";
		y_in <= "0000";
		System_Fault_ERROR <= '0';
		
		ElSIF(falling_edge(motion_toggle) AND not_move_signal= '1' AND extender_out = '0')THEN
		x_in <= x_target;
		y_in <= y_target;
			
		ElSIF(falling_edge(motion_toggle) AND extender_out ='1')THEN
		System_Fault_ERROR <= '1';
		
		END IF;
--------------------------------------------------------------------------------------------
		IF(extender_out = '0' AND X_EQ = '0')THEN
		clk_en_x <= '1';
		
		ELSE
		clk_en_x <= '0';
		
		END IF;
-------------------------------------------------------------------------------------------	
		IF(extender_out = '0' AND Y_EQ = '0')THEN
		clk_en_y <= '1';
		
		ELSE
		clk_en_y <= '0';
		
		END IF;

-------------------------------------------------------------------------------------------	
		IF(X_EQ = '0' OR Y_EQ= '0')THEN
		not_move_signal <='0';
		
		ELSE 
		not_move_signal <= '1';
		
		END IF;
--------------------------------------------------------------------------------------------		
		
		IF(X_LT= '1')THEN
		up_down_x <= '0';
		
		ELSIF(X_GT= '1')THEN
		up_down_x <= '1';
		
		END IF;

-----------------------
		
		IF(Y_LT= '1')THEN
		up_down_y <= '0';
		
		ELSIF(Y_GT= '1')THEN
		up_down_y <= '1';
		
		END IF;
-----------------------------------------------------------------------------	
		
		IF(extender_out = '0' AND rst_n = '1')THEN
		System_Fault_ERROR <= '0'; 
		
		END IF;


END PROCESS; 		



END one; 