-- AUTOR: ISAAC DE LYRA JUNIOR --

--=====================--
-- DISPLAY 7 SEGMENTOS --
--=====================--

entity D7SEG is
   port (I: in bit_vector (3 downto 0);	
		O: out bit_vector (6 downto 0));
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
-- DECODIFICADOR Bin-BCD (8 bits) --
--=================================--

entity decod_bcd_8bits is
	port(bin: in bit_vector(5 downto 0);
		bcd: out bit_vector (7 downto 0));
end decod_bcd_8bits;

architecture logic of decod_bcd_8bits is

component bloco_bin_bcd
	port(A: in bit_vector(3 downto 0);
			S: out bit_vector(3 downto 0));
end component;

	signal B1_A, B1_S, B2_A, B2_S, B3_A, B3_S, B4_A, B4_S, 
		B5_A, B5_S, B6_A, B6_S, B7_A, B7_S: bit_vector(3 downto 0);

begin
	B1_A(3) <= '0';
	B1_A(2) <= '0';
	B1_A(1) <= '0';
	B1_A(0) <= bin(5);
	
	B1: bloco_bin_bcd port map(B1_A, B1_S);
	
	B2_A(3) <= B1_S(2);
	B2_A(2) <= B1_S(1);
	B2_A(1) <= B1_S(0);
	B2_A(0) <= bin(4);
	
	B2: bloco_bin_bcd port map(B2_A, B2_S);
	
	B3_A(3) <= B2_S(2);
	B3_A(2) <= B2_S(1);
	B3_A(1) <= B2_S(0);
	B3_A(0) <= bin(3);
	
	B3: bloco_bin_bcd port map(B3_A, B3_S);
	
	B4_A(3) <= B3_S(2);
	B4_A(2) <= B3_S(1);
	B4_A(1) <= B3_S(0);
	B4_A(0) <= bin(2);
	
	B4: bloco_bin_bcd port map(B4_A, B4_S);
	
	B5_A(3) <= '0';
	B5_A(2) <= B1_S(3);
	B5_A(1) <= B2_S(3);
	B5_A(0) <= B3_S(3);
	
	B5: bloco_bin_bcd port map(B5_A, B5_S);
	
	B6_A(3) <= B4_S(2);
	B6_A(2) <= B4_S(1);
	B6_A(1) <= B4_S(0);
	B6_A(0) <= bin(1);
	
	B6: bloco_bin_bcd port map(B6_A, B6_S);
	
	B7_A(3) <= B5_S(2);
	B7_A(2) <= B5_S(1);
	B7_A(1) <= B5_S(0);
	B7_A(0) <= B4_S(3);
	
	B7: bloco_bin_bcd port map(B7_A, B7_S);
	
	
	bcd(7) <= B7_S(2);
	bcd(6) <= B7_S(1);
	bcd(5) <= B7_S(0);
	bcd(4) <= B6_S(3);
	bcd(3) <= B6_S(2);
	bcd(2) <= B6_S(1);
	bcd(1) <= B6_S(0);
	bcd(0) <= bin(0);
	
end logic;


--===================--
-- MULTIPLEXADOR 2x1 -- 
--===================--

entity MUX21 is
   port(A, B, S: in bit;
      O: out bit);
end MUX21;

architecture logic of MUX21 is

begin
    O <= (B and S) or (A and (not S));
end logic;


--===================--
-- MULTIPLEXADOR 4x1 -- 
--===================--

entity MUX41 is
	port(A, B, C, D, S1, S0: in bit;
	   	O: out bit);
 end MUX41;
 
 architecture logic of MUX41 is
 signal S: bit_vector(1 downto 0);
 begin

	S(1) <= S1;
	S(0) <= S0;

	O <= (not S(1) and not S(0) and A) or (not S(1) and S(0) and B) or (S(1) and not S(0) and C) or ( S(1) and S(0) and D); 

 end logic;


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


