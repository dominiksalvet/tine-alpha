library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library tine_alpha;
use tine_alpha.address_stage_const.all;
use tine_alpha.sim_data_types.all;



entity address_stage is
	generic(	sim_en:	boolean := false
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
end address_stage;



architecture behavioral of address_stage is

	signal ip_reg:		std_logic_vector(7 downto 0);
	
	signal sim_sig:	adst_sim_data_type;

begin

	ip_out <= ip_reg;
	
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
			
				ip_reg <= RST_IP_REG;
			
			elsif (stall = '0') then
				
				jmp_ack <= jmp_en;
				
				if (jmp_en = '1') then
					ip_reg <= jmp_addr;
				else
					ip_reg <= std_logic_vector(unsigned(ip_reg) + 1);
				end if;
			
			end if;
		end if;
	end process;
	

	sim_sig.ip_reg <= ip_reg;
	
	sim_switch:
	if (sim_en = true) generate
		sim <= sim_sig;
	end generate sim_switch;

end behavioral;