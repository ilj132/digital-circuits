--=====================--
-- DISPLAY 7 SEGMENTOS --
--=====================--

entity D7SEG is
   port (I: in bit_vector (3 downto 0);	
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
 
   O(0) <= C or A or (NB and ND) or (B and D);
   
   O(1) <= NB or (NC and ND) or (C and D);
   
   O(2) <= NC or D or B;

   O(3) <= (NB and ND) or (NB and C) or (C and ND) or (B and NC and D);

   O(4) <= (NB and ND) or (C and ND);

   O(5) <= A or (NC and ND) or (B and NC) or (B and ND);

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

   S(0) <= (A(3) and (not A(0))) or ((not A(3)) and (not A(2)) and A(0)) or (A(2) and A(1) and (not A(0)));

   S(1) <= ((not A(2)) and A(1)) or (A(1) and A(0)) or (A(3) and (not A(0))); 

   S(2) <= (A(3) and A(0)) or (A(2) and (not A(1)) and (not A(0)));

   S(3) <= A(3) or (A(2) and A(0)) or (A(2) and A(1));

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


--==============--
-- MEIO SOMADOR --
--==============--

entity HALF_ADD is
   port(A, B: in bit;
		S, CO: out bit);
end HALF_ADD;

architecture logic of HALF_ADD is

begin
   S <= A xor B;
   CO <= A and B;
end logic;


--==================--
-- SOMADOR COMPLETO --
--==================--

entity COMP_ADD is
   port(A, B, CI: in bit;
		S, CO: out bit);
end COMP_ADD;

architecture logic of COMP_ADD is

begin
    S <= A xor B xor CI;
    CO <= (B and CI) or (A and CI) or (A and B);
end logic;


--===================--
-- SOMADOR (10 bits) --
--===================--

entity ADD10 is
   port(A, B: in bit_vector(9 downto 0);
		O: out bit_vector(9 downto 0);
      CO: out bit);
end ADD10;

architecture logic of ADD10 is

component HALF_ADD is
   port(A, B: in bit;
		S, CO: out bit);
end component;

component COMP_ADD
   port(A, B, CI: in bit;
		S, CO: out bit);
end component;

signal VAI_UM: bit_vector(8 downto 0);

begin
   S0: HALF_ADD port map(A(0), B(0), O(0), VAI_UM(0));
   S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
   S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
   S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), VAI_UM(3));
   S4: COMP_ADD port map(A(4), B(4), VAI_UM(3), O(4), VAI_UM(4));
   S5: COMP_ADD port map(A(5), B(5), VAI_UM(4), O(5), VAI_UM(5));
   S6: COMP_ADD port map(A(6), B(6), VAI_UM(5), O(6), VAI_UM(6));
   S7: COMP_ADD port map(A(7), B(7), VAI_UM(6), O(7), VAI_UM(7));
	S8: COMP_ADD port map(A(8), B(8), VAI_UM(7), O(8), VAI_UM(8));
	S9: COMP_ADD port map(A(9), B(9), VAI_UM(8), O(9), CO);
	
end logic;


--================--
-- Meio Subtrator --
--================--

entity MSUB is
  port(a, b : in bit;
       bo, s: out bit
     );
end MSUB;

architecture logic_MSUB of MSUB is

  begin
    bo <= (not(a) and b);
    s <= (a xor b);
    
end logic_MSUB;

--====================--
-- Subtrator Completo --
--====================--

entity SUBC is
  port(a, b, ci: in bit;
       bo, s: out bit
     );
end SUBC;

architecture logic_SUBC of SUBC is

  begin
    bo <= ((not(a) and ci) or (b and ci) or (not(a) and b));
    s <= (a xor b xor ci);
    
end logic_SUBC;

--===================--
-- Subtrator (10 bits) --
--===================--

entity SUB is
  port(A, B: in bit_vector(9 downto 0);
       O: out bit_vector(9 downto 0);
       CO: out bit);
end SUB;

architecture hardware of SUB is

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM: bit_vector(8 downto 0);
signal AUX_B: bit_vector(9 downto 0);

