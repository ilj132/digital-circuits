--=====================--
-- DISPLAY 7 SEGMENTOS --
--=====================--

entity D7SEG is
    port (I: in bit_vector (3 downto 0);	-- Vetor de entradas, com 4 posicoes, que representa um numero, em binario, a ser convertido
		O: out bit_vector (6 downto 0));	-- Vetor de saidas, com 7 posicoes, que representa os 7 segmentos do display que serão acesos 
end D7SEG;

architecture logic of D7SEG is
    signal A, B, C, D, NA, NB, NC, ND: bit;
begin
    A <= I(3);
    B <= I(2);
    C <= I(1);
    D <= I(0);

    NA <= not A;
    NB <= not B;
    NC <= not C;
    ND <= not D;
    
    -- HEX[0] = C + A + B'D' + BD
    O(0) <= C or A or (NB and ND) or (B and D);
    
    -- HEX[1] = B' + C'D' + CD
    O(1) <= NB or (NC and ND) or (C and D);
    
    -- HEX[2] = C' + D + B
    O(2) <= NC or D or B;

    -- HEX[3] = B'D' + B'C + CD' + BC'D
    O(3) <= (NB and ND) or (NB and C) or (C and ND) or (B and NC and D);

    -- HEX[4] = B'D' + CD'
    O(4) <= (NB and ND) or (C and ND);

    -- HEX[5] = A + C'D' + BC' + BD'
    O(5) <= A or (NC and ND) or (B and NC) or (B and ND);

    -- HEX[6] = A + B'C + CD' + BC'
    O(6) <= A or (NB and C) or (C and ND) or (B and NC);

end logic;

--===============--
-- BLOCO Bin-BCD --
--===============--

entity bloco_bin_bcd is
    port (A: in bit_vector (3 downto 0);
            S: out bit_vector(3 downto 0));
end bloco_bin_bcd;

architecture logic of bloco_bin_bcd is
begin
    -- S[0] = (A3)(A0)' + (A3)'(A2)'(A0) + (A2)(A1)(A0)'
    S(0) <= (A(3) and (not A(0)))
            or ((not A(3)) and (not A(2)) and A(0))
            or (A(2) and A(1) and (not A(0)));

    -- (A2)'(A1) + (A1)(A0) + (A3)(A0)'
    S(1) <= ((not A(2)) and A(1))
            or (A(1) and A(0))
            or (A(3) and (not A(0))); 

    -- S[2] = (A3)(A0) + (A2)(A1)'(A0)'
    S(2) <= (A(3) and A(0))
            or (A(2) and (not A(1)) and (not A(0)));

    -- S[3] = (A3) + (A2)(A0) + (A2)(A1)
    S(3) <= A(3)
            or (A(2) and A(0))
            or (A(2) and A(1));

end logic;

--=================================--
-- DECODIFICADOR Bin-BCD (16 bits) --
--=================================--

entity decod_bcd_16bits is
		port(bin: in bit_vector(9 downto 0);
			bcd: out bit_vector (15 downto 0));
end decod_bcd_16bits;

architecture logic of decod_bcd_16bits is

component bloco_bin_bcd
	port(A: in bit_vector(3 downto 0);
			S: out bit_vector(3 downto 0));
end component;

	signal B1_A, B1_S, B2_A, B2_S, B3_A, B3_S, B4_A, B4_S, 
		B5_A, B5_S, B6_A, B6_S, B7_A, B7_S, B8_A, B8_S, B9_A, 
		B9_S,B10_A, B10_S, B11_A, B11_S, B12_A, B12_S, B13_A,
		B13_S, B14_A, B14_S, B15_A, B15_S, B16_A, B16_S, B17_A,
		B17_S, B18_A, B18_S, B19_A, B19_S, B20_A, B20_S: bit_vector(3 downto 0);

