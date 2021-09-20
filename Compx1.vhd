library ieee;
use ieee.std_logic_1164.all;

entity Compx1 is port (
                       bitA, bitB : in std_logic;
							  A_GT_B, A_EQ_B, A_LT_B: out std_logic
							);
end Compx1;


architecture compare_logic1 of Compx1 is 
begin 
A_GT_B <= bitA AND (NOT bitB);
A_EQ_B <= ((NOT bitA) AND (NOt bitB)) OR (bitA AND bitB);
A_LT_B <= (NOT bitA) AND bitB; 
end compare_logic1; 