--====================--
-- REGISTRADOR 6 BITS --
--====================--

entity REG6 is
	port(A: in bit_vector(5 downto 0);
		ligar, clk: in bit;
		B: out bit_vector(5 downto 0));
end REG6;

architecture logic of REG6 is

component MUX21 is
	port(A, B, S: in bit;
		O: out bit);
end component;

component ffd is
	port ( clk ,D ,P , C : IN BIT;
		q: OUT BIT );
END component;
  
  signal D,Q:bit_vector (5 downto 0);
  
  begin
  
  MUX1: MUX21 port map (Q(0), A(0), ligar, D(0));
  MUX2: MUX21 port map (Q(1), A(1), ligar, D(1));
  MUX3: MUX21 port map (Q(2), A(2), ligar, D(2));
  MUX4: MUX21 port map (Q(3), A(3), ligar, D(3));
  MUX5: MUX21 port map (Q(4), A(4), ligar, D(4));
  MUX6: MUX21 port map (Q(5), A(5), ligar, D(5));
  
  FFD1: ffd port map (clk, D(0), '1', '1', Q(0));
  FFD2: ffd port map (clk, D(1), '1', '1', Q(1));
  FFD3: ffd port map (clk, D(2), '1', '1', Q(2));
  FFD4: ffd port map (clk, D(3), '1', '1', Q(3));
  FFD5: ffd port map (clk, D(4), '1', '1', Q(4));
  FFD6: ffd port map (clk, D(5), '1', '1', Q(5));
  
  B<=Q;
  
  
end logic;


--==================================--
-- COMPARADOR DE MAGNITUDE (1 bits) --
--==================================--

entity COMP_BIT is
  port(A, B, maior,igual, menor: in bit;
			AgtB, AeqB, AltB: out bit);
end COMP_BIT;

architecture logic of COMP_BIT is
  
begin

	AgtB <= (((not B) and A) and igual) or maior;
   	AeqB <= ((A xnor B) and igual);
   	AltB <= (((not A) and B) and igual) or menor;
	
end logic;


--===================================-- 
-- COMPARADOR DE MAGNITUDE (6 bits) --
--===================================--

entity COMP6 is
  port(A,B: in bit_vector(5 downto 0);
			AgtB, AeqB, AltB: out bit);
end COMP6;

architecture logic of COMP6 is
  
component COMP_BIT is
   port(A, B, maior,igual, menor: in bit;
			AgtB, AeqB, AltB: out bit);
end component;

signal GT, EQ, LT: bit_vector(5 downto 0);

begin

	COMP1: COMP_BIT port map( A(5), B(5),'0','1','0', GT(5), EQ(5), LT(5));
	COMP2: COMP_BIT port map( A(4), B(4), GT(5), EQ(5), LT(5), GT(4), EQ(4), LT(4));
	COMP3: COMP_BIT port map( A(3), B(3), GT(4), EQ(4), LT(4), GT(3), EQ(3), LT(3));
	COMP4: COMP_BIT port map( A(2), B(2), GT(3), EQ(3), LT(3), GT(2), EQ(2), LT(2));
	COMP5: COMP_BIT port map( A(1), B(1), GT(2), EQ(2), LT(2), GT(1), EQ(1), LT(1));
	COMP6: COMP_BIT port map( A(0), B(0), GT(1), EQ(1), LT(1), GT(0), EQ(0), LT(0));
	
	AgtB <= GT(0);
	AeqB <= EQ(0);
	AltB <= LT(0);

end logic;


--===================================-- 
-- COMPARADOR DE MAGNITUDE (18 bits) --
--===================================--

entity COMP18 is
  port(A, B, C, SENHA1, SENHA2, SENHA3: in bit_vector(5 downto 0);
			SENHA: out bit);
end COMP18;

architecture logic of COMP18 is
  
