LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY LogicalStep_Lab4_top IS
   PORT
	(
   Clk			: in	std_logic;
	rst_n			: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); 
   leds			: out std_logic_vector(15 downto 0)	
	);
END LogicalStep_Lab4_top;

ARCHITECTURE Circuit OF LogicalStep_Lab4_top IS
	
	
component Bidir_shift_reg 
		port (
					CLK_IN        : in std_logic := '0';
					RESET_n       : in std_logic := '0';
					CLK_EN        : in std_logic := '0';
					LEFT0_RIGHT1  : in std_logic := '0';
					REG_BITS      : out std_logic_vector(7 downto 0)
    );
end component; 

component U_D_Bin_Counter8bit 
		port (
					CLK_IN            : in std_logic := '0';
					RESET_n           : in std_logic := '0';
					CLK_EN            : in std_logic := '0';
					UP1_DOWN0         : in std_logic := '0';
					COUNTER_BITS      : out std_logic_vector(7 downto 0)
    );
end component; 

component Compx4
		  port ( 
			    four_bitA, four_bitB     : in  std_logic_vector(3 downto 0);
				 A_GT_B, A_EQ_B, A_LT_B   : out std_logic
			    );
end component;

component Grappler
		  port ( 
			    grappler_ON    : in std_logic;
			    EXTpos         : in std_logic_vector(3 downto 0); 
			    grap_stat      : out std_logic
			    );
end component;

component Extender 
			port (
			Clk, rst_n, Extender_Toggle, Extend_enable      : in std_logic;
		   grap_enable                                     : out std_logic_vector(3 downto 0); 	
			extender_out                                    : out std_logic
					);
end component; 

component Mover 
			port (
			motion_toggle, extender_out, clk, rst_n                 : in std_logic;
		   x_target, y_target                              : in std_logic_vector(3 downto 0); 	
			x_pos, y_pos                                    : out std_logic_vector(3 downto 0); 
			System_Fault_ERROR, not_moving                  : out std_logic
					);
end component; 



			
			
signal x_target, y_target, EXTpos : std_logic_vector(3 downto 0);
signal MOTION, EXTENDER_IN, GRAPPLER_IN, GRAPSTAT, System_Fault_ERROR, ext_out, ext_enable: std_logic;
		
BEGIN
--INPUTS	
y_target <= sw(3 downto 0); 
x_target <= sw(7 downto 4);
GRAPPLER_IN <= pb(0);
EXTENDER_IN <= pb(1); 
MOTION <= pb(2);


--OUTPUTS
leds(0)<= System_Fault_ERROR;
leds(3) <= GRAPSTAT ;
leds(7 downto 4) <= EXTpos;  




--TEST
move : Mover port map (pb(2), ext_out, clk, rst_n, x_target, y_target, leds(15 downto 12), leds(11 downto 8), System_Fault_ERROR, ext_enable); 

--ext  : Extender port map ( Clk, rst_n, pb(0), sw(0), leds(7 downto 4), leds(1)); 

--grap : Grappler port map ( sw(0), sw(4 downto 1), GRAPSTAT ); 


--REAL
ext  : Extender port map ( Clk, rst_n, EXTENDER_IN, ext_enable, EXTpos, ext_out); 

grap : Grappler port map ( GRAPPLER_IN, EXTpos, GRAPSTAT ); 

--shifter : Bidir_shift_reg port map ( clk, pb(0), sw(0), sw(1), leds(7 downto 0));

--bit_shift : U_D_Bin_Counter8bit port map ( clk, pb(0), sw(0), sw(1), leds(7 downto 0));



END Circuit;