begin
    -- Como � subtrator, ent�o inverte B e soma 1 (VAI_UM='1'). (Complemento de 2: A-B=A+B'+1)

    AUX_B(0) <= not B(0);
    AUX_B(1) <= not B(1);
    AUX_B(2) <= not B(2);
    AUX_B(3) <= not B(3);
    AUX_B(4) <= not B(4);
    AUX_B(5) <= not B(5);
    AUX_B(6) <= not B(6);
    AUX_B(7) <= not B(7);
    AUX_B(8) <= not B(8);
    AUX_B(9) <= not B(9);

    S0: COMP_ADD port map(A(0), AUX_B(0), '1', O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), AUX_B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), AUX_B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), AUX_B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), AUX_B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), AUX_B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), AUX_B(6), VAI_UM(5), O(6), VAI_UM(6));
    S7: COMP_ADD port map(A(7), AUX_B(7), VAI_UM(6), O(7), VAI_UM(7));
    S8: COMP_ADD port map(A(8), AUX_B(8), VAI_UM(7), O(8), VAI_UM(8));
    S9: COMP_ADD port map(A(9), AUX_B(9), VAI_UM(8), O(9), CO);
end hardware ; 

--===================--
-- MULTIPLEXADOR 2x1 -- 
--===================--

entity MUX21 is
   port(A, B, S: in bit;
      O: out bit);
end MUX21;

architecture hardware of MUX21 is

begin
    O <= (B and S) or (A and (not S));
end hardware;


--============--
-- FlipFlop D --
--============--

ENTITY ffd IS
	port ( clk ,D ,P , C : IN BIT ;
		q : OUT BIT );
END ffd ;

ARCHITECTURE ckt OF ffd IS
	SIGNAL qS : BIT;
	BEGIN
PROCESS ( clk ,P ,C )
	BEGIN
	IF P = '0' THEN qS <= '1';
	ELSIF C = '0' THEN qS <= '0';
	ELSIF clk = '1' AND clk ' EVENT THEN
	qS <= D ;
	END IF;
END PROCESS ;
q <= qS ;
END ckt ;


--==================================--
-- COMPARADOR DE MAGNITUDE (1 bits) --
--==================================--

entity COMP_BIT is
  port(a, b, a_Igual_b,a_maior_b,a_menor_b: in bit;
			Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit);
end COMP_BIT;

architecture logic of COMP_BIT is
  
begin
   Sa_Igual_b <= ((a xnor b) and a_igual_b);
   Sa_maior_b <= (((not b) and a) and a_igual_b) or a_maior_b;
   Sa_menor_b <= (((not a) and b) and a_igual_b) or a_menor_b;
	
end logic;

--===================================-- 
-- COMPARADOR DE MAGNITUDE (4 bits) --
--===================================--

entity COMP4 is
  port(a,b: in bit_vector(3 downto 0);
			Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit);
end COMP4;

architecture logic of COMP4 is
  
  component COMP_BIT is
   port(a, b, a_Igual_b,a_maior_b,a_menor_b: in bit;
        Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit
     );
  end component;
  
signal V_Sa_Igual_b, V_Sa_maior_b, V_Sa_menor_b: bit_vector (3 downto 0);
  
begin
	COMP1: COMP_BIT port map( a(3),b(3),'1','0','0',V_Sa_Igual_b(0),V_Sa_maior_b(0),V_Sa_menor_b(0));
	COMP2: COMP_BIT port map( a(2),b(2),V_Sa_Igual_b(0),V_Sa_maior_b(0),V_Sa_menor_b(0),V_Sa_Igual_b(1),V_Sa_maior_b(1),V_Sa_menor_b(1));
	COMP3: COMP_BIT port map( a(1),b(1),V_Sa_Igual_b(1),V_Sa_maior_b(1),V_Sa_menor_b(1),V_Sa_Igual_b(2),V_Sa_maior_b(2),V_Sa_menor_b(2));
	COMP4: COMP_BIT port map( a(0),b(0),V_Sa_Igual_b(2),V_Sa_maior_b(2),V_Sa_menor_b(2),V_Sa_Igual_b(3),V_Sa_maior_b(3),V_Sa_menor_b(3));

   Sa_Igual_b <= V_Sa_Igual_b(3);
   Sa_maior_b <= V_Sa_maior_b(3);
   Sa_menor_b <= V_Sa_menor_b(3);
 
