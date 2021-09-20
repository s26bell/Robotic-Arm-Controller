library ieee;
use ieee.std_logic_1164.all;


entity Compx4 is port (
						four_bitA, four_bitB            : in  std_logic_vector(3 downto 0);
						A_GT_B, A_EQ_B, A_LT_B: out std_logic
					);
end Compx4;


architecture compare_logic4 of Compx4 is 

component Compx1
		  port ( 
			    bitA, bitB : in std_logic;
			    A_GT_B, A_EQ_B, A_LT_B: out std_logic
			    );
end component;

	signal A0_compare_B0, A1_compare_B1, A2_compare_B2, A3_compare_B3 : std_logic_vector(2 downto 0); 



begin 

compare_bit0 : Compx1 port map (four_bitA(0), four_bitB(0), A0_compare_B0(0), A0_compare_B0(1), A0_compare_B0(2));--LSB 

compare_bit1 : Compx1 port map (four_bitA(1), four_bitB(1), A1_compare_B1(0), A1_compare_B1(1), A1_compare_B1(2)); 

compare_bit2 : Compx1 port map (four_bitA(2), four_bitB(2), A2_compare_B2(0), A2_compare_B2(1), A2_compare_B2(2)); 

compare_bit3 : Compx1 port map (four_bitA(3), four_bitB(3), A3_compare_B3(0), A3_compare_B3(1), A3_compare_B3(2));--MSB 

A_GT_B <= A3_compare_B3(0) OR ((A3_compare_B3(1) AND ((A2_compare_B2(0) OR (A2_compare_B2(1) AND (A1_compare_B1(0) OR (A1_compare_B1(1) AND A0_compare_B0(0) )))))));

A_EQ_B <= A0_compare_B0(1) AND A1_compare_B1(1) AND A2_compare_B2(1) AND A3_compare_B3(1); 

A_LT_B <= A3_compare_B3(2) OR ((A3_compare_B3(1) AND ((A2_compare_B2(2) OR (A2_compare_B2(1) AND (A1_compare_B1(2) OR (A1_compare_B1(1) AND A0_compare_B0(2) )))))));

end compare_logic4; 