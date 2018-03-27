library ieee;
use ieee.std_logic_1164.all;

library tine_alpha;
use tine_alpha.fetch_stage_const.all;



entity fetch_stage is
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
end fetch_stage;



architecture behavioral of fetch_stage is

	signal rst_state:		std_logic;

	signal ip_reg:			std_logic_vector(7 downto 0);

begin

	inst_out <= imem_d_in when rst_state = '0' and fetch_nop = '0'
					else NOP_INST;
	
	ip_out <= ip_reg;
	
	imem_rd <= not stall;
	
	imem_addr <= ip_in;
	
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			rst_state <= rst;
			if (stall = '0') then
				ip_reg <= ip_in;
			end if;
		end if;
	end process;

end behavioral;