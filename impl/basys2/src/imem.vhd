library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity imem is
	port(	clk:		in  std_logic;
			--
			rd_en:	in  std_logic;
			addr:		in  std_logic_vector(7 downto 0);
			
			d_out:	out  std_logic_vector(7 downto 0)
			);
end imem;



architecture behavioral of imem is

	type STD_LOGIC_ARRAY_256_8 is array(255 downto 0) of std_logic_vector(7 downto 0);
	
	signal rom_array:	STD_LOGIC_ARRAY_256_8 := (

		-- == Sign compare ==

		0 => "01100000",	-- LI 0
		1 => "10010000",	-- NOR 0
		2 => "00011100",	-- CPR R0
		3 => "01111111",	-- LIS 15
		4 => "11110111",	-- ADD 7

		5 => "00011101",	-- CPR R1
		6 => "00110100",	-- SL R0
		7 => "00000010",	-- SKNE
		8 => "01010100",	-- JMP +4 (12)
		9 => "00011001",	-- CPA R1
		10 => "11110001",	-- ADD 1
		11 => "01011010",	-- JMP -6 (5)

		12 => "01100000",	-- LI 0
		13 => "00011100",	-- CPR R0
		14 => "00011001",	-- CPA R1
		15 => "00110100",	-- SL R0
		16 => "00000010",	-- SKNE
		17 => "01010000",	-- JMP 0 (17)
		18 => "01010000",	-- JMP 0 (18)
		
		others => (others => '-')
		);

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
			
			if (rd_en = '1') then
				d_out <= rom_array(to_integer(unsigned(addr)));
			end if;
			
		end if;
	end process;

end behavioral;