begin
	B1_A(3) <= '0';
	B1_A(2) <= '0';
	B1_A(1) <= '0';
	B1_A(0) <= '0';
	
	B1: bloco_bin_bcd port map(B1_A, B1_S);
	
	B2_A(3) <= B1_S(2);
	B2_A(2) <= B1_S(1);
	B2_A(1) <= B1_S(0);
	B2_A(0) <= bin(9);
	
	B2: bloco_bin_bcd port map(B2_A, B2_S);
	
	B3_A(3) <= B2_S(2);
	B3_A(2) <= B2_S(1);
	B3_A(1) <= B2_S(0);
	B3_A(0) <= bin(8);
	
	B3: bloco_bin_bcd port map(B3_A, B3_S);
	
	B4_A(3) <= B3_S(2);
	B4_A(2) <= B3_S(1);
	B4_A(1) <= B3_S(0);
	B4_A(0) <= bin(7);
	
	B4: bloco_bin_bcd port map(B4_A, B4_S);
	
	B5_A(3) <= '0';
	B5_A(2) <= B1_S(3);
	B5_A(1) <= B2_S(3);
	B5_A(0) <= B3_S(3);
	
	B5: bloco_bin_bcd port map(B5_A, B5_S);
	
	B6_A(3) <= B4_S(2);
	B6_A(2) <= B4_S(1);
	B6_A(1) <= B4_S(0);
	B6_A(0) <= bin(6);
	
	B6: bloco_bin_bcd port map(B6_A, B6_S);
	
	B7_A(3) <= B5_S(2);
	B7_A(2) <= B5_S(1);
	B7_A(1) <= B5_S(0);
	B7_A(0) <= B4_S(3);
	
	B7: bloco_bin_bcd port map(B7_A, B7_S);
	
	B8_A(3) <= B6_S(2);
	B8_A(2) <= B6_S(1);
	B8_A(1) <= B6_S(0);
	B8_A(0) <= bin(5);
	
	B8: bloco_bin_bcd port map(B8_A, B8_S);
	
	B9_A(3) <= B7_S(2);
	B9_A(2) <= B7_S(1);
	B9_A(1) <= B7_S(0);
	B9_A(0) <= B6_S(3);
	
	B9: bloco_bin_bcd port map(B9_A, B9_S);
	
	B10_A(3) <= B8_S(2);
	B10_A(2) <= B8_S(1);
	B10_A(1) <= B8_S(0);
	B10_A(0) <= bin(4);
	
	B10: bloco_bin_bcd port map(B10_A, B10_S);
	
	B11_A(3) <= B9_S(2);
	B11_A(2) <= B9_S(1);
	B11_A(1) <= B9_S(0);
	B11_A(0) <= B8_S(3);
	
	B11: bloco_bin_bcd port map(B11_A, B11_S);
	
	B12_A(3) <= B10_S(2);
	B12_A(2) <= B10_S(1);
	B12_A(1) <= B10_S(0);
	B12_A(0) <= bin(3);
	
	B12: bloco_bin_bcd port map(B12_A, B12_S);
	
	B13_A(3) <= B11_S(2);
	B13_A(2) <= B11_S(1);
	B13_A(1) <= B11_S(0);
	B13_A(0) <= B10_S(3);
	
	B13: bloco_bin_bcd port map(B13_A, B13_S);
	
	B14_A(3) <= B5_S(3);
	B14_A(2) <= B7_S(3);
	B14_A(1) <= B9_S(3);
	B14_A(0) <= B11_S(3);
	
	B14: bloco_bin_bcd port map(B14_A, B14_S);
	
	B15_A(3) <= B12_S(2);
	B15_A(2) <= B12_S(1);
	B15_A(1) <= B12_S(0);
	B15_A(0) <= bin(2);
	
	B15: bloco_bin_bcd port map(B15_A, B15_S);
	
	B16_A(3) <= B13_S(2);
	B16_A(2) <= B13_S(1);
	B16_A(1) <= B13_S(0);
	B16_A(0) <= B12_S(3);
	
	B16: bloco_bin_bcd port map(B16_A, B16_S);
	
	B17_A(3) <= B14_S(2);
	B17_A(2) <= B14_S(1);
	B17_A(1) <= B14_S(0);
	B17_A(0) <= B13_S(3);
	
	B17: bloco_bin_bcd port map(B17_A, B17_S);
	
	B18_A(3) <= B15_S(2);
	B18_A(2) <= B15_S(1);
	B18_A(1) <= B15_S(0);
	B18_A(0) <= bin(1);
	
	B18: bloco_bin_bcd port map(B18_A, B18_S);
	
	B19_A(3) <= B16_S(2);
	B19_A(2) <= B16_S(1);
	B19_A(1) <= B16_S(0);
	B19_A(0) <= B15_S(3);
	
	B19: bloco_bin_bcd port map(B19_A, B19_S);
	
	B20_A(3) <= B17_S(2);
	B20_A(2) <= B17_S(1);
	B20_A(1) <= B17_S(0);
	B20_A(0) <= B16_S(3);
	
	B20: bloco_bin_bcd port map(B20_A, B20_S);
	
	bcd(15) <= '0';
	bcd(14) <= B14_S(3);
	bcd(13) <= B17_S(3);
	bcd(12) <= B20_S(3);
	bcd(11) <= B20_S(2);
	bcd(10) <= B20_S(1);
	bcd(9) <= B20_S(0);
	bcd(8) <= B19_S(3);
	bcd(7) <= B19_S(2);
	bcd(6) <= B19_S(1);
	bcd(5) <= B19_S(0);
	bcd(4) <= B18_S(3);
	bcd(3) <= B18_S(2);
	bcd(2) <= B18_S(1);
	bcd(1) <= B18_S(0);
	bcd(0) <= bin(0);
	
