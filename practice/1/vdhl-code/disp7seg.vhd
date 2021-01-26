entity disp7seg is
  port (SW: in bit_vector(3 downto 0);
    	HEX: out bit_vector(6 downto 0));
end disp7seg;
 	 
architecture leds of disp7seg is
	signal  A,B,C,D,nA,nB,nC,nD: bit; --sinais para armazenar valores de high e low da entrada;
begin
 
  --Atribuicao dos valores dos sinais referente aos bits de entrada
  A<= SW(3);
  B<= SW(2);
  C<= SW(1);
  D<= SW(0);
  nA<= not SW(3);
  nB<= not SW(2);
  nC<= not SW(1);
  nD<= not SW(0);
 
  --Especificando em quais entradas os segmentos irão ligar
  HEX(6)<= (nC or (B and D) or (A and D) or (A and B));
       	 
  HEX(5)<= ((nA and nB and nC) or (nA and D) or (B and D) or (B and C) or (A and C and nD));
  
  HEX(4)<= ((nA and nB) or (nB and nD) or (nA and C) or (A and B));
       	 
  HEX(3)<= ((nA and nC and D) or (nA and C and nD) or (nA and B) or (B and nD) or (A and nB and nC));
 
  HEX(2)<= ((nA and nC) or (nA and nD) or (nB and nC) or (B and C and nD) or (A and nB and D));
    
  HEX(1)<= ((nB and nC) or (nB and nD) or (nC and nD) or (A and C));
 	 
  HEX(0)<= ((nB and nD) or (nA and B and D) or (B and C) or (A and nB) or (A and nD));

end leds;


