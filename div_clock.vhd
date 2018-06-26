
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

ENTITY Divisor_clock IS
	PORT(
			clk: in std_logic;--clk de 50MHz
			freqin: in integer range 0 to 25_000_000; --valor de entrada
			clk_out: out std_logic--clock de saída
			);
END Divisor_clock;

ARCHITECTURE hardware OF Divisor_clock IS
-- código para divisão do clock
	signal somador: integer :=0;
	signal oclk: std_logic :='0';
BEGIN

	clk_out <= oclk; 

	process(clk) 
	begin
		if rising_edge(clk) then 
			somador <= somador +1;
			if(somador = freqin)then 
			oclk <= not oclk;
			somador <= 0;
			end if;
		end if;
		
		

	end process; --fim do processo de clock
	
END hardware;
-------------------------------------------------------------------------------------