end logic;


--==================================--
-- COMPARADOR DE MAGNITUDE (1 bits) --
--==================================--

entity Comparador_bit is
  port(a, b, a_Igual_b,a_maior_b,a_menor_b: in bit;
			Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit);
end Comparador_bit;

architecture logic_Comparador_bit of Comparador_bit is
  
begin
   Sa_Igual_b <= ((a xnor b) and a_igual_b);
   Sa_maior_b <= (((not b) and a) and a_igual_b) or a_maior_b;
   Sa_menor_b <= (((not a) and b) and a_igual_b) or a_menor_b;
	
end logic_Comparador_bit;

--===================================-- 
-- COMPARADOR DE MAGNITUDE (10 bits) --
--===================================--

entity Comparador is
  port(a,b: in bit_vector(11 downto 0);
			a_Igual_b,a_maior_b,a_menor_b: in bit;
			Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit);
end Comparador;

architecture logic_Comparador of Comparador is
  
  component Comparador_bit is
   port(a, b, a_Igual_b,a_maior_b,a_menor_b: in bit;
        Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit
     );
  end component;
  
signal V_Sa_Igual_b, V_Sa_maior_b, V_Sa_menor_b: bit_vector (9 downto 0);
  
begin
	Comparacao1: Comparador_bit port map( a(9),b(9),'1','0','0',V_Sa_Igual_b(0),V_Sa_maior_b(0),V_Sa_menor_b(0));
	Comparacao2: Comparador_bit port map( a(8),b(8),V_Sa_Igual_b(0),V_Sa_maior_b(0),V_Sa_menor_b(0),V_Sa_Igual_b(1),V_Sa_maior_b(1),V_Sa_menor_b(1));
	Comparacao3: Comparador_bit port map( a(7),b(7),V_Sa_Igual_b(1),V_Sa_maior_b(1),V_Sa_menor_b(1),V_Sa_Igual_b(2),V_Sa_maior_b(2),V_Sa_menor_b(2));
	Comparacao4: Comparador_bit port map( a(6),b(6),V_Sa_Igual_b(2),V_Sa_maior_b(2),V_Sa_menor_b(2),V_Sa_Igual_b(3),V_Sa_maior_b(3),V_Sa_menor_b(3));
	Comparacao5: Comparador_bit port map( a(5),b(5),V_Sa_Igual_b(3),V_Sa_maior_b(3),V_Sa_menor_b(3),V_Sa_Igual_b(4),V_Sa_maior_b(4),V_Sa_menor_b(4));
	Comparacao6: Comparador_bit port map( a(4),b(4),V_Sa_Igual_b(4),V_Sa_maior_b(4),V_Sa_menor_b(4),V_Sa_Igual_b(5),V_Sa_maior_b(5),V_Sa_menor_b(5));
	Comparacao7: Comparador_bit port map( a(3),b(3),V_Sa_Igual_b(5),V_Sa_maior_b(5),V_Sa_menor_b(5),V_Sa_Igual_b(6),V_Sa_maior_b(6),V_Sa_menor_b(6));
	Comparacao8: Comparador_bit port map( a(2),b(2),V_Sa_Igual_b(6),V_Sa_maior_b(6),V_Sa_menor_b(6),V_Sa_Igual_b(7),V_Sa_maior_b(7),V_Sa_menor_b(7));
	Comparacao9: Comparador_bit port map( a(1),b(1),V_Sa_Igual_b(7),V_Sa_maior_b(7),V_Sa_menor_b(7),V_Sa_Igual_b(8),V_Sa_maior_b(8),V_Sa_menor_b(8));
	Comparacao10: Comparador_bit port map( a(0),b(0),V_Sa_Igual_b(8),V_Sa_maior_b(8),V_Sa_menor_b(8),V_Sa_Igual_b(9),V_Sa_maior_b(9),V_Sa_menor_b(9)); 

   Sa_Igual_b <= V_Sa_Igual_b(9);
   Sa_maior_b <= V_Sa_maior_b(9);
   Sa_menor_b <= V_Sa_menor_b(9);
 
end logic_Comparador;


--==========--
-- CONTADOR --
--==========--

entity contador is
	port(A: in bit;
	B: out bit);
end contador;

architecture logic of contador is

begin

end logic;