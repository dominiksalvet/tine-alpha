library ieee;
use ieee.std_logic_1164.all;

library tine_alpha;
use tine_alpha.alu_const.all;
use tine_alpha.fetch_stage_const.all;
use tine_alpha.sim_data_types.all;



entity execute_stage is
	generic(	sim_en:		boolean := false
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
end execute_stage;



architecture behavioral of execute_stage is

	component register_file is
		generic(	sim_en:	boolean := sim_en
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
	end component;
	
	signal refi_wr_en:		std_logic;
	
	signal refi_data_out:	std_logic_vector(7 downto 0);
	

	component alu is
		port(	stream_t:	in  std_logic;
				stream_b:	in  std_logic;
				--
				op_code:		in  std_logic_vector(3 downto 0);
				operand_t:	in  std_logic_vector(7 downto 0);
				operand_b:	in  std_logic_vector(7 downto 0);
				
				skip_flag:	out  std_logic;
				result:		out  std_logic_vector(7 downto 0)
				);
	end component;
	
	signal alu_stream_t:		std_logic;
	signal alu_stream_b:		std_logic;
	--
	signal alu_op_code:		std_logic_vector(3 downto 0);
	signal alu_operand_t:	std_logic_vector(7 downto 0);
	signal alu_operand_b:	std_logic_vector(7 downto 0);
	
	signal alu_skip_flag:	std_logic;
	signal alu_result:		std_logic_vector(7 downto 0);
	
	
	signal jmp_state:		std_logic;
	signal jmp_link:		std_logic;
	signal lda_state:		std_logic;

	signal ir_reg:		std_logic_vector(7 downto 0);
	signal ip_reg:		std_logic_vector(7 downto 0);
	signal a_reg:		std_logic_vector(7 downto 0);
	
	
	signal a_reg_wr:		std_logic;
	
	signal copy_inst:		std_logic;
	signal dmem_inst:		std_logic;
	signal li_inst:		std_logic;
	signal jmp_inst:		std_logic;
	signal jmpa_inst:		std_logic;
	
	signal sign_ext_imm:		std_logic_vector(7 downto 0);
	signal li_imm:				std_logic_vector(7 downto 0);
	
	signal jmp_flag_sig:		std_logic;
	signal lda_flag_sig:		std_logic;
	
	signal sim_sig:	exst_sim_data_type;

begin

	skip_flag <= alu_skip_flag;
	
	dmem_inst <=	'1' when ir_reg(7 downto 3) = "00010"
						else '0';
	
	lda_flag_sig <=	'1' when dmem_inst = '1' and ir_reg(2) = '0'
							else '0';
	
	lda_flag <= lda_flag_sig;
	
	jmp_inst <=	'1' when ir_reg(7 downto 5) = "010"
					else '0';
	
	jmpa_inst <=	'1' when ir_reg(7 downto 1) = "0000111"
						else '0';
	
	jmp_flag_sig <= jmp_inst or jmpa_inst;

	jmp_flag <= jmp_flag_sig;
	--
	result <= alu_result;
	--
	dmem_wr <=	'1' when dmem_inst = '1' and ir_reg(2) = '1'
					else '0';
	
	dmem_addr <= refi_data_out;
	
	dmem_d_out <= a_reg;
	
	
	register_file_0: register_file port map(
		clk =>			clk,
		--
		wr_en =>			refi_wr_en,
		index =>			ir_reg(1 downto 0),
		data_in =>		alu_result,
		
		data_out =>		refi_data_out,
		--
		sim =>			sim_sig.refi_sim
		);
	
	copy_inst <=	'1' when ir_reg(7 downto 3) = "00011"
						else '0';
	
	refi_wr_en <=	'1' when copy_inst = '1' and ir_reg(2) = '1'
						else '0';
	
	
	alu_0: alu port map(
		stream_t =>		alu_stream_t,
		stream_b =>		alu_stream_b,
		--
		op_code =>		alu_op_code,
		operand_t =>	alu_operand_t,
		operand_b =>	alu_operand_b,
		
		skip_flag =>	alu_skip_flag,
		result =>		alu_result
		);
	
	li_inst <=	'1' when ir_reg(7 downto 5) = "011"
					else '0';
	
	alu_stream_t <=	'1' when li_inst = '1' or (copy_inst = '1' and ir_reg(2) = '0')
							else '0';
	
	alu_stream_b <= '1' when
		(copy_inst = '1' and ir_reg(2) = '1') or
		jmpa_inst = '1' or (jmp_state = '1' and jmp_link = '1')
		else '0';
	
	alu_op_code <=
		ir_reg(7 downto 4) when ir_reg(7) = '1' else
		ir_reg(5 downto 2) when ir_reg(7 downto 5) = "001" else
		ir_reg(3 downto 0) when ir_reg(7 downto 3) = "00000"
		else AO_ADD;
	
	li_imm <=	(3 downto 0 => '0') & ir_reg(3 downto 0) when ir_reg(4) = '0'
					else ir_reg(3 downto 0) & (3 downto 0 => '0');
	
	sign_ext_imm <=	li_imm when li_inst = '1'
							else (3 downto 0 => ir_reg(3)) & ir_reg(3 downto 0);
	
	alu_operand_t <=
		refi_data_out when ir_reg(7 downto 6) = "00" and (ir_reg(5) = '1' or ir_reg(4 downto 2) = "110") else
		"00000000" when ir_reg(7 downto 3) = "00000"
		else sign_ext_imm;
	
	alu_operand_b <=	ip_reg when jmp_inst = '1' or (jmp_state = '1' and jmp_link = '1')
							else a_reg;
	
	
	a_reg_wr <= '1' when
		ir_reg(7) = '1' or ir_reg(7 downto 5) = "011" or
		ir_reg(7 downto 5) = "001" or ir_reg(7 downto 2) = "000110" or
		(jmp_state = '1' and jmp_link = '1') or lda_state = '1'
		else '0';
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				
				jmp_state <= '0';
				lda_state <= '0';
				ir_reg <= NOP_INST;
			
			else
				
				ip_reg <= ip_in;
				ir_reg <= inst_in;
				
				if (a_reg_wr = '1') then
					if (lda_state = '1') then
						a_reg <= dmem_d_in;
					else
						a_reg <= alu_result;
					end if;
				end if;
				
				if (jmp_state = '1') then
					jmp_state <= '0';
				elsif (jmp_flag_sig = '1') then
					jmp_state <= '1';
					if (jmp_inst = '1') then
						jmp_link <= not ir_reg(4);
					else
						jmp_link <= not ir_reg(0);
					end if;
				end if;
				
				if (lda_state = '1') then
					lda_state <= '0';
				elsif (lda_flag_sig = '1') then
					lda_state <= '1';
				end if;
				
			end if;
		end if;
	end process;
	
	
	sim_sig.jmp_state <=		jmp_state;
	sim_sig.jmp_link <=		jmp_link;
	sim_sig.lda_state <=		lda_state;
	
	sim_sig.ir_reg <=		ir_reg;
	sim_sig.a_reg_wr <=	a_reg_wr;
	sim_sig.a_reg <=		a_reg;
	
	sim_switch:
	if (sim_en = true) generate
		sim <= sim_sig;
	end generate sim_switch;

end behavioral;