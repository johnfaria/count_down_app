library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity projetoaplicativo is port(

reset, clk, start ,pause : in std_logic; --sinais de entrada
sel: out std_logic_vector(3 downto 0);--seleçao dos displays
seteseg: out std_logic_vector(6 downto 0);--vetor que o display recebe
botao_estado: in std_logic	:='0';--botão que altera o valor de estado 
hsinc    	: out std_logic; --saída sincronização horizontal
vsinc    	: out std_logic; --saída sincronização vertical
corestovga   	: out std_logic_vector(7 downto 0) --vetor que define as cores
);
end projetoaplicativo;
--------------------------------------------------------------------------------------------------
architecture hardware of projetoaplicativo is
----------------------------INTEIROS UTILIZADOS NA TROCA DE ESTADO--------------------------------
signal d0: 	integer range 0 to 9 := 0;--dezena de minuto
signal d1: 	integer range 0 to 9 := 0;--unidade de minuto
signal d3: 	integer range 0 to 9 := 0;--unidade de segundos
signal d2: 	integer range 0 to 5:= 0; --dezena de segundos
---------------------------INTEIROS UTILIZADOS NA CONTAGEM----------------------------------------
signal q0: 	integer range 0 to 9 := 0;--dezena de minuto
signal q1: 	integer range 0 to 9 := 0;--unidade de minuto
signal q3: 	integer range 0 to 9 := 0;--unidade de segundos
signal q2: 	integer range 0 to 5:= 0; --dezena de segundos
----------------------------SINAIS PARA DIVISOR DE CLOCK------------------------------------------
signal 		clk1hz: 		std_logic := '0'; --clock de 1hz
signal 		clk100hz: 	std_logic := '0'; --clock de 100hz
constant 	gen1hz: 		integer := 25_000_000; --usado no clock de 1hz
constant 	gen100hz: 	integer := 5000; --usado no clock de 100hz
----------------------------SINAIS PARA DEFINIR ESTADOS-------------------------------------------
signal 		flag: 		std_logic:='1' ;--utilizado para saber o momento da contagem	
signal 		flag_fim:	std_logic:='0' ;--utilizado para saber o fim da contagem
signal 		estado: 		integer range 0 to 8 := 0; --utilizado para trocar os estados
----------------------------SINAIS PARA DEBOUNCE---------------------------------
signal 		flipflops: 			std_logic_vector(1 DOWNTO 0); -- sinal criado para criar condição do debouncer
signal 		counter_set: 		std_logic; --sinal utilizado no debouncer
signal		counter_out: 		std_logic_vector(2 DOWNTO 0) := (others => '0'); --sinal utilizado no debouncer
signal 		out_debounce: 		std_logic := '0'; --sinal da saida do debouncer
---------------------------SINAIS PARA DECODER------------------------------------------------------
signal 		seven_seg_letra:  		std_logic_vector(6 downto 0);--envia letra para o display de 7 segmentos
signal 		seven_seg_numero: 		std_logic_vector(6 downto 0);--envia numero para o display de 7 segmentos
constant 	mensagem_ihardwareial: 	string(1 to 21) := " SELECIONA O TEMPO JS";--string mensagem inicial
constant 	mensagem_final: 			string(1 to 18) := " TEMPO ESGOTADO JS";--string mensagem final
signal 		letra: 						character; --utilizado para envio do letra para o decoder
signal		numero:						integer range 0 to 9;--Envio do nº para o decoder
signal 		selectdisp: 				integer range 0 to 3 :=0; --usado na seleçao dos displays
-------------------------CONTADORES PARA DISPLAY------------------------------------------------------
signal 		contador_disp1: 		integer range 0 to 20 := 1;
signal 		contador_disp2: 		integer range 0 to 20 := 0;
signal		contador_disp3:		integer range 0 to 20 := 0;
signal 		contador_disp4:		integer range 0 to 20 := 0;
--------------------------------COMPONENTS------------------------------------------------------------
------------------------------COMPONENT VGA-----------------------------------------------------------
component VGA  is port ( 	clk  			: in std_logic;
									flag  		: in std_logic;
									flag_fim    : in std_logic;
									q0,q1,q3    : in integer range 0 to 9;
									q2    		: in integer range 0 to 5;
									clk1hz  		: in std_logic;
									estado 		: in integer range 0 to 8;
									sync_h    	: out std_logic;
									sync_v    	: out std_logic;
									corestovga  : out std_logic_vector(7 downto 0)	);