end logic;


--============-- 
-- COMPARADOR --
--============--

entity COMPARADOR is
  port(a,b: in bit_vector(9 downto 0);
			igual,maior, menor: out bit);
end COMPARADOR;

architecture logic of COMPARADOR is

component COMP4 is
  port(a,b: in bit_vector(3 downto 0);
			Sa_Igual_b, Sa_maior_b, Sa_menor_b: out bit);
end component;

signal a_vetor_centena, a_vetor_dezena, a_vetor_unidade,b_vetor_centena, b_vetor_dezena, b_vetor_unidade:bit_vector(3 downto 0);
signal saida_centena, saida_dezena, saida_unidade: bit_vector (2 downto 0);
signal AmaiorB_1, AmaiorB_2, AmaiorB_3, AmaiorB_4:bit;
signal maiors1, iguals:bit;

begin

  a_vetor_centena(3) <= '0';
  a_vetor_centena(2) <= '0';
  a_vetor_centena(1) <= a(9);
  a_vetor_centena(0) <= a(8);
  b_vetor_centena(3) <= '0';
  b_vetor_centena(2) <= '0';
  b_vetor_centena(1) <= b(9);
  b_vetor_centena(0) <= b(8);

  a_vetor_dezena(3 downto 0) <= a(7 downto 4);
  b_vetor_dezena(3 downto 0) <= b(7 downto 4);
  a_vetor_unidade(3 downto 0) <= a(3 downto 0);
  b_vetor_unidade(3 downto 0) <= b(3 downto 0);
  
 	COMP1: COMP4 port map( a_vetor_centena,b_vetor_centena,saida_centena(2),saida_centena(1),saida_centena(0));
	COMP2: COMP4 port map( a_vetor_dezena,b_vetor_dezena,saida_dezena(2),saida_dezena(1),saida_dezena(0));
	COMP3: COMP4 port map( a_vetor_unidade,b_vetor_unidade,saida_unidade(2),saida_unidade(1),saida_unidade(0));
  
  AmaiorB_1 <= ((not saida_centena(0)) and ((not saida_dezena(0)) and (not saida_unidade(0))));
  AmaiorB_2 <= saida_centena(1);
  AmaiorB_3 <= saida_centena(2) and saida_dezena(1);
  AmaiorB_4 <= (saida_centena(2) and (saida_dezena(2) and saida_unidade(1)));
  
  igual <= saida_centena(2) and saida_dezena(2) and saida_unidade(2);
  iguals <= saida_centena(2) and saida_dezena(2) and saida_unidade(2);
  maiors1 <= (AmaiorB_1 or AmaiorB_2 or AmaiorB_3 or AmaiorB_4);
  maior <= maiors1 and (not iguals); 
  menor <= not maiors1;
  
  
end logic;


--======--
-- STEP --
--======--

entity STEP4 is
  port(a: in bit_vector(3 downto 0);
			 step,load,clk: in bit;
			 b: out bit_vector(3 downto 0));
end STEP4;

architecture logic of STEP4 is

component ffd is
	port ( clk ,D ,P , C : IN BIT;
		q: OUT BIT );
END component;
  
  signal D1,D2,D3,D4:bit;
  signal Q:bit_vector (3 downto 0);
  
  begin
  
  D1 <= ((not (step and load)) and Q(0)) or (a(0) and (step and load));
  D2 <= ((not (step and load)) and Q(1)) or (a(1) and (step and load));
  D3 <= ((not (step and load)) and Q(2)) or (a(2) and (step and load));
  D4 <= ((not (step and load)) and Q(3)) or (a(3) and (step and load));
  
  flip1: ffd port map (clk,D1,'1','1',Q(0));
  flip2: ffd port map (clk,D2,'1','1',Q(1));
  flip3: ffd port map (clk,D3,'1','1',Q(2));
  flip4: ffd port map (clk,D4,'1','1',Q(3));
  
  b(3 downto 0) <= Q(3 downto 0);
  
end logic;


--======--
-- LOAD --
--======--