component COMP6 is
   port(A,B: in bit_vector(5 downto 0);
			AgtB, AeqB, AltB: out bit);
end component;

signal GT, EQ, LT: bit_vector(2 downto 0);

begin

	COMP1: COMP6 port map( A, SENHA1, GT(2), EQ(2), LT(2));
	COMP2: COMP6 port map( B, SENHA2, GT(1), EQ(1), LT(1));
	COMP3: COMP6 port map( C, SENHA3, GT(0), EQ(0), LT(0));
	
	SENHA <= EQ(2) and EQ(1) and EQ(0);

end logic;


--====================--
-- MUDANÇA DE ESTADOS --
--====================--

ENTITY MUDA IS
	PORT(CLK: IN BIT; 
		D: IN BIT_VECTOR(3 DOWNTO 0);
		Q: OUT BIT_VECTOR(3 DOWNTO 0));
END MUDA;

ARCHITECTURE LOGIC OF MUDA IS

COMPONENT ffd IS
	port ( clk ,D ,P , C : IN BIT ;
		q : OUT BIT );
END COMPONENT;

BEGIN

	FFD1: ffd port map(CLK, D(0), '1', '1', Q(0));
	FFD2: ffd port map(CLK, D(1), '1', '1', Q(1));
	FFD3: ffd port map(CLK, D(2), '1', '1', Q(2));
	FFD4: ffd port map(CLK, D(3), '1', '1', Q(3));

END LOGIC;


--=========--
-- ESTADOS --
--=========--

entity ESTADOS is
	port(Q: IN BIT_VECTOR(3 DOWNTO 0);
		ADC, PWR, T5, T20, SENHA: in bit;
		D: OUT BIT_VECTOR(3 DOWNTO 0);
		LEDR, LEDG, LEDB, O, Display, TD5, TD20: out bit);
end ESTADOS;

architecture logic of ESTADOS is

SIGNAL Q3,Q2,Q1,Q0,D3,D2,D1,D0: BIT;

begin

	Q3<= Q(3);
	Q2<= Q(2);
	Q1<= Q(1);
	Q0<= Q(0);


D(3) <= (not Q3 and Q2 and Q1 and not Q0 and ADC and not PWR) or (Q3 and not Q2 and not Q1 and not Q0 and not T5) or (Q3 and not Q2 and not Q1 and not Q0 and SENHA) or 
		(Q3 and not Q2 and not Q1 and Q0 and not T20);

D(2) <= (not Q3 and Q1 and not Q0 and PWR) or (not Q3 and not Q2 and Q1 and Q0 and T5) or (not Q3 and Q2 and not Q1) or (not Q3 and Q2 and not Q0 and not ADC) or 
		(not Q3 and Q2 and Q0 and not T5);

D(1) <= (not Q3 and not Q1 and Q0 and T5) or (not Q3 and not Q2 and Q1 and not Q0) or (not Q3 and Q2 and not Q0 and PWR) or (not Q3 and Q1 and not Q0 and not ADC) or 
		(not Q3 and Q1 and Q0 and not T5);

D(0) <= (not Q3 and not Q0 and PWR) or (not Q3 and Q0 and not T5) or (not Q3 and not Q2 and Q1 and not Q0 and ADC) or (not Q3 and Q2 and not Q1 and not Q0 and ADC) or 
		(Q3 and not Q2 and not Q1 and not Q0 and T5 and SENHA) or (Q3 and not Q2 and not Q1 and Q0 and not T20);

LEDR <= (not Q3 and not Q0);

LEDG <= (Q3 and not Q2 and not Q1 and Q0);

LEDB <= (not Q3 and Q0) or (Q3 and not Q2 and not Q1 and not Q0);

O <= (Q3 and not Q2 and not Q1 and Q0 and not T5);

Display <= (not Q3 and Q1) or (not Q3 and Q2) or (Q3 and not Q2 and not Q1);