end component;
---------------------------COMPONENT DIVISOR DE CLOCK-------------------------------------------------
component Divisor_clock PORT(	clk		: in std_logic;
										freqin	: in integer range 0 to 25_000_000; 
										clk_out	: out std_logic	);
end component; 
------------------------------- COMPONENT DECODER-----------------------------------------------------
component Decoder is PORT(	letra			: in character;
									numero		: in integer range 0 to 9;
									seven_seg_letra	: out std_logic_vector(6 downto 0);
									seven_seg_numero	: out std_logic_vector(6 downto 0)	);
end component;
----------------------------PORT MAPS-----------------------------------------------------------------
begin
---------------------------PORT MAP DECODER-----------------------------------------------------------
 Decoder1: Decoder PORT MAP (
										letra => letra,
										numero => numero,
										seven_seg_letra => seven_seg_letra,
										seven_seg_numero => seven_seg_numero
									);	
--------------------------------PORT MAP CLOCK1hz-----------------------------------------------------
 Clock1hz: Divisor_clock PORT MAP (
								clk => clk,
								freqin => gen1hz,
								clk_out => clk1hz
								);		 
--------------------------------PORT MAP CLOCK1hz----------------------------------------------------
 Clock100hz: Divisor_clock PORT MAP (
								clk => clk,
								freqin => gen100hz,
								clk_out => clk100hz	);	
------------------------------PORTMAP VGA-----------------------------------------------------------
 VGA1: VGA PORT MAP (	clk  => clk,
								clk1hz => clk1hz,
								q0 => q0,
								q1 => q1,
								q3 => q3,
								q2 => q2,
								flag => flag,	
								flag_fim => flag_fim,
								estado => estado,
								sync_h => hsinc,
								sync_v => vsinc,
								corestovga	=> corestovga	);	
---------------------------------------------------------------------------------------------------
--PROCESSO QUE DEFINE O QUE É MOSTRADO NO DISPLAY DE 7 SEGMENTOS
	process (clk100hz)
		begin
		if rising_edge(clk100hz) then
			--MOSTRA MENSAGEM INICIAL 
		 	if estado = 0 and flag = '1' and flag_fim='0' then --CONDIÇÕES NECESSÁRIAS
				case selectdisp is 
					when 0 => sel <= "1110";
						selectdisp  <= selectdisp  + 1;
						letra <= mensagem_ihardwareial(contador_disp1);
						seteseg <= seven_seg_letra;
					when 1 => sel <= "1101";
						selectdisp  <= selectdisp  + 1;
						letra <= mensagem_ihardwareial(contador_disp2);
						seteseg <= seven_seg_letra;
					when 2 => sel <= "1011";
						selectdisp  <= selectdisp  + 1;
						letra <= mensagem_ihardwareial(contador_disp3);
						seteseg <= seven_seg_letra;
					when 3 => sel <= "0111";
						selectdisp <= 0;
						letra <= mensagem_ihardwareial(contador_disp4);
						seteseg <= seven_seg_letra;
					when others => sel <= "0000";
				end case;
			end if;	
