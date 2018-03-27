library ieee;
use ieee.std_logic_1164.all;



package sim_data_types is

	type adst_sim_data_type is record
		ip_reg:	std_logic_vector(7 downto 0);
	end record;
	
	
	type refi_sim_data_type is record
		wr_en:	std_logic;
		index:	std_logic_vector(1 downto 0);
		
		r0_reg:	std_logic_vector(7 downto 0);
		r1_reg:	std_logic_vector(7 downto 0);
		r2_reg:	std_logic_vector(7 downto 0);
		r3_reg:	std_logic_vector(7 downto 0);
	end record;
	
	
	type exst_sim_data_type is record
		refi_sim:			refi_sim_data_type;
		
		jmp_state:			std_logic;
		jmp_link:			std_logic;
		lda_state:			std_logic;
		
		ir_reg:				std_logic_vector(7 downto 0);
		a_reg_wr:			std_logic;
		a_reg:				std_logic_vector(7 downto 0);
	end record;
	
	
	type core_sim_data_type is record
		adst_sim:	adst_sim_data_type;
		exst_sim:	exst_sim_data_type;
	end record;

end sim_data_types;