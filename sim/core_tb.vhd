library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tine_alpha;
use tine_alpha.sim_data_types.all;



entity core_tb is
end core_tb;



architecture behavioral of core_tb is

	component core is
		generic(	sim_en:	boolean := true
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
	end component;
	
	signal clk:				std_logic := '0';
	signal rst:				std_logic := '0';
	--
	signal imem_d_in:		std_logic_vector(7 downto 0) := (others => '0');
	
	signal imem_rd:		std_logic;
	signal imem_addr:		std_logic_vector(7 downto 0);
	--
	signal dmem_d_in:		std_logic_vector(7 downto 0) := (others => '0');
	
	signal dmem_wr:		std_logic;
	signal dmem_addr:		std_logic_vector(7 downto 0);
	signal dmem_d_out:	std_logic_vector(7 downto 0);
	--
	signal sim:				core_sim_data_type;
	
	
	component imem is
		port(	clk:		in  std_logic;
				--
				rd_en:	in  std_logic;
				addr:		in  std_logic_vector(7 downto 0);
				
				d_out:	out  std_logic_vector(7 downto 0)
				);
	end component;
	
	
	component rwm_generic is
		generic(	ADDR_BIT_WIDTH:	natural := 8;
					DATA_BIT_WIDTH:	positive := 8
					);
		port(	clk:		in  std_logic;
				--
				wr_en:	in  std_logic;
				rd_en:	in  std_logic;
				addr:		in  std_logic_vector(ADDR_BIT_WIDTH - 1 downto 0);
				d_in:		in  std_logic_vector(DATA_BIT_WIDTH - 1 downto 0);
				
				d_out:	out  std_logic_vector(DATA_BIT_WIDTH - 1 downto 0)
				);
	end component;
	
	
	constant CLK_PERIOD:		time := 10 ns;

begin
	
	uut: core port map(
		clk =>			clk,
		rst =>			rst,
		--
		imem_d_in =>	imem_d_in,
		
		imem_rd =>		imem_rd,
		imem_addr =>	imem_addr,
		--
		dmem_d_in =>	dmem_d_in,
		
		dmem_wr =>		dmem_wr,
		dmem_addr =>	dmem_addr,
		dmem_d_out =>	dmem_d_out,
		--
		sim =>			sim
		);
	
	
	imem_0: imem port map(
		clk =>		clk,
		--
		rd_en =>		imem_rd,
		addr =>		imem_addr,
		
		d_out =>		imem_d_in
		);
	
	
	dmem_0: rwm_generic port map(
		clk =>		clk,
		--
		wr_en =>		dmem_wr,
		rd_en =>		'1',
		addr =>		dmem_addr,
		d_in =>		dmem_d_out,
		
		d_out =>		dmem_d_in
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
		wait;
	end process;

end behavioral;