entity LOAD is
  port(a: in bit_vector(9 downto 0);
			 mxmi,load,clk: in bit;
			 b: out bit_vector(9 downto 0));
end LOAD;

architecture logic of LOAD is

component ffd is
	port ( clk ,D ,P , C : IN BIT;
		q: OUT BIT );
END component;
  
  signal D1,D2,D3,D4,D5,D6,D7,D8,D9,D10:bit;
  signal Q:bit_vector (9 downto 0);
  
  begin
  
  D1 <= ((not (mxmi and load)) and Q(0)) or (a(0) and (mxmi and load));
  D2 <= ((not (mxmi and load)) and Q(1)) or (a(1) and (mxmi and load));
  D3 <= ((not (mxmi and load)) and Q(2)) or (a(2) and (mxmi and load));
  D4 <= ((not (mxmi and load)) and Q(3)) or (a(3) and (mxmi and load));
  D5 <= ((not (mxmi and load)) and Q(4)) or (a(4) and (mxmi and load));
  D6 <= ((not (mxmi and load)) and Q(5)) or (a(5) and (mxmi and load));
  D7 <= ((not (mxmi and load)) and Q(6)) or (a(6) and (mxmi and load));
  D8 <= ((not (mxmi and load)) and Q(7)) or (a(7) and (mxmi and load));
  D9 <= ((not (mxmi and load)) and Q(8)) or (a(8) and (mxmi and load));
  D10 <= ((not (mxmi and load)) and Q(9)) or (a(9) and (mxmi and load));
  
  flip1: ffd port map (clk,D1,'1','1',Q(0));
  flip2: ffd port map (clk,D2,'1','1',Q(1));
  flip3: ffd port map (clk,D3,'1','1',Q(2));
  flip4: ffd port map (clk,D4,'1','1',Q(3));
  flip5: ffd port map (clk,D5,'1','1',Q(4));
  flip6: ffd port map (clk,D6,'1','1',Q(5));
  flip7: ffd port map (clk,D7,'1','1',Q(6));
  flip8: ffd port map (clk,D8,'1','1',Q(7));
  flip9: ffd port map (clk,D9,'1','1',Q(8));
  flip10: ffd port map (clk,D10,'1','1',Q(9));
  
  b(9 downto 0) <= Q(9 downto 0);
  
end logic;


--=========--
-- MAX/MIN --
--=========--
entity MAX_MIN is 
	port(reg: in bit_vector(9 downto 0);
	up_down, mxmi, maior, menor: in bit;
	lim, r, set: out bit_vector (9 downto 0));
end MAX_MIN;

architecture logic of MAX_MIN is

component MUX21 is
   port(A, B, S: in bit;
      O: out bit);
end component;

signal lim_default: bit_vector(9 downto 0);
signal clear0,clear1: bit;

