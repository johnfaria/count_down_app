-----------------------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-----------------------------------------------------------------------------------------------
entity Decoder is
	PORT(
			letra: in character;
			numero: in integer range 0 to 9:=0;
			seven_seg_letra: out std_logic_vector(6 downto 0);
			seven_seg_numero: out std_logic_vector(6 downto 0)
			);
end Decoder;
-----------------------------------------------------------------------------------------------
ARCHITECTURE Decoder of Decoder is
BEGIN
		WITH letra SELECT --Decoder para escrever mensagem de inicio e fim
		
			seven_seg_letra <=   "1111011" WHEN 'I', 
											"1101010" WHEN 'N', 
											"1110010" WHEN 'C', 
											"1100010" WHEN 'O', 
											"1111111" WHEN ' ', 
											"1110001" WHEN 'L', 
											"0100100" WHEN 'S', 
											"0011000" WHEN 'P', 
											"1110000" WHEN 'T', 
											"0110000" WHEN 'E', 
											"1000011" WHEN 'J', 
											"0001000" WHEN 'A', 
											"0101011" WHEN 'M', 
											"1000010" WHEN 'D',
											"0000100" WHEN 'G',
											
											
											"1111111" WHEN OTHERS; -- Espaço vazio quando sem mensagens
-----------------------Decoder para escrever os numeros sorteados-------------------------------
		WITH numero SELECT --Utiliza o comando SELECT em função da entrada cont.
			seven_seg_numero <=     "0000001" WHEN 0, --Escreve 0 para o display
											"1001111" WHEN 1, --Escreve 1 para o display
											"0010010" WHEN 2, --Escreve 2 para o display
											"0000110" WHEN 3, --Escreve 3 para o display
											"1001100" WHEN 4, --Escreve 4 para o display
											"0100100" WHEN 5, --Escreve 5 para o display
											"0100000" WHEN 6, --Escreve 6 para o display
											"0001111" WHEN 7, --Escreve 7 para o display
											"0000000" WHEN 8, --Escreve 8 para o display
											"0000100" WHEN 9, --Escreve 9 para o display
											"1001111" WHEN OTHERS; -- Espaço vazio quando outros
-----------------------------------------------------------------------------------------------
END Decoder;
-----------------------------------------------------------------------------------------------