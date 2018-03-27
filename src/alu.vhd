library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tine_alpha;
use tine_alpha.alu_const.all;



entity alu is
	port(	stream_t:	in  std_logic;
			stream_b:	in  std_logic;
			--
			op_code:		in  std_logic_vector(3 downto 0);
			operand_t:	in  std_logic_vector(7 downto 0);
			operand_b:	in  std_logic_vector(7 downto 0);
			
			skip_flag:	out  std_logic;
			result:		out  std_logic_vector(7 downto 0)
			);
end alu;



architecture behavioral of alu is

	signal sub_add_sw:		std_logic;
	signal adder_result:		std_logic_vector(8 downto 0);
	
	signal unsigned_bt_less:	std_logic;
	signal signed_bt_less:		std_logic;
	signal bt_equal:				std_logic;
	
	signal skip_flag_prep:	std_logic;
	signal result_prep:		std_logic_vector(7 downto 0);

begin

	sub_add_sw <=	'0' when op_code = AO_ADD
						else '1';
	
	adder_result <= std_logic_vector(
		unsigned('0' & (operand_t xor (7 downto 0 => sub_add_sw))) +
		unsigned('0' & operand_b) + unsigned'(0 => sub_add_sw)
		);
		
	unsigned_bt_less <= not adder_result(8);
	
	signed_bt_less <=	not adder_result(8) when operand_t(7) = operand_b(7) else
							not operand_t(7) and operand_b(7);
	
	bt_equal <=	'1' when operand_t = operand_b
					else '0';
	
	with op_code select skip_flag_prep <=
		not unsigned_bt_less when AO_SKGE,
		not unsigned_bt_less and not bt_equal when AO_SKG,
		unsigned_bt_less or bt_equal when AO_SKLE,
		unsigned_bt_less when AO_SKL,
		bt_equal when AO_SKE,
		not bt_equal when AO_SKNE,
		'1' when AO_SKIP,
		'0' when others;
	
	skip_flag <=	skip_flag_prep when stream_b = '0' and stream_t = '0'
						else '0';
	
	with op_code select result_prep <=
		adder_result(7 downto 0) when AO_ADD,
		adder_result(7 downto 0) when AO_SUB,
		(0 => signed_bt_less, others => '0') when AO_SL,
		(0 => unsigned_bt_less, others => '0') when AO_SLU,
		std_logic_vector(shift_right(unsigned(operand_b), to_integer(unsigned(operand_t(2 downto 0))))) when AO_SRL,
		std_logic_vector(shift_left(unsigned(operand_b), to_integer(unsigned(operand_t(2 downto 0))))) when AO_SLL,
		operand_t nor operand_b when AO_NOR,
		operand_t and operand_b when others;
	
	result <=	operand_t when stream_t = '1' else
					operand_b when stream_b = '1'
					else result_prep;
	
end behavioral;