begin
	
	clear0 <= up_down and maior;
	clear1 <= not up_down and menor;
	
	mux1: MUX21 port map ('0','1',up_down,lim_default(9));
	mux2: MUX21 port map ('0','1',up_down,lim_default(8));
	mux3: MUX21 port map ('0','1',up_down,lim_default(7));
	mux4: MUX21 port map ('0','1',up_down,lim_default(6));
	mux5: MUX21 port map ('0','1',up_down,lim_default(5));
	mux6: MUX21 port map ('0','0',up_down,lim_default(4));
	mux7: MUX21 port map ('0','0',up_down,lim_default(3));
	mux8: MUX21 port map ('0','1',up_down,lim_default(2));
	mux9: MUX21 port map ('0','1',up_down,lim_default(1));
	mux10: MUX21 port map ('0','1',up_down,lim_default(0));
	
	mux11: MUX21 port map (lim_default(9),reg(9),mxmi,lim(9));
	mux12: MUX21 port map (lim_default(8),reg(8),mxmi,lim(8));
	mux13: MUX21 port map (lim_default(7),reg(7),mxmi,lim(7));
	mux14: MUX21 port map (lim_default(6),reg(6),mxmi,lim(6));
	mux15: MUX21 port map (lim_default(5),reg(5),mxmi,lim(5));
	mux16: MUX21 port map (lim_default(4),reg(4),mxmi,lim(4));
	mux17: MUX21 port map (lim_default(3),reg(3),mxmi,lim(3));
	mux18: MUX21 port map (lim_default(2),reg(2),mxmi,lim(2));
	mux19: MUX21 port map (lim_default(1),reg(1),mxmi,lim(1));
	mux20: MUX21 port map (lim_default(0),reg(0),mxmi,lim(0));
	
	mux211: MUX21 port map (clear0,'0',clear1,r(9));
	mux22: MUX21 port map (clear0,'0',clear1,r(8));
	mux23: MUX21 port map (clear0,'0',clear1,r(7));
	mux24: MUX21 port map (clear0,'0',clear1,r(6));
	mux25: MUX21 port map (clear0,'0',clear1,r(5));
	mux26: MUX21 port map (clear0,'1',clear1,r(4));
	mux27: MUX21 port map (clear0,'1',clear1,r(3));
	mux28: MUX21 port map (clear0,'0',clear1,r(2));
	mux29: MUX21 port map (clear0,'0',clear1,r(1));
	mux30: MUX21 port map (clear0,'0',clear1,r(0));
	
	mux31: MUX21 port map ('0','1',clear1,set(9));
	mux32: MUX21 port map ('0','1',clear1,set(8));
	mux33: MUX21 port map ('0','1',clear1,set(7));
	mux34: MUX21 port map ('0','1',clear1,set(6));
	mux35: MUX21 port map ('0','1',clear1,set(5));
	mux36: MUX21 port map ('0','0',clear1,set(4));
	mux37: MUX21 port map ('0','0',clear1,set(3));
	mux38: MUX21 port map ('0','1',clear1,set(2));
	mux39: MUX21 port map ('0','1',clear1,set(1));
	mux40: MUX21 port map ('0','1',clear1,set(0));
	
	

end logic;


--=====--
-- CLR --
--=====--

entity CLR is
  port(step: in bit_vector(3 downto 0);
             mxmi,clrr: in bit;
             b: out bit_vector(3 downto 0);
             mxmi_clr: out bit);
end CLR;

architecture logic of CLR is

component MUX21 is
   port(A, B, S: in bit;
      O: out bit);
end component;

signal mx_mi_clrs:bit;
signal reg:bit_vector(3 downto 0);

begin

mux1: MUX21 port map('0','1',clrr,mx_mi_clrs);
mux2: MUX21 port map('1',step(0),clrr,b(0));
mux3: MUX21 port map('0',step(1),clrr,b(1));
mux4: MUX21 port map('0',step(2),clrr,b(2));
mux5: MUX21 port map('0',step(3),clrr,b(3));

mxmi_clr <= mx_mi_clrs and mxmi;

end logic;


--========================--
-- FLIP-FLOPS DO CONTADOR --
--========================--

entity FLIP10 is
	port(set,reset,soma,sub: in bit_vector (9 downto 0);
	     up_down, clk: in bit;
		   TLL: out bit_vector(9 downto 0));
end FLIP10;

architecture logic of FLIP10 is

component ffd is
	port ( clk ,D ,P , C : IN BIT;
		q: OUT BIT );
END component;

component MUX21 is
   port(A, B, S: in bit;
      O: out bit);
end component;

signal TL,TLLs:bit_vector(9 downto 0);

begin

mux1: MUX21 port map (sub(0),soma(0),up_down,TL(0));
mux2: MUX21 port map (sub(1),soma(1),up_down,TL(1));
mux3: MUX21 port map (sub(2),soma(2),up_down,TL(2));
mux4: MUX21 port map (sub(3),soma(3),up_down,TL(3));
mux5: MUX21 port map (sub(4),soma(4),up_down,TL(4));  
mux6: MUX21 port map (sub(5),soma(5),up_down,TL(5));
mux7: MUX21 port map (sub(6),soma(6),up_down,TL(6));
mux8: MUX21 port map (sub(7),soma(7),up_down,TL(7));
mux9: MUX21 port map (sub(8),soma(8),up_down,TL(8));
mux10: MUX21 port map (sub(9),soma(9),up_down,TL(9));

