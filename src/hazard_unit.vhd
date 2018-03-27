library ieee;
use ieee.std_logic_1164.all;

library tine_alpha;
use tine_alpha.address_stage_const.all;



entity hazard_unit is
	port(	clk:			in  std_logic;
			rst:			in  std_logic;
			--
			skip_ack:	in  std_logic;
			lda_ack:		in  std_logic;
			jmp_start:	in  std_logic;
			jmp_cmplt:	in  std_logic;
			
			fetch_nop:	out  std_logic;
			stall_sig:	out  std_logic
			);
end hazard_unit;



architecture behavioral of hazard_unit is

	signal jmp_state:		std_logic;

begin
	
	fetch_nop <= skip_ack or lda_ack or jmp_start or jmp_state;

	stall_sig <= lda_ack;
	
	
	process(clk)
	begin
		if (rising_edge(clk)) then
			if (rst = '1') then
				jmp_state <= '0';
			else
				if (jmp_cmplt = '1') then
					jmp_state <= '0';
				elsif (jmp_start = '1') then
					jmp_state <= '1';
				end if;
			end if;
		end if;
	end process;

end behavioral;