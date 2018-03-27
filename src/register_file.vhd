library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tine_alpha;
use tine_alpha.sim_data_types.all;



entity register_file is
	generic(	sim_en:	boolean := false
				);
	port(	clk:			in  std_logic;
			--
			wr_en:		in  std_logic;
			index:		in  std_logic_vector(1 downto 0);
			data_in:		in  std_logic_vector(7 downto 0);
			
			data_out:	out  std_logic_vector(7 downto 0);
			--
			sim:			out  refi_sim_data_type
			);
end register_file;



architecture behavioral of register_file is
	
	type mem_array is array (3 downto 0) of std_logic_vector(7 downto 0);
	signal reg_array: mem_array;
	
	signal sim_sig:	refi_sim_data_type;

begin

	data_out <= reg_array(to_integer(unsigned(index)));
	

	process(clk)
	begin
		if(rising_edge(clk)) then
			
			if (wr_en = '1') then
				reg_array(to_integer(unsigned(index))) <= data_in;
			end if;
			
		end if;
	end process;
	
	
	sim_sig.wr_en <=	wr_en;
	sim_sig.index <=	index;
	
	sim_sig.r0_reg <=	reg_array(0);
	sim_sig.r1_reg <=	reg_array(1);
	sim_sig.r2_reg <=	reg_array(2);
	sim_sig.r3_reg <=	reg_array(3);
	
	sim_switch:
	if(sim_en = true) generate
		sim <= sim_sig;
	end generate sim_switch;
	
end behavioral;