flip1: ffd port map (clk,TL(0),set(0),reset(0),TLLs(0));
flip2: ffd port map (clk,TL(1),set(1),reset(1),TLLs(1));
flip3: ffd port map (clk,TL(2),set(2),reset(2),TLLs(2));
flip4: ffd port map (clk,TL(3),set(3),reset(3),TLLs(3));
flip5: ffd port map (clk,TL(4),set(4),reset(4),TLLs(4));
flip6: ffd port map (clk,TL(5),set(5),reset(5),TLLs(5));
flip7: ffd port map (clk,TL(6),set(6),reset(6),TLLs(6));
flip8: ffd port map (clk,TL(7),set(7),reset(7),TLLs(7));
flip9: ffd port map (clk,TL(8),set(8),reset(8),TLLs(8));
flip10: ffd port map (clk,TL(9),set(9),reset(9),TLLs(9));

TLL(9 downto 0) <= TLLs(9 downto 0);

end logic;


--==========--
-- CONTADOR --
--==========--

entity contador is
	port(A2,A1,A0: in bit_vector(3 downto 0);
		up_down, step, mx_mi, loadd, clrr, clk, led: in bit;
		Q2,Q1,Q0: out bit_vector(3 downto 0));
end contador;

architecture logic of contador is

component FLIP10 is
  port(set,reset,soma,sub: in bit_vector (9 downto 0);
	   up_down, clk: in bit;
		TLL: out bit_vector(9 downto 0));
end component;

component STEP4 is
  port(a: in bit_vector(3 downto 0);
			 step,load,clk: in bit;
			 b: out bit_vector(3 downto 0));
end component;

component LOAD is
  port(a: in bit_vector(9 downto 0);
			 mxmi,load,clk: in bit;
			 b: out bit_vector(9 downto 0));
end component;

component ADD10 is
   port(A, B: in bit_vector(9 downto 0);
		O: out bit_vector(9 downto 0);
      CO: out bit);
end component;

component SUB is
  port(A, B: in bit_vector(9 downto 0);
       O: out bit_vector(9 downto 0);
       CO: out bit);
end component;

component MAX_MIN is 
	port(reg: in bit_vector(9 downto 0);
	up_down, mxmi, maior, menor: in bit;
	lim, r, set: out bit_vector (9 downto 0));
end component;

component COMPARADOR is
  port(a,b: in bit_vector(9 downto 0);
			igual,maior, menor: out bit);
end component;

component CLR is
  port(step: in bit_vector(3 downto 0);
      mxmi,clrr: in bit;
      b: out bit_vector(3 downto 0);
      mxmi_clr: out bit);
end component;

component decod_bcd_16bits is
	port(bin: in bit_vector(9 downto 0);
		bcd: out bit_vector (15 downto 0));
end component;

signal bcd: bit_Vector (15 downto 0);
signal sum_temp, sub_temp, cont10, subb, sum, TLL, r, set, lim, reg10:bit_vector(9 downto 0);
signal reg4,steps: bit_vector(3 downto 0);
signal CO,CO_SUM,CO_SUB,maior,menor,igual, maxmin:bit;

begin

sum_temp(9 downto 4) <= "000000";
sum_temp(3 downto 0) <= steps (3 downto 0);
sub_temp(9 downto 4) <= "111111";
sub_temp(3 downto 0) <= steps (3 downto 0);

CLEAR: CLR port map (reg4, mx_mi, clrr, steps, maxmin);

step1: STEP4 port map(A0, step, loadd, clk, reg4);

load1: LOAD port map( TLL, maxmin, loadd,clk,reg10);

subt: SUB port map(TLL, sub_temp, subb, CO_SUB);

sumt: ADD10 port map(TLL, sum_temp, sum, CO_SUM);

MX_MIS: MAX_MIN port map(reg10, up_down, maxmin, maior, menor, lim, r, set);
 
COMP: COMPARADOR port map(TLL, lim, igual, maior,menor); 

FLIP_S: FLIP10 port map(set, r, sum, subb, up_down, clk, TLL);

BIN_BCD: decod_bcd_16bits port map(TLL, bcd);

Q2 <= bcd(11 downto 8);
Q1 <= bcd(7 downto 4);
Q0 <= bcd(3 downto 0);

end logic;
