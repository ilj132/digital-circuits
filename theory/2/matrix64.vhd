entity matrix64 is
port(
valor: in bit_vector (3 downto 0);
col: in bit_vector (2 downto 0);
lin: out bit_vector (7 downto 0));
end matrix64;

architecture leds of matrix64 is
	signal A,B,C,D,nA,nB,nC,nD,J,K,L,nJ,nK,nL,col2,col3,col4,col5,col6: bit;
	
begin

--dando nome as variaveis de entrada
A<= valor(3);
B<= valor(2);
C<= valor(1);
D<= valor(0);
nA<= not valor(3);
nB<= not valor(2);
nC<= not valor(1);
nD<= not valor(0);
J<= col(2);
K<= col(1);
L<= col(0);
nJ<= not col(2);
nK<= not col(1);
nL<= not col(0);

--colunas que serao utilizadas
col2 <= (nJ and K and nL);
col3 <= (nJ and K and L);
col4 <= (J and nK and nL);
col5 <= (J and nK and L);
col6 <= (J and K and nL);


--erro na linha 5 coluna 6

lin(7) <= '0';
lin(6) <= ((B and D) and col2) or ((A or (B and D) or (nB and C) or (nB and nD)) and col3) or ((D or C or nB) and col4) or ((A or B or C or nD) and col5) or ((B and D) and col6);
lin(5) <= ((A or (nB and C) or (nB and nD) or (B and nC and D)) and col2) or (((B and C and nD) or (nA and nB and nC and D)) and col3) or (((B and nC and nD) or (nA and nB and nC and D)) and col4) or ((B and nC and nD) and col5) or ((A or (C and D) or (nB and C) or (nB and nD)) and col6);
-- ajeitar nomes
lin(4) <= ((A or (B and nC and D) or (nB and nD and nC) or (B and C and nD)) and col2) or ((B and nC) and col3) or ((nA and nC and D) and col4) or (((B and D)  or (nA and nC and nD)) and col5) or ((A  or (nB and C) or (nB and nD)) and col6);
lin(3) <= (((B and nD) or (nA and nC and nD)) and col2) or ((A or (B and C and nD) or (nB and C and D)) and col3) or ((C or nB) and col4) or ((A or (B and nD) or (nB and C)) and col5) or (((A and D) or (B and nC and D) or (nA and nB and nC and nD)) and col6);
lin(2) <= (((nC and nD) or (B and nD)) and col2) or (((B and C and D) or (nB and C and nD) or (nA and nC and nD)) and col3) or (((B and nC and nD) or (nA and nB and nC and D)) and (col4)) or ((B and nC and nD) and (col5)) or ((A or (nC and nD) or (B and nC) or (B and nD) or (nB and C and D)) and (col6));
lin(1) <= (((C and nD) or (nB and C) or (nB and nD) or (B and nC and D)) and col2) or ((B and C and D) and col3) or ((nA and nB and nC and D) and col4) or (((A and D) or (B and nC and nD)) and col5) or (((B and nC and D) or (nB and C and D) or (B and C and nD) or (nB and nC and nD)) and col6);
lin(0) <= ((nB and C and nD) and col2) or ((D or C or nB) and col3) or ((nB or (nC and D) or (C and nD)) and col4) or ((nD or (nA and nB ) or (nA and nC)) and col5) or ((nB and C and nD) and col6);

end leds;