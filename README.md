# Count down app VHDL

### Especificação
---
Projetar, utilizando o kit NEXYS2, um dispositivo eletrônico capaz de efetuar uma
contagem regressiva com passos definidos de configuração ([10 – 15 – 20 – 30 – 40 – 50 –
60] minutos). A aplicação lúdica para este projeto será o “contador eletrônico regressivo”
O dispositivo deverá obrigatoriamente implementar as seguintes funcionalidades:

1. Ao ligar o dispositivo, uma mensagem de inicialização deverá ser apresentada nos
displays de 7 segmentos: “SELECIONE O TEMPO XY”. Um rolamento das letras
através dos 4 displays deverá garantir a visualização da mensagem inicial;

2. Através do acionamento de um botão do kit, o usuário deverá ser capaz de escolher
entre uma das opções possíveis ([10 – 15 – 20 – 30 – 40 – 50 – 60] minutos);

3. Após a escolha do tempo, a contagem deverá ser iniciada através do acionamento
de outro botão do kit. Uma função de pausa deverá ser prevista;

4. Uma vez iniciada a contagem regressiva, a mesma deverá ser mostrada nos displays
de 7 segmentos e em um monitor com resolução de 800x600 (usar saída VGA do
kit). Tanto nos displays quanto no monitor, deverão ser exibidos 4 dígitos (2 para
os minutos e 2 para os segundos), sendo que no monitor os mesmos devem
estar separados por “.”. No monitor, pelo menos 80 % do espaço útil deverá ser
utilizado;

5. No monitor, os últimos 2 minutos de contagem deverão ser exibidos em outra cor,
evidenciando que o final da contagem está próximo;

6. Após o final da contagem, uma mensagem deve aparecer nos displays de 7 segmentos:
“TEMPO ESGOTADO XY”. Um rolamento das letras através dos 4 displays deverá
garantir a visualização da mensagem final. No monitor, os quatro dígitos assumirão
o valor “00.00” e deverão permanecer “piscando” até a reinicialização;

7. O acionamento de um mecanismo mecânico do kit deverá permitir a reinicialização
do dispositivo de forma a iniciar-se nova contagem (retorno a mensagem inicial e
reset do monitor);
XY – Primeira letra do nome dos membros da equipe de desenvolvimento. (Ex.: XY
Xavier e Yann)
