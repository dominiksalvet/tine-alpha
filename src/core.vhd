library ieee;
use ieee.std_logic_1164.all;

library tine_alpha;
use tine_alpha.sim_data_types.all;



entity core is
	generic(	sim_en:	boolean := false
				);
	port(	clk:				in  std_logic;
			rst:				in  std_logic;
			--
			imem_d_in:		in  std_logic_vector(7 downto 0);
			
			imem_rd:			out  std_logic;
			imem_addr:		out  std_logic_vector(7 downto 0);
			--
			dmem_d_in:		in  std_logic_vector(7 downto 0);
			
			dmem_wr:			out  std_logic;
			dmem_addr:		out  std_logic_vector(7 downto 0);
			dmem_d_out:		out  std_logic_vector(7 downto 0);
			--
			sim:				out  core_sim_data_type
			);
end core;



architecture behavioral of core is

	component address_stage is
		generic(	sim_en:	boolean := sim_en
					);
		port(	clk:			in  std_logic;
				rst:			in  std_logic;
				stall:		in  std_logic;
				
				jmp_ack:		out  std_logic;
				--
				jmp_en:		in  std_logic;
				jmp_addr:	in  std_logic_vector(7 downto 0);
				
				ip_out:		out  std_logic_vector(7 downto 0);
				--
				sim:			out  adst_sim_data_type
				);
	end component;
	
	signal adst_jmp_ack:		std_logic;
	--
	signal adst_ip_out:		std_logic_vector(7 downto 0);
	
	
	component fetch_stage is
		port(	clk:			in  std_logic;
				rst:			in  std_logic;
				stall:		in  std_logic;
				fetch_nop:	in  std_logic;
				--
				ip_in:		in  std_logic_vector(7 downto 0);
				
				inst_out:	out  std_logic_vector(7 downto 0);
				ip_out:		out  std_logic_vector(7 downto 0);
				--
				imem_d_in:	in  std_logic_vector(7 downto 0);
				
				imem_rd:		out  std_logic;
				imem_addr:	out  std_logic_vector(7 downto 0)
				);
	end component;
	
	signal fest_inst_out:	std_logic_vector(7 downto 0);
	signal fest_ip_out:		std_logic_vector(7 downto 0);
	
	
	component execute_stage is
		generic(	sim_en:		boolean := sim_en
					);
		port(	clk:				in  std_logic;
				rst:				in  std_logic;
				
				skip_flag:		out  std_logic;
				lda_flag:		out  std_logic;
				jmp_flag:		out  std_logic;
				--
				inst_in:			in  std_logic_vector(7 downto 0);
				ip_in:			in  std_logic_vector(7 downto 0);
				
				result:			out  std_logic_vector(7 downto 0);
				--
				dmem_d_in:		in  std_logic_vector(7 downto 0);
				
				dmem_wr:			out  std_logic;
				dmem_addr:		out  std_logic_vector(7 downto 0);
				dmem_d_out:		out  std_logic_vector(7 downto 0);
				--
				sim:				out  exst_sim_data_type
				);
	end component;
	
	signal exst_skip_flag:	std_logic;
	signal exst_lda_flag:	std_logic;
	signal exst_jmp_flag:	std_logic;
	--
	signal exst_result:		std_logic_vector(7 downto 0);
	
	
	component hazard_unit is
		port(	clk:			in  std_logic;
				rst:			in  std_logic;
				--
				skip_ack:	in  std_logic;
				lda_ack:		in  std_logic;
				jmp_start:	in  std_logic;
				jmp_cmplt:	in  std_logic;
				
				fetch_nop:	out  std_logic;
				stall_sig:	out  std_logic
				);
	end component;
	
	signal haun_fetch_nop:	std_logic;
	signal haun_stall_sig:	std_logic;
	
	
	signal sim_sig:	core_sim_data_type;

begin

	address_stage_0: address_stage port map(
		clk =>			clk,
		rst =>			rst,
		stall =>			haun_stall_sig,
		
		jmp_ack =>		adst_jmp_ack,
		--
		jmp_en =>		exst_jmp_flag,
		jmp_addr =>		exst_result,
		
		ip_out =>		adst_ip_out,
		--
		sim =>			sim_sig.adst_sim
		);
	
	
	fetch_stage_0: fetch_stage port map(
		clk =>			clk,
		rst =>			rst,
		stall =>			haun_stall_sig,
		fetch_nop =>	haun_fetch_nop,
		--
		ip_in =>			adst_ip_out,
		
		inst_out =>		fest_inst_out,
		ip_out =>		fest_ip_out,
		--
		imem_d_in =>	imem_d_in,
		
		imem_rd =>		imem_rd,
		imem_addr =>	imem_addr
		);
	
	
	execute_stage_0: execute_stage port map(
		clk =>			clk,
		rst =>			rst,
		
		skip_flag =>	exst_skip_flag,
		lda_flag =>		exst_lda_flag,
		jmp_flag =>		exst_jmp_flag,
		--
		inst_in =>		fest_inst_out,
		ip_in =>			fest_ip_out,
		
		result =>		exst_result,
		--
		dmem_d_in =>	dmem_d_in,
		
		dmem_wr =>		dmem_wr,
		dmem_addr =>	dmem_addr,
		dmem_d_out =>	dmem_d_out,
		--
		sim =>			sim_sig.exst_sim
		);
	
	
	hazard_unit_0: hazard_unit port map(
		clk =>			clk,
		rst =>			rst,
		--
		skip_ack =>		exst_skip_flag,
		lda_ack =>		exst_lda_flag,
		jmp_start =>	exst_jmp_flag,
		jmp_cmplt =>	adst_jmp_ack,
		
		fetch_nop =>	haun_fetch_nop,
		stall_sig =>	haun_stall_sig
		);
		
		
	sim_switch:
	if (sim_en = true) generate
		sim <= sim_sig;
	end generate sim_switch;

end behavioral;