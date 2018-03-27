library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;



entity clk_div_generic is
	generic(	ONE_CLK_MODE:			boolean;
				CLK_DIV_BIT_WIDTH:	positive
				);
	port(	clk:			in  std_logic;
			rst:			in  std_logic;
			--
			clk_div:		in  std_logic_vector(CLK_DIV_BIT_WIDTH - 1 downto 0);
			
			clk_out:		out  std_logic
			);
end clk_div_generic;



architecture behavioral of clk_div_generic is

	signal clk_reg:	std_logic;

	signal clk_cntr:	std_logic_vector(clk_div'length - 1 downto 0);

begin

	clk_out <= clk_reg;
	

	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				
				if (ONE_CLK_MODE = false) then
					clk_reg <= '0';
				end if;
				clk_cntr <= clk_div;
				
			else
				
				if (clk_cntr = (clk_cntr'length - 1 downto 0 => '0')) then
					if (ONE_CLK_MODE = true) then
						clk_reg <= '1';
					else
						clk_reg <= not clk_reg;
					end if;
					clk_cntr <= clk_div;
				else
					if (ONE_CLK_MODE = true) then
						clk_reg <= '0';
					end if;
					clk_cntr <= std_logic_vector(unsigned(clk_cntr) - 1);					
				end if;
				
			end if;
		end if;
	end process;

end behavioral;