------------------------------------------------------------------------------------------------
			--MOSTRA AS OPÇÕES DO CRONÔMETRO(10-15-20-30-40-50-60)
			if (flag = '1' and estado /= 0 ) then --CONDIÇÕES NECESSÁRIAS
			case selectdisp is 
				when 0 => sel <= "1110";
					selectdisp <= selectdisp + 1;
					numero <= d3;
					seteseg <= seven_seg_numero;
				when 1 => sel <= "1101";
					selectdisp <= selectdisp + 1;
					numero <= d2;
					seteseg <= seven_seg_numero;
				when 2 => sel <= "1011";
					selectdisp <= selectdisp + 1;
					numero <= d1;
					seteseg <= seven_seg_numero;
				when 3 => sel <= "0111";
					selectdisp <= 0;
					numero <= d0;
					seteseg <= seven_seg_numero;
				when others => sel <= "0000";
			end case;
			end if;
---------------------------------------------------------------------------------------------
			--MOSTRA A CONTAGEM DO VALOR SELECIONADO ANTERIORMENTE
			if (flag = '0' and estado /= 0  ) then --CONDIÇÕES NECESSÁRIAS
			case selectdisp is 
				when 0 => sel <= "1110";
					selectdisp <= selectdisp + 1;
					numero <= q3;
					seteseg <= seven_seg_numero;
				when 1 => sel <= "1101";
					selectdisp <= selectdisp + 1;
					numero <= q2;
					seteseg <= seven_seg_numero;
				when 2 => sel <= "1011";
					selectdisp <= selectdisp + 1;
					numero <= q1;
					seteseg <= seven_seg_numero;
				when 3 => sel <= "0111";
					selectdisp <= 0;
					numero <= q0;
					seteseg <= seven_seg_numero;
				when others => sel <= "0000";
			end case;
			end if;
---------------------------------------------------------------------------------------------
			--MOSTRA A MENSAGEM FINAL SE A CONTAGEM FOR FINALIZADA
			if  (flag='1' and flag_fim='1' and estado /= 0)then --CONDIÇÕES NECESSÁRIAS
				case selectdisp is 
					when 0 => sel <= "1110";
						selectdisp  <= selectdisp  + 1;
						letra <= mensagem_final(contador_disp1);
						seteseg <= seven_seg_letra;
					when 1 => sel <= "1101";
						selectdisp  <= selectdisp  + 1;
						letra <= mensagem_final(contador_disp2);
						seteseg <= seven_seg_letra;
					when 2 => sel <= "1011";
						selectdisp  <= selectdisp  + 1;
						letra <= mensagem_final(contador_disp3);
						seteseg <= seven_seg_letra;
					when 3 => sel <= "0111";
						selectdisp <= 0;
						letra <= mensagem_final(contador_disp4);
						seteseg <= seven_seg_letra;
					when others => sel <= "0000";
				end case;
			end if;	
		end if ;
end process;
---------------------------------------------------------------------------------------------
process(clk1hz,reset,start,estado,flag)
	variable startcount: bit:='1'; --variável que ao receber '0' inicia a contagem
begin
if reset = '1' then --volta as condições iniciais se reset ='1'
	q0 <= d0;
	q1 <= d1;
	q2 <= d2;
	q3 <= d3;
	startcount := '1';
	flag <= '1';
	flag_fim <=	'0';
elsif reset = '0' then --tarefas executadas se reset = '0'
--faz com que os valores de q0, q1, q2 e q3 recebam o valor de d0, d1, d2 e d3	
--em qualquer momento
if estado > 0 and flag = '1' and flag_fim = '0' and startcount = '1' then
		q0 <= d0;
		q1 <= d1;
		q2 <= d2;
		q3 <= d3;
	elsif (start = '1' ) then --recebe as condições para o início da contagem
		q0 <= d0;
		q1 <= d1;
		q2 <= d2;
		q3 <= d3;
		startcount := '0';
		flag <= '0';
