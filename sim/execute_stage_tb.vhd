library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tine_alpha;
use tine_alpha.fetch_stage_const.all;
use tine_alpha.sim_data_types.all;



entity execute_stage_tb is
end execute_stage_tb;



architecture behavioral of execute_stage_tb is

	component execute_stage is
		generic(	sim_en:		boolean := true
					);
		port(	clk:				in  std_logic;
				rst:				in  std_logic;
				
				skip_flag:		out  std_logic;
				lda_flag:		out  std_logic;
				jmp_flag:		out  std_logic;
				--
				inst_in:			in  std_logic_vector(7 downto 0);
				ip_in:			in  std_logic_vector(7 downto 0);
				
				alu_rslt:		out  std_logic_vector(7 downto 0);
				--
				dmem_d_in:		in  std_logic_vector(7 downto 0);
				
				dmem_wr:			out  std_logic;
				dmem_addr:		out  std_logic_vector(7 downto 0);
				dmem_d_out:		out  std_logic_vector(7 downto 0);
				--
				sim:				out  exst_sim_data_type
				);
	end component;
	
	signal clk:				std_logic := '0';
	signal rst:				std_logic := '0';
	
	signal skip_flag:		std_logic;
	signal lda_flag:		std_logic;
	signal jmp_flag:		std_logic;
	--
	signal inst_in:		std_logic_vector(7 downto 0) := (others => '0');
	signal ip_in:			std_logic_vector(7 downto 0) := (others => '0');
	
	signal alu_rslt:		std_logic_vector(7 downto 0);
	--
	signal dmem_d_in:		std_logic_vector(7 downto 0) := (others => '0');
	
	signal dmem_wr:		std_logic;
	signal dmem_addr:		std_logic_vector(7 downto 0);
	signal dmem_d_out:	std_logic_vector(7 downto 0);
	--
	signal sim:				exst_sim_data_type;
	
	
	constant CLK_PERIOD:		time := 10 ns;

begin
	
	uut: execute_stage port map(
		clk =>			clk,
		rst =>			rst,
		
		skip_flag =>	skip_flag,
		lda_flag =>		lda_flag,
		jmp_flag =>		jmp_flag,
		--
		inst_in =>		inst_in,
		ip_in =>			ip_in,
		
		alu_rslt =>		alu_rslt,
		--
		dmem_d_in =>	dmem_d_in,
		
		dmem_wr =>		dmem_wr,
		dmem_addr =>	dmem_addr,
		dmem_d_out =>	dmem_d_out,
		--
		sim =>			sim
		);
	
	
	clk_proc: process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
	
	stim_proc: process
	begin
		rst <= '1';
		wait for CLK_PERIOD;
		
		rst <= '0';
		inst_in <= NOP_INST;
		ip_in <= "01010101";
		dmem_d_in <= "10101010";
		wait for CLK_PERIOD;
		
		inst_in <= "01101111";
		wait for CLK_PERIOD;
		
		inst_in <= "00011100";
		wait for CLK_PERIOD;
		
		inst_in <= "01111111";
		wait for CLK_PERIOD;
		
		inst_in <= "00100000";
		wait for CLK_PERIOD;
		
		inst_in <= "00110000";
		wait for CLK_PERIOD;
		
		inst_in <= "00000010";
		wait for CLK_PERIOD;
		
		inst_in <= "00000011";
		wait;
	end process;

end behavioral;