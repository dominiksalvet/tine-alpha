library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity rwm_generic is
	generic(	ADDR_BIT_WIDTH:	natural;
				DATA_BIT_WIDTH:	positive
				);
	port(	clk:		in  std_logic;
			--
			wr_en:	in  std_logic;
			rd_en:	in  std_logic;
			addr:		in  std_logic_vector(ADDR_BIT_WIDTH - 1 downto 0);
			d_in:		in  std_logic_vector(DATA_BIT_WIDTH - 1 downto 0);
			
			d_out:	out  std_logic_vector(DATA_BIT_WIDTH - 1 downto 0)
			);
end rwm_generic;



architecture behavioral of rwm_generic is

	type STD_LOGIC_ARRAY is array((2 ** ADDR_BIT_WIDTH) - 1 downto 0) of std_logic_vector(DATA_BIT_WIDTH - 1 downto 0);
	
	signal rwm_array:	STD_LOGIC_ARRAY;

begin

	process(clk)
	begin
		if (rising_edge(clk)) then
		
			if (wr_en = '1') then
				rwm_array(to_integer(unsigned(addr))) <= d_in;
			end if;
			
			if (rd_en = '1') then
				d_out <= rwm_array(to_integer(unsigned(addr)));
			end if;
			
		end if;
	end process;

end behavioral;