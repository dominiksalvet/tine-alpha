library ieee;
use ieee.std_logic_1164.all;



package alu_const is

	constant AO_SKNV: 	std_logic_vector(3 downto 0) := "0000";
	constant AO_SKIP: 	std_logic_vector(3 downto 0) := "0001";
	constant AO_SKNE: 	std_logic_vector(3 downto 0) := "0010";
	constant AO_SKE: 		std_logic_vector(3 downto 0) := "0011";
	constant AO_SKL: 		std_logic_vector(3 downto 0) := "0100";
	constant AO_SKLE: 	std_logic_vector(3 downto 0) := "0101";
	constant AO_SKG: 		std_logic_vector(3 downto 0) := "0110";
	constant AO_SKGE:		std_logic_vector(3 downto 0) := "0111";
	constant AO_AND: 		std_logic_vector(3 downto 0) := "1000";
	constant AO_NOR: 		std_logic_vector(3 downto 0) := "1001";
	constant AO_SLL: 		std_logic_vector(3 downto 0) := "1010";
	constant AO_SRL: 		std_logic_vector(3 downto 0) := "1011";
	constant AO_SLU: 		std_logic_vector(3 downto 0) := "1100";
	constant AO_SL: 		std_logic_vector(3 downto 0) := "1101";
	constant AO_SUB: 		std_logic_vector(3 downto 0) := "1110";
	constant AO_ADD: 		std_logic_vector(3 downto 0) := "1111";
	
end alu_const;