TD5 <= (not Q3 and Q0 and not T5) or (Q3 and not Q2 and not Q1 and not Q0 and not T5);

TD20 <= (Q3 and not Q2 and not Q1 and Q0 and not T20);

end logic;


--==================--
-- TIMER 5 SEGUNDOS --
--==================--

ENTITY TIMER5 IS
	PORT(CLK, TD5: IN BIT;
		T5:OUT BIT);
END TIMER5;

ARCHITECTURE LOGIC OF TIMER5 IS

COMPONENT ffd IS
	port ( clk ,D ,P , C : IN BIT ;
		q : OUT BIT );
END COMPONENT;

SIGNAL Q: BIT_VECTOR(5 DOWNTO 0);
SIGNAL CLEAR: BIT;

BEGIN
	
	CLEAR <= NOT Q(5);
	
	FFD1: ffd port map(CLK, TD5, '1', CLEAR, Q(0));
	FFD2: ffd port map(CLK, Q(0), '1', CLEAR, Q(1));
	FFD3: ffd port map(CLK, Q(1), '1', CLEAR, Q(2));
	FFD4: ffd port map(CLK, Q(2), '1', CLEAR, Q(3));
	FFD5: ffd port map(CLK, Q(3), '1', CLEAR, Q(4));
	FFD6: ffd port map(CLK, Q(4), '1', CLEAR, Q(5));

	T5 <= Q(4);

END LOGIC;


--==================--
-- TIMER 20 SEGUNDOS --
--==================--

ENTITY TIMER20 IS
	PORT(CLK, TD20: IN BIT;
		T20:OUT BIT);
END TIMER20;

ARCHITECTURE LOGIC OF TIMER20 IS

COMPONENT ffd IS
	port ( clk ,D ,P , C : IN BIT ;
		q : OUT BIT );
END COMPONENT;

SIGNAL Q: BIT_VECTOR (20 DOWNTO 0);
SIGNAL CLEAR: BIT;

BEGIN
	
	CLEAR<= NOT Q(20);

	FFD1: ffd port map(CLK, TD20, '1', CLEAR, Q(0));
	FFD2: ffd port map(CLK, Q(0), '1', CLEAR, Q(1));
	FFD3: ffd port map(CLK, Q(1), '1', CLEAR, Q(2));
	FFD4: ffd port map(CLK, Q(2), '1', CLEAR, Q(3));
	FFD5: ffd port map(CLK, Q(3), '1', CLEAR, Q(4));
	FFD6: ffd port map(CLK, Q(4), '1', CLEAR, Q(5));
	FFD7: ffd port map(CLK, Q(5), '1', CLEAR, Q(6));
	FFD8: ffd port map(CLK, Q(6), '1', CLEAR, Q(7));
	FFD9: ffd port map(CLK, Q(7), '1', CLEAR, Q(8));
	FFD10: ffd port map(CLK, Q(8), '1', CLEAR, Q(9));
	FFD11: ffd port map(CLK, Q(9), '1', CLEAR, Q(10));
	FFD12: ffd port map(CLK, Q(10), '1', CLEAR, Q(11));
	FFD13: ffd port map(CLK, Q(11), '1', CLEAR, Q(12));
	FFD14: ffd port map(CLK, Q(12), '1', CLEAR, Q(13));
	FFD15: ffd port map(CLK, Q(13), '1', CLEAR, Q(14));
	FFD16: ffd port map(CLK, Q(14), '1', CLEAR, Q(15));
	FFD17: ffd port map(CLK, Q(15), '1', CLEAR, Q(16));
	FFD18: ffd port map(CLK, Q(16), '1', CLEAR, Q(17));
	FFD19: ffd port map(CLK, Q(17), '1', CLEAR, Q(18));
	FFD20: ffd port map(CLK, Q(18), '1', CLEAR, Q(19));
	FFD21: ffd port map(CLK, Q(19), '1', CLEAR, Q(20));

	T20 <= Q(19);