---------------------------------------------------------------------------------------------		
	elsif (start='0') then	
	--lógica utilizada para fazer a contagem regressiva	
		if (rising_edge(clk1hz) and pause = '0' )then 
			if (q0 /= 0 or q1 /= 0 or q2 /= 0 or q3 /= 0) and(startcount = '0') then
				if q3 = 0 then
					q3 <= 9;
					if q2 = 0 then
						q2 <= 5;
						if q1 = 0 then
							q1 <= 9;
							if q0 = 0 then
								q0 <= 9;
							else
								q0 <= q0 - 1;
							end if;
						else
							q1 <= q1 - 1;
						end if;
					else
						q2 <= q2 - 1;
					end if;
				else
					q3 <= q3 - 1;
				end if;
	--indica o fim da contagem			
			elsif (q0 = 0 and q1 = 0 and q2 = 0 and q3 =0) and (startcount= '0') then
				q0 <= 0;
				q1 <= 0;
				q2 <= 0;
				q3 <= 0;
				startcount := '1';
				flag <= '1';
				flag_fim <= '1';
			end if;
		end if;
	end if;
end if;		
end process;
 
process( clk1hz, out_debounce )
begin
	if reset = '1' then --reset do estado e dos contadores do display
		estado <=0;
		contador_disp1 <=1; contador_disp2 <=0;
		contador_disp3 <=0; contador_disp4 <=0;
	elsif reset = '0' and flag = '1' then
		if rising_edge(out_debounce) and estado <= 8 then --borda de subida no sinal e estado menor que 8 executa:
			estado <= estado + 1;
		end if;
		if estado = 8 then
			estado <= 0;
		end if;
			if rising_edge(clk1hz) then -- lógica utilizada para a mensagem inicial e final ser toda exibida
					contador_disp1 <= contador_disp1 + 1;
					if (contador_disp1 > 0) then
						contador_disp2 <= contador_disp2 + 1;
					end if;
					if (contador_disp2 > 0) then
						contador_disp3 <= contador_disp3 + 1;
					end if;
					if (contador_disp3 > 0) then
						contador_disp4 <= contador_disp4 + 1;
					end if;
					if (contador_disp4 = 20 ) then 
						contador_disp1 <=1; contador_disp2 <=0;
						contador_disp3 <=0; contador_disp4 <=0;
					end if;
			end if;
	end if;
end process; 
-------------------------PROCESSO DE DEBOUNCE---------------------------------------------------------------------
counter_set <= flipflops(0) xor flipflops(1); --inicia contador
process(clk)
	BEGIN
		if rising_edge(clk) then
			flipflops(0) <= botao_estado; --atribui o valor do botão "0" ou "1" a posição 0 do vetor flipflop
			flipflops(1) <= flipflops(0); --atribui o valor da posição 00 do flipflop 0 posiçãoo 1
			if(counter_set = '1') then --reset do contador se a entrada for alterada
				counter_out <= (others => '0');
			elsif(counter_out(2) = '0') then -- condição de estabilidade da entrada não foi cumprida
				counter_out <= counter_out + 1;
		elsE --condição de estabilidade da entrada foi cumprida
			out_debounce <= flipflops(1);
			end if;    
		end if;
end process;
-----------------------ATRIBUÍ VALORES A d0, d1, d2 E d3 BASEADO NO VALOR DE ESTADO-----------------------------
process( estado )
begin
if estado=0 then --valor 00:00
	d0<=0;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;	
if estado=1 then --valor 10:00
	d0<=1;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;
if estado=2 then --valor 15:00
	d0<=1;
	d1<=5;
	d2<=0;
	d3<=0;
end if ;
if estado=3 then --valor 20:00
	d0<=2;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;
if estado=4 then --valor 30:00
	d0<=3;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;
if estado=5 then --valor 40:00
	d0<=4;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;
-----------------------ATRIBUÍ VALORES A d0, d1, d2 E d3 BASEADO NO VALOR DE ESTADO-----------------------------
if estado=6 then --valor 50:00
	d0<=5;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;
if estado=7 then --valor 60:00
	d0<=6;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;
if estado=8 then --valor 00:00
	d0<=0;
	d1<=0;
	d2<=0;
	d3<=0;
end if ;	
end process ; 
end hardware;
	