library ieee;
use ieee.std_logic_1164.all;



entity hex_disp_contr_generic is
	generic(	LED_ON_VALUE:		std_logic;
				LED_SEL_VALUE:		std_logic;
				DIGIT_NUM:			positive
				);
	port(	clk:			in  std_logic;
			rst:			in  std_logic;
			--
			data_in:		in  std_logic_vector((DIGIT_NUM * 4) - 1 downto 0);
			
			seg_sel:		out  std_logic_vector(DIGIT_NUM - 1 downto 0);
			seg_data:	out  std_logic_vector(7 downto 0)
			);
end hex_disp_contr_generic;



architecture behavioral of hex_disp_contr_generic is

	constant DIGIT_0_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000001";
	constant DIGIT_1_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1001111";
	constant DIGIT_2_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0010010";
	constant DIGIT_3_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000110";
	constant DIGIT_4_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1001100";
	constant DIGIT_5_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0100100";
	constant DIGIT_6_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0100000";
	constant DIGIT_7_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0001111";
	constant DIGIT_8_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000000";
	constant DIGIT_9_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000100";
	constant DIGIT_A_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0001000";
	constant DIGIT_B_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1100000";
	constant DIGIT_C_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0110001";
	constant DIGIT_D_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1000010";
	constant DIGIT_E_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0110000";
	constant DIGIT_F_IMAGE:		std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0111000";


	signal seg_sel_reg:		std_logic_vector(DIGIT_NUM - 1 downto 0);
	signal seg_sel_index:	natural range 0 to DIGIT_NUM - 1;
	
	signal dig_bin_data:		std_logic_vector(3 downto 0);
	signal dig_seg_data:		std_logic_vector(6 downto 0);

begin

	seg_sel <= seg_sel_reg;

	dig_bin_data <= data_in((seg_sel_index * 4) + 3 downto (seg_sel_index * 4));

	with dig_bin_data select dig_seg_data <=
		DIGIT_0_IMAGE when "0000",
		DIGIT_1_IMAGE when "0001",
		DIGIT_2_IMAGE when "0010",
		DIGIT_3_IMAGE when "0011",
		DIGIT_4_IMAGE when "0100",
		DIGIT_5_IMAGE when "0101",
		DIGIT_6_IMAGE when "0110",
		DIGIT_7_IMAGE when "0111",
		DIGIT_8_IMAGE when "1000",
		DIGIT_9_IMAGE when "1001",
		DIGIT_A_IMAGE when "1010",
		DIGIT_B_IMAGE when "1011",
		DIGIT_C_IMAGE when "1100",
		DIGIT_D_IMAGE when "1101",
		DIGIT_E_IMAGE when "1110",
		DIGIT_F_IMAGE when others;
	
	seg_data <= dig_seg_data & not LED_ON_VALUE;
	
		
	process(clk)
	begin
		if (rising_edge(clk)) then
			
			seg_sel_reg <= (others => not LED_SEL_VALUE);
			seg_sel_reg(seg_sel_index) <= LED_SEL_VALUE;
			
			if (rst = '1') then
				seg_sel_index <= 0;
			else
				if (seg_sel_index /= DIGIT_NUM - 1) then
					seg_sel_index <= seg_sel_index + 1;
				else
					seg_sel_index <= 0;
				end if;
			end if;
			
		end if;
	end process;

end behavioral;