END LOGIC;


--==========--
-- DISPLAYS --
--==========--

ENTITY TELA IS
	PORT( V: IN BIT_VECTOR(5 DOWNTO 0);
		Q: IN BIT_VECTOR(3 DOWNTO 0);
		DISPLAY, O: IN BIT;
		DD,UD: OUT BIT_VECTOR(6 DOWNTO 0));
END TELA;

ARCHITECTURE LOGIC OF TELA IS

COMPONENT D7SEG IS
	port (I: in bit_vector (3 downto 0);	
		 O: out bit_vector (6 downto 0));
 END COMPONENT;

COMPONENT decod_bcd_8bits IS
	port(bin: in bit_vector(5 downto 0);
		bcd: out bit_vector (7 downto 0));
END COMPONENT;

COMPONENT MUX41 IS
	port(A, B, C, D, S1, S0: in bit;
	   	O: out bit);
END COMPONENT;

SIGNAL AD, CD, U, D, UNI, DEZ: BIT_VECTOR(6 DOWNTO 0);
SIGNAL BCD: BIT_VECTOR(7 DOWNTO 0);
SIGNAL CANC: BIT;

BEGIN

CANC <= NOT Q(3) AND Q(2) AND Q(1) AND Q(0);
AD <= "0001000";
CD <= "1001001";

BINBCD: decod_bcd_8bits PORT MAP (V, BCD);

BCD7447_1: D7SEG PORT MAP(BCD(7 DOWNTO 4), U);
BCD7447_2: D7SEG PORT MAP(BCD(3 DOWNTO 0), D);

MUX1UNI: MUX41 PORT MAP( U(0), CD(0), AD(0),'0', O, CANC, UNI(0));
MUX2UNI: MUX41 PORT MAP( U(1), CD(1), AD(1),'0', O, CANC, UNI(1));
MUX3UNI: MUX41 PORT MAP( U(2), CD(2), AD(2),'0', O, CANC, UNI(2));
MUX4UNI: MUX41 PORT MAP( U(3), CD(3), AD(3),'0', O, CANC, UNI(3));
MUX5UNI: MUX41 PORT MAP( U(4), CD(4), AD(4),'0', O, CANC, UNI(4));
MUX6UNI: MUX41 PORT MAP( U(5), CD(5), AD(5),'0', O, CANC, UNI(5));
MUX7UNI: MUX41 PORT MAP( U(6), CD(6), AD(6),'0', O, CANC, UNI(6));
 
MUX1DEZ: MUX41 PORT MAP( D(0), CD(0), AD(0),'0', O, CANC, DEZ(0));
MUX2DEZ: MUX41 PORT MAP( D(1), CD(1), AD(1),'0', O, CANC, DEZ(1));
MUX3DEZ: MUX41 PORT MAP( D(2), CD(2), AD(2),'0', O, CANC, DEZ(2));
MUX4DEZ: MUX41 PORT MAP( D(3), CD(3), AD(3),'0', O, CANC, DEZ(3));
MUX5DEZ: MUX41 PORT MAP( D(4), CD(4), AD(4),'0', O, CANC, DEZ(4));
MUX6DEZ: MUX41 PORT MAP( D(5), CD(5), AD(5),'0', O, CANC, DEZ(5));
MUX7DEZ: MUX41 PORT MAP( D(6), CD(6), AD(6),'0', O, CANC, DEZ(6));

DD(0) <= DEZ(0) AND DISPLAY;
DD(1) <= DEZ(1) AND DISPLAY;
DD(2) <= DEZ(2) AND DISPLAY;
DD(3) <= DEZ(3) AND DISPLAY;
DD(4) <= DEZ(4) AND DISPLAY;
DD(5) <= DEZ(5) AND DISPLAY;
DD(6) <= DEZ(6) AND DISPLAY;

UD(0) <= UNI(0) AND DISPLAY;
UD(1) <= UNI(1) AND DISPLAY;
UD(2) <= UNI(2) AND DISPLAY;
UD(3) <= UNI(3) AND DISPLAY;
UD(4) <= UNI(4) AND DISPLAY;
UD(5) <= UNI(5) AND DISPLAY;
UD(6) <= UNI(6) AND DISPLAY;

END LOGIC;


--=========--
-- COFRE --
--=========--

ENTITY COFRE IS
	PORT( V, SENHA1, SENHA2, SENHA3: in bit_vector (5 downto 0);
		CLK, ADC, PWR: in bit;
		DISP1,DISP2: OUT BIT_VECTOR(6 DOWNTO 0);
		LEDR, LEDB, LEDG: OUT bit);
END COFRE;

ARCHITECTURE LOGIC OF COFRE IS

COMPONENT REG6 is
	port(A: in bit_vector(5 downto 0);
			 ligar, clk: in bit;
			 B: out bit_vector(5 downto 0));
END COMPONENT;

COMPONENT COMP18 is
	port(A, B, C, SENHA1, SENHA2, SENHA3: in bit_vector(5 downto 0);
			  SENHA: out bit);
END COMPONENT;

COMPONENT MUDA IS
	PORT(CLK: IN BIT; 
		D: IN BIT_VECTOR(3 DOWNTO 0);
		Q: OUT BIT_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT ESTADOS is
	port(Q: IN BIT_VECTOR(3 DOWNTO 0);
		ADC, PWR, T5, T20, SENHA: in bit;
		D: OUT BIT_VECTOR(3 DOWNTO 0);
		LEDR, LEDG, LEDB, O, Display, TD5, TD20: out bit);
END COMPONENT;

COMPONENT TIMER5 IS
	PORT(CLK, TD5: IN BIT;
		T5:OUT BIT);
END COMPONENT;

COMPONENT TIMER20 IS
	PORT(CLK, TD20: IN BIT;
		T20:OUT BIT);
END COMPONENT;

COMPONENT TELA IS
	PORT( V: IN BIT_VECTOR(5 DOWNTO 0);
		Q: IN BIT_VECTOR(3 DOWNTO 0);
		DISPLAY, O: IN BIT;
		DD,UD: OUT BIT_VECTOR(6 DOWNTO 0));
END COMPONENT;

SIGNAL A,B,C: BIT_VECTOR (5 DOWNTO 0);
SIGNAL D,Q: BIT_VECTOR (3 DOWNTO 0);
SIGNAL LIBERA: BIT_VECTOR (2 DOWNTO 0);
SIGNAL O,TD5,TD20, SENHA, T5,T20, DISPLAY: BIT;


BEGIN

	LIBERA(0) <= Q(1) AND Q(0);
	LIBERA(1) <= NOT Q(1) AND Q(0);
	LIBERA(2) <= NOT Q(1) AND NOT Q(0);
	
	REGSENHA1: REG6 PORT MAP (V, LIBERA(0), CLK, A);
	REGSENHA2: REG6 PORT MAP (V, LIBERA(1), CLK, B);
	REGSENHA3: REG6 PORT MAP (V, LIBERA(2), CLK, C);

	COMPARACAO: COMP18 PORT MAP(A, B, C, SENHA1, SENHA2, SENHA3, SENHA);

	MUDAESTADO: MUDA PORT MAP(CLK, D, Q);
	ESTADO: ESTADOS PORT MAP(Q, ADC, PWR, T5, T20, SENHA, D, LEDR, LEDG, LEDB, O, DISPLAY, TD5, TD20);
	
	TIMER5SEG: TIMER5 PORT MAP(CLK,TD5,T5);
	TIMER20SEG:TIMER20 PORT MAP(CLK,TD20,T20);

	TELA1: TELA PORT MAP(V, Q, DISPLAY, O, DISP1, DISP2);

END LOGIC;