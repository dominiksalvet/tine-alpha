library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tine_alpha;
use tine_alpha.sim_data_types.all;



entity core_debug_basys2 is
	port(	clk:			in  std_logic;
			rst:			in  std_logic;
			clk_rst:		in  std_logic;
			sw_array:	in  std_logic_vector(7 downto 0);
			--
			led_array:	out  std_logic_vector(7 downto 0);
			seg_sel:		out  std_logic_vector(3 downto 0);
			seg_data:	out  std_logic_vector(7 downto 0)
			);
end core_debug_basys2;



architecture behavioral of core_debug_basys2 is

	type STD_LOGIC_ARRAY_256_8 is array (255 downto 0) of std_logic_vector(7 downto 0);
	
	
	component clk_div_generic is
		generic(	ONE_CLK_MODE:			boolean := true;
					CLK_DIV_BIT_WIDTH:	positive
					);
		port(	clk:			in  std_logic;
				rst:			in  std_logic;
				--
				clk_div:		in  std_logic_vector(CLK_DIV_BIT_WIDTH - 1 downto 0);
				
				clk_out:		out  std_logic
				);
	end component;
	
	signal clk_div_core_clk_div:	std_logic_vector(23 downto 0);
	
	signal clk_div_core_clk_out:	std_logic;
	--
	signal clk_div_seven_seg_clk_out:	std_logic;
	

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
	
	signal core_imem_rd:			std_logic;
	signal core_imem_addr:		std_logic_vector(7 downto 0);
	--
	signal core_dmem_wr:			std_logic;
	signal core_dmem_addr:		std_logic_vector(7 downto 0);
	signal core_dmem_d_out:		std_logic_vector(7 downto 0);
	--
	signal core_sim:				core_sim_data_type;
	
	
	component imem is
		port(	clk:		in  std_logic;
				--
				rd_en:	in  std_logic;
				addr:		in  std_logic_vector(7 downto 0);
				
				d_out:	out  std_logic_vector(7 downto 0)
				);
	end component;
	
	signal imem_d_out:	std_logic_vector(7 downto 0);
	
	
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
	
	signal dmem_d_out:	std_logic_vector(7 downto 0);
	
	
	component hex_disp_contr_generic is
		generic(	LED_ON_VALUE:		std_logic := '0';
					LED_SEL_VALUE:		std_logic := '0';
					DIGIT_NUM:			positive := 4
					);
		port(	clk:			in  std_logic;
				rst:			in  std_logic;
				--
				data_in:		in  std_logic_vector((DIGIT_NUM * 4) - 1 downto 0);
				
				seg_sel:		out  std_logic_vector(DIGIT_NUM - 1 downto 0);
				seg_data:	out  std_logic_vector(7 downto 0)
				);
	end component;
	
	signal seven_seg_data_in:	std_logic_vector(15 downto 0);

begin
	
	led_array <= core_sim.exst_sim.ir_reg;
	

	clk_div_core_0: clk_div_generic
	generic map(
		CLK_DIV_BIT_WIDTH =>		24
		)
	port map(
		clk =>						clk,
		rst =>						clk_rst,
		--
		clk_div =>					clk_div_core_clk_div,
		
		clk_out =>					clk_div_core_clk_out
		);
	
	clk_div_core_clk_div <= sw_array & (15 downto 0 => '1');
	

	core_0: core port map(
		clk =>			clk_div_core_clk_out,
		rst =>			rst,
		--
		imem_d_in =>	imem_d_out,
		
		imem_rd =>		core_imem_rd,
		imem_addr =>	core_imem_addr,
		--
		dmem_d_in =>	dmem_d_out,
		
		dmem_wr =>		core_dmem_wr,
		dmem_addr =>	core_dmem_addr,
		dmem_d_out =>	core_dmem_d_out,
		--
		sim =>			core_sim
		);
		
		
	imem_0: imem port map(
		clk =>		clk_div_core_clk_out,
		--
		rd_en =>		core_imem_rd,
		addr =>		core_imem_addr,
		
		d_out =>		imem_d_out
		);
	
	
	dmem_0: rwm_generic port map(
		clk =>		clk_div_core_clk_out,
		--
		wr_en =>		core_dmem_wr,
		rd_en =>		'1',
		addr =>		core_dmem_addr,
		d_in =>		core_dmem_d_out,
		
		d_out =>		dmem_d_out
		);
		
		
	clk_div_seven_seg_0: clk_div_generic
	generic map(
		CLK_DIV_BIT_WIDTH =>		17
		)
	port map(
		clk =>						clk,
		rst =>						clk_rst,
		--
		clk_div =>					std_logic_vector(to_unsigned(100_000, 17)),
		
		clk_out =>					clk_div_seven_seg_clk_out
		);
	
	
	seven_seg_0: hex_disp_contr_generic port map(
		clk =>			clk_div_seven_seg_clk_out,
		rst =>			rst,
		--
		data_in =>		seven_seg_data_in,
		
		seg_sel =>		seg_sel,
		seg_data =>		seg_data
		);
	
	seven_seg_data_in <= core_sim.exst_sim.a_reg & core_sim.adst_sim.ip_reg;

end behavioral;