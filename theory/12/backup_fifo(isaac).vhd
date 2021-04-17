-- BY: ISAAC DE LYRA JUNIOR 

--==============--
-- MEIO SOMADOR --
--==============--
entity HALF_ADD is
    port(A, B: in bit;
            S, CO: out bit);
end HALF_ADD;

architecture CKT of HALF_ADD is

begin

    S <= A xor B;
    CO <= A and B;

end CKT;


--==================--
-- SOMADOR COMPLETO --
--==================--
entity COMP_ADD is
    port(A, B, CI: in bit;
            S, CO: out bit);
end COMP_ADD;

architecture CKT of COMP_ADD is

begin

    S <= A xor B xor CI;
    CO <= (B and CI) or (A and CI) or (A and B);

end CKT;


--=================--
-- SOMADOR 4 BITS --
--=================--
entity ADD4 is
    port(A, B: in bit_vector(3 downto 0);
            O: out bit_vector(3 downto 0);
            CO: out bit);
end ADD4;

architecture CKT of ADD4 is

component HALF_ADD is
    port(A, B: in bit;
        S, CO: out bit);
end component;

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM: bit_vector(2 downto 0);

begin

S0: HALF_ADD port map(A(0), B(0), O(0), VAI_UM(0));
S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), CO);

end CKT;


--====================--
--  REGISTRADOR 1 BIT --
--====================--
ENTITY REG IS
    PORT( I: IN BIT;
        CLK, CLR, EN: IN BIT;
        O: OUT BIT);
END REG;

ARCHITECTURE CKT OF REG IS

COMPONENT ffd IS
    port ( clk ,D ,P , C : IN BIT ;
    q : OUT BIT );
END COMPONENT;

COMPONENT MUX21 is
    port(A, B, S: in bit;
       O: out bit);
 end COMPONENT;

SIGNAL CLEAR:BIT;
SIGNAL Q,D: BIT;

BEGIN

    CLEAR <= NOT CLR;

    MUX1:  MUX21 PORT MAP(Q, I, EN, D);

    FFD1: ffd PORT MAP (CLK, D, '1', CLEAR, Q);

    O<= Q;

END CKT;

--=====================--
--  REGISTRADOR 4 BITS --
--=====================--
ENTITY REG4 IS
    PORT( I: IN BIT_VECTOR(3 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(3 DOWNTO 0));
END REG4;

ARCHITECTURE CKT OF REG4 IS

COMPONENT ffd IS
    port ( clk ,D ,P , C : IN BIT ;
    q : OUT BIT );
END COMPONENT;

COMPONENT MUX21 is
    port(A, B, S: in bit;
       O: out bit);
 end COMPONENT;

SIGNAL CLEAR:BIT;
SIGNAL Q,D: BIT_VECTOR(3 DOWNTO 0);

BEGIN

    CLEAR <= NOT CLR;

    MUX1:  MUX21 PORT MAP(Q(0), I(0), EN, D(0));
    MUX2:  MUX21 PORT MAP(Q(1), I(1), EN, D(1));
    MUX3:  MUX21 PORT MAP(Q(2), I(2), EN, D(2));
    MUX4:  MUX21 PORT MAP(Q(3), I(3), EN, D(3));


    FFD1: ffd PORT MAP (CLK, D(0), '1', CLEAR, Q(0));
    FFD2: ffd PORT MAP (CLK, D(1), '1', CLEAR, Q(1));
    FFD3: ffd PORT MAP (CLK, D(2), '1', CLEAR, Q(2));
    FFD4: ffd PORT MAP (CLK, D(3), '1', CLEAR, Q(3));

    O<= Q;

END CKT;


--=======================--
-- SOMADOR + REGISTRADOR --
--=======================--
ENTITY SOMAREG IS
    PORT(B: IN BIT_VECTOR(3 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        AC: OUT BIT_VECTOR(3 DOWNTO 0));
END SOMAREG;

ARCHITECTURE CKT OF SOMAREG IS

COMPONENT ADD4 is
    port(A, B: in bit_vector(3 downto 0);
            O: out bit_vector(3 downto 0);
            CO: out bit);
end COMPONENT;

COMPONENT REG4 IS
    PORT( I: IN BIT_VECTOR(3 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(3 DOWNTO 0));
END COMPONENT;

SIGNAL RELOAD, RES: BIT_VECTOR(3 DOWNTO 0);
SIGNAL CO: BIT;

BEGIN

ADICAO: ADD4 PORT MAP (RELOAD, B, RES, CO);
REGISTRA: REG4 PORT MAP (RES, CLK, CLR, EN, RELOAD);
AC <= RELOAD(3 DOWNTO 0);

END CKT;


--===============================--
-- COMPARADOR DE MAGNITUDE 1 BIT --
--===============================--
entity COMP_BIT is
    port(A, B, maior,igual, menor: in bit;
              AgtB, AeqB, AltB: out bit);
end COMP_BIT;
  
ARCHITECTURE CKT OF COMP_BIT IS
    
BEGIN

    AgtB <= (((not B) and A) and igual) or maior;
    AeqB <= ((A xnor B) and igual);
    AltB <= (((not A) and B) and igual) or menor;
    
END CKT;


--================================-- 
-- COMPARADOR DE MAGNITUDE 4 BITS --
--================================--
entity COMP4 is
    port(A,B: in bit_vector(3 downto 0);
              AgtB, AeqB, AltB: out bit);
end COMP4;
  
ARCHITECTURE CKT OF COMP4 IS
    
component COMP_BIT is
     port(A, B, maior,igual, menor: in bit;
              AgtB, AeqB, AltB: out bit);
end component;
  
signal GT, EQ, LT: bit_vector(10 downto 0);
  
begin

COMP1: COMP_BIT port map(A(3), B(3), '0', '1', '0', GT(3), EQ(3), LT(3));
COMP2: COMP_BIT port map(A(2), B(2), GT(3), EQ(3), LT(3), GT(2), EQ(2), LT(2));
COMP3: COMP_BIT port map(A(1), B(1), GT(2), EQ(2), LT(2), GT(1), EQ(1), LT(1));
COMP4: COMP_BIT port map(A(0), B(0), GT(1), EQ(1), LT(1), GT(0), EQ(0), LT(0)); 

AgtB <= GT(0);
AeqB <= EQ(0);
AltB <= LT(0);
  
end CKT;


--======================--
-- DEMULTIPLEXADOR 1x16 --
--======================--
ENTITY DEMUX16 IS
	PORT(I, EN: in bit;
		W: in bit_vector(3 downto 0);
		LD: out bit_vector(15 downto 0));
END DEMUX16;

ARCHITECTURE CKT OF DEMUX16 IS

BEGIN

	LD(0) <=  EN and I and (not W(3) and not W(2) and not W(1) and not W(0));
	LD(1) <=  EN and I and (not W(3) and not W(2) and not W(1) and W(0));
	LD(2) <=  EN and I and (not W(3) and not W(2) and W(1) and not W(0));
	LD(3) <=  EN and I and (not W(3) and not W(2) and W(1) and W(0));
	LD(4) <=  EN and I and (not W(3) and W(2) and not W(1) and not W(0));
	LD(5) <=  EN and I and (not W(3) and W(2) and not W(1) and W(0));
	LD(6) <=  EN and I and (not W(3) and W(2) and W(1) and not W(0));
	LD(7) <=  EN and I and (not W(3) and W(2) and W(1) and W(0));
	LD(8) <=  EN and I and (W(3) and not W(2) and not W(1) and not W(0));
	LD(9) <=  EN and I and (W(3) and not W(2) and not W(1) and W(0));
	LD(10) <= EN and I and (W(3) and not W(2) and W(1) and not W(0));
	LD(11) <= EN and I and (W(3) and not W(2) and W(1) and W(0));
	LD(12) <= EN and I and (W(3) and W(2) and not W(1) and not W(0));
	LD(13) <= EN and I and (W(3) and W(2) and not W(1) and W(0));
	LD(14) <= EN and I and (W(3) and W(2) and W(1) and not W(0));
	LD(15) <= EN and I and (W(3) and W(2) and W(1) and W(0));
	
END CKT;


--===================--
-- MULTIPLEXADOR 2x1 -- 
--===================--
entity MUX21 is
    port(A, B, S: in bit;
       O: out bit);
end MUX21;

architecture CKT of MUX21 is

begin

    O <= (B and S) or (A and (not S));

end CKT;


--==============================--
-- MULTIPLEXADOR 2x1 de 13 bits -- 
--==============================--
ENTITY MUX21_13B IS
	PORT(A, B : IN BIT_VECTOR(12 DOWNTO 0);
		S: IN BIT;
		O: OUT BIT_VECTOR(12 DOWNTO 0));
END MUX21_13B;

ARCHITECTURE CKT OF MUX21_13B IS

COMPONENT MUX21 IS
	PORT(A,B,S: IN BIT;
		O: OUT BIT);
END COMPONENT;

BEGIN

BIT0: MUX21 PORT MAP (A(0), B(0), S, O(0));
BIT1: MUX21 PORT MAP (A(1), B(1), S, O(1));
BIT2: MUX21 PORT MAP (A(2), B(2), S, O(2));
BIT3: MUX21 PORT MAP (A(3), B(3), S, O(3));
BIT4: MUX21 PORT MAP (A(4), B(4), S, O(4));
BIT5: MUX21 PORT MAP (A(5), B(5), S, O(5));
BIT6: MUX21 PORT MAP (A(6), B(6), S, O(6));
BIT7: MUX21 PORT MAP (A(7), B(7), S, O(7));
BIT8: MUX21 PORT MAP (A(8), B(8), S, O(8));
BIT9: MUX21 PORT MAP (A(9), B(9), S, O(9));
BIT10: MUX21 PORT MAP (A(10), B(10), S, O(10));
BIT11: MUX21 PORT MAP (A(11), B(11), S, O(11));
BIT12: MUX21 PORT MAP (A(12), B(12), S, O(12));

END CKT;


--====================--
-- MULTIPLEXADOR 16x1 --
--====================--
ENTITY MUX16 IS
	PORT(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT;
		S: in bit_vector(3 downto 0);
		O: out bit);
END MUX16;

ARCHITECTURE CKT OF MUX16 IS

BEGIN

	O <= (I0 AND NOT S(3) AND NOT S(2) AND NOT S(1) AND NOT S(0)) 
	OR (I1 AND NOT S(3) AND NOT S(2) AND NOT S(1) AND S(0)) 
	OR (I2 AND NOT S(3) AND NOT S(2) AND S(1) AND NOT S(0))
	OR (I3 AND NOT S(3) AND NOT S(2) AND S(1) AND S(0)) 
	OR (I4 AND NOT S(3) AND S(2) AND NOT S(1) AND NOT S(0)) 
	OR (I5 AND NOT S(3) AND S(2) AND NOT S(1) AND S(0))
	OR (I6 AND NOT S(3) AND S(2) AND S(1) AND NOT S(0)) 
	OR (I7 AND NOT S(3) AND S(2) AND S(1) AND S(0)) 
	OR (I8 AND S(3) AND NOT S(2) AND NOT S(1) AND NOT S(0))
	OR (I9 AND S(3) AND NOT S(2) AND NOT S(1) AND S(0)) 
	OR (I10 AND S(3) AND NOT S(2) AND S(1) AND NOT S(0)) 
	OR (I11 AND S(3) AND NOT S(2) AND S(1) AND S(0))
	OR (I12 AND S(3) AND S(2) AND NOT S(1) AND NOT S(0))
	OR (I13 AND S(3) AND S(2) AND NOT S(1) AND S(0))
	OR (I14 AND S(3) AND S(2) AND S(1) AND NOT S(0))
	OR (I15 AND S(3) AND S(2) AND S(1) AND S(0));

END CKT;


--===============================--
-- MULTIPLEXADOR 16x1 DE 13 BITS --
--===============================--
entity MUX16_13B is
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT_VECTOR(12 DOWNTO 0);
		S: in bit_vector(3 downto 0);
		O: out BIT_VECTOR(12 DOWNTO 0));
end MUX16_13B;

architecture ckt of MUX16_13B is

COMPONENT MUX16 IS
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT;
		S: in bit_vector(3 downto 0);
		O: out bit);
END COMPONENT;

begin

	BIT0: MUX16 PORT MAP (I0(0), I1(0), I2(0), I3(0), I4(0), I5(0), I6(0), I7(0), I8(0), I9(0), I10(0), I11(0), I12(0), I13(0), I14(0), I15(0), S, O(0));
	BIT1: MUX16 PORT MAP (I0(1), I1(1), I2(1), I3(1), I4(1), I5(1), I6(1), I7(1), I8(1), I9(1), I10(1), I11(1), I12(1), I13(1), I14(1), I15(1), S, O(1));
	BIT2: MUX16 PORT MAP (I0(2), I1(2), I2(2), I3(2), I4(2), I5(2), I6(2), I7(2), I8(2), I9(2), I10(2), I11(2), I12(2), I13(2), I14(2), I15(2), S, O(2));
	BIT3: MUX16 PORT MAP (I0(3), I1(3), I2(3), I3(3), I4(3), I5(3), I6(3), I7(3), I8(3), I9(3), I10(3), I11(3), I12(3), I13(3), I14(3), I15(3), S, O(3));
	BIT4: MUX16 PORT MAP (I0(4), I1(4), I2(4), I3(4), I4(4), I5(4), I6(4), I7(4), I8(4), I9(4), I10(4), I11(4), I12(4), I13(4), I14(4), I15(4), S, O(4));
	BIT5: MUX16 PORT MAP (I0(5), I1(5), I2(5), I3(5), I4(5), I5(5), I6(5), I7(5), I8(5), I9(5), I10(5), I11(5), I12(5), I13(5), I14(5), I15(5), S, O(5));
	BIT6: MUX16 PORT MAP (I0(6), I1(6), I2(6), I3(6), I4(6), I5(6), I6(6), I7(6), I8(6), I9(6), I10(6), I11(6), I12(6), I13(6), I14(6), I15(6), S, O(6));
	BIT7: MUX16 PORT MAP (I0(7), I1(7), I2(7), I3(7), I4(7), I5(7), I6(7), I7(7), I8(7), I9(7), I10(7), I11(7), I12(7), I13(7), I14(7), I15(7), S, O(7));
	BIT8: MUX16 PORT MAP (I0(8), I1(8), I2(8), I3(8), I4(8), I5(8), I6(8), I7(8), I8(8), I9(8), I10(8), I11(8), I12(8), I13(8), I14(8), I15(8), S, O(8));
	BIT9: MUX16 PORT MAP (I0(9), I1(9), I2(9), I3(9), I4(9), I5(9), I6(9), I7(9), I8(9), I9(9), I10(9), I11(9), I12(9), I13(9), I14(9), I15(9), S, O(9));
	BIT10: MUX16 PORT MAP (I0(10), I1(10), I2(10), I3(10), I4(10), I5(10), I6(10), I7(10), I8(10), I9(10), I10(10), I11(10), I12(10), I13(10), I14(10), I15(10), S, O(10));
	BIT11: MUX16 PORT MAP (I0(11), I1(11), I2(11), I3(11), I4(11), I5(11), I6(11), I7(11), I8(11), I9(11), I10(11), I11(11), I12(11), I13(11), I14(11), I15(11), S, O(11));
	BIT12: MUX16 PORT MAP (I0(12), I1(12), I2(12), I3(12), I4(12), I5(12), I6(12), I7(12), I8(12), I9(12), I10(12), I11(12), I12(12), I13(12), I14(12), I15(12), S, O(12));

end ckt;


--============--
-- FLIPFLOP D --
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


--=====================--
-- REGISTRADOR 13 BITS --
--=====================--
ENTITY REG13 IS
    PORT( I: IN BIT_VECTOR(12 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(12 DOWNTO 0));
END REG13;

ARCHITECTURE CKT OF REG13 IS

COMPONENT ffd IS
    port ( clk ,D ,P , C : IN BIT ;
    q : OUT BIT );
END COMPONENT;

COMPONENT MUX21 is
    port(A, B, S: in bit;
       O: out bit);
 end COMPONENT;

SIGNAL CLEAR:BIT;
SIGNAL Q,D: BIT_VECTOR(12 DOWNTO 0);

BEGIN

CLEAR <= NOT CLR;

MUX1:  MUX21 PORT MAP(Q(0), I(0), EN, D(0));
MUX2:  MUX21 PORT MAP(Q(1), I(1), EN, D(1));
MUX3:  MUX21 PORT MAP(Q(2), I(2), EN, D(2));
MUX4:  MUX21 PORT MAP(Q(3), I(3), EN, D(3));
MUX5:  MUX21 PORT MAP(Q(4), I(4), EN, D(4));
MUX6:  MUX21 PORT MAP(Q(5), I(5), EN, D(5));
MUX7:  MUX21 PORT MAP(Q(6), I(6), EN, D(6));
MUX8:  MUX21 PORT MAP(Q(7), I(7), EN, D(7));
MUX9:  MUX21 PORT MAP(Q(8), I(8), EN, D(8));
MUX10: MUX21 PORT MAP(Q(9), I(9), EN, D(9));
MUX11: MUX21 PORT MAP(Q(10), I(10), EN, D(10));
MUX12: MUX21 PORT MAP(Q(11), I(11), EN, D(11));
MUX13: MUX21 PORT MAP(Q(12), I(12), EN, D(12));

FFD1: ffd PORT MAP (CLK, D(0), '1', CLEAR, Q(0));
FFD2: ffd PORT MAP (CLK, D(1), '1', CLEAR, Q(1));
FFD3: ffd PORT MAP (CLK, D(2), '1', CLEAR, Q(2));
FFD4: ffd PORT MAP (CLK, D(3), '1', CLEAR, Q(3));
FFD5: ffd PORT MAP (CLK, D(4), '1', CLEAR, Q(4));
FFD6: ffd PORT MAP (CLK, D(5), '1', CLEAR, Q(5));
FFD7: ffd PORT MAP (CLK, D(6), '1', CLEAR, Q(6));
FFD8: ffd PORT MAP (CLK, D(7), '1', CLEAR, Q(7));
FFD9: ffd PORT MAP (CLK, D(8), '1', CLEAR, Q(8));
FFD10: ffd PORT MAP (CLK, D(9), '1', CLEAR, Q(9));
FFD11: ffd PORT MAP (CLK, D(10), '1', CLEAR, Q(10));
FFD12: ffd PORT MAP (CLK, D(11), '1', CLEAR, Q(11));
FFD13: ffd PORT MAP (CLK, D(12), '1', CLEAR, Q(12));

O<= Q;

END CKT;


--================--
-- BANCO DE DADOS --
--================--
ENTITY BANCO IS
	PORT(WD: IN BIT_VECTOR(12 DOWNTO 0); -- VALOR A SER GUARDADO
		W, R: IN BIT_VECTOR(3 DOWNTO 0); -- CONTADORES DE ESCRITA E LEITURA, RESPECTIVAMENTE
		CLR, CLK, WR: IN BIT; -- CLEAR E CLOCK
		RD: OUT BIT_VECTOR(12 DOWNTO 0)); -- RD É O VALOR A SER LIDO, OS REGDs SÃO OS VALORES ARMAZENADOS DOS 16 REGISTRADORES
END BANCO;

ARCHITECTURE CKT OF BANCO IS

COMPONENT REG13 IS
    PORT( I: IN BIT_VECTOR(12 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(12 DOWNTO 0));
END COMPONENT;

COMPONENT MUX16_13B is
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT_VECTOR(12 DOWNTO 0);
		S: in bit_vector(3 downto 0);
		O: out BIT_VECTOR(12 DOWNTO 0));
END COMPONENT;

COMPONENT DEMUX16 IS
	port(I, EN: in bit;
		W: in bit_vector(3 downto 0);
		LD: out bit_vector(15 downto 0));
END COMPONENT;

SIGNAL LD: BIT_VECTOR (15 DOWNTO 0);
SIGNAL IWD, R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15: BIT_VECTOR(12 DOWNTO 0);

BEGIN

DEF_LD: DEMUX16 PORT MAP('1', WR, W, LD);

DEF_REGD0: REG13 PORT MAP(WD, CLK, CLR, LD(0), R0);
DEF_REGD1: REG13 PORT MAP(WD, CLK, CLR, LD(1), R1);
DEF_REGD2: REG13 PORT MAP(WD, CLK, CLR, LD(2), R2);
DEF_REGD3: REG13 PORT MAP(WD, CLK, CLR, LD(3), R3);
DEF_REGD4: REG13 PORT MAP(WD, CLK, CLR, LD(4), R4);
DEF_REGD5: REG13 PORT MAP(WD, CLK, CLR, LD(5), R5);
DEF_REGD6: REG13 PORT MAP(WD, CLK, CLR, LD(6), R6);
DEF_REGD7: REG13 PORT MAP(WD, CLK, CLR, LD(7), R7);
DEF_REGD8: REG13 PORT MAP(WD, CLK, CLR, LD(8), R8);
DEF_REGD9: REG13 PORT MAP(WD, CLK, CLR, LD(9), R9);
DEF_REGD10: REG13 PORT MAP(WD, CLK, CLR, LD(10), R10);
DEF_REGD11: REG13 PORT MAP(WD, CLK, CLR, LD(11), R11);
DEF_REGD12: REG13 PORT MAP(WD, CLK, CLR, LD(12), R12);
DEF_REGD13: REG13 PORT MAP(WD, CLK, CLR, LD(13), R13);
DEF_REGD14: REG13 PORT MAP(WD, CLK, CLR, LD(14), R14);
DEF_REGD15: REG13 PORT MAP(WD, CLK, CLR, LD(15), R15);

DEF_RD: MUX16_13B PORT MAP(R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15, R, RD);

END CKT;

--===============================--
-- LÓGICA COMBINACIONAL BOTÃO BS --
--===============================--
ENTITY LOGIC_BS IS 
    PORT(Q1, Q0, T: IN BIT;
        D1, D0, PRESS: OUT BIT);
END LOGIC_BS;

ARCHITECTURE CKT OF LOGIC_BS IS

BEGIN

D1 <= (NOT Q1 AND Q0) OR (Q1 AND NOT Q0 AND T);
D0 <= NOT Q1 AND NOT Q0 AND T;
PRESS <= NOT Q1 AND Q0;

END CKT;


--==========--
-- BOTÃO BS --
--==========--
ENTITY BS IS
    PORT(CLK, T: IN BIT;
        PRESS: OUT BIT);
END BS;

ARCHITECTURE CKT OF BS IS

COMPONENT ffd is
    PORT ( clk ,D ,P , C : IN BIT ;
		q : OUT BIT );
END COMPONENT;

COMPONENT LOGIC_BS IS 
    PORT(Q1, Q0, T: IN BIT;
        D1, D0, PRESS: OUT BIT);
END COMPONENT;

SIGNAL Q1,Q0,D1,D0:BIT;

BEGIN

LOGIC: LOGIC_BS PORT MAP (Q1, Q0, T, D1, D0, PRESS);
FFD1: ffd PORT MAP(CLK, D1, '1', '1', Q1);
FFD2: ffd PORT MAP(CLK, D0, '1', '1', Q0);

END CKT;


--===========================================--
-- LÓGICA COMBINACIONAL DO BLOCO DE CONTROLE --
--===========================================--
ENTITY LOGICA_COMB IS 
	PORT(Q1, Q0, CLRB, RDB, WRB, EM, FU: IN BIT;
		D1, D0, CLR, RD, WR: OUT BIT);
END LOGICA_COMB;

ARCHITECTURE CKT OF LOGICA_COMB IS

BEGIN

D1 <=  (NOT Q1 AND NOT Q0 AND NOT CLRB) OR (NOT Q1 AND NOT Q0 AND RDB AND NOT WRB AND NOT EM);
D0 <=  (NOT Q1 AND NOT Q0 AND NOT CLRB) OR (NOT Q1 AND NOT Q0 AND NOT RDB AND WRB AND NOT FU);
CLR <= NOT(Q1 AND Q0);
RD <=  (Q1 AND NOT Q0 AND FU) OR (Q1 AND NOT Q0 AND EM) OR (Q1 AND NOT Q0 AND WRB) OR (Q1 AND NOT Q0 AND RDB) OR (Q1 AND NOT Q0 AND CLRB);
WR <=  NOT Q1 AND Q0;

END CKT;

--===================--
-- BLOCO DE CONTROLE --
--===================--
ENTITY BLOCOCONTROLE IS
	PORT(CLK, CLRB, RDB, WRB, EM, FU: IN BIT;
		CLR, RD, WR: OUT BIT);
END BLOCOCONTROLE;

ARCHITECTURE CKT OF BLOCOCONTROLE IS

COMPONENT LOGICA_COMB IS
	PORT(Q1, Q0, CLRB, RDB, WRB, EM, FU: IN BIT;
		D1, D0, CLR, RD, WR: OUT BIT);
END COMPONENT;

COMPONENT BS IS
    PORT(CLK, T: IN BIT;
        PRESS: OUT BIT);
END COMPONENT;

COMPONENT ffd is
    PORT ( clk ,D ,P , C : IN BIT ;
		q : OUT BIT );
END COMPONENT;

SIGNAL Q, D: BIT_VECTOR(1 DOWNTO 0);
SIGNAL RDBS, WRBS, CLR_LOG, CLR_OUT: BIT;

BEGIN

BSINC1: BS PORT MAP(CLK, RDB, RDBS);
BSINC2: BS PORT MAP(CLK, WRB, WRBS);
CLR_LOG <= NOT CLRB;
LOGICA: LOGICA_COMB PORT MAP(Q(1), Q(0), CLR_LOG, RDBS, WRBS, EM, FU, D(1), D(0), CLR_OUT, RD, WR);

FFD1: ffd PORT MAP (CLK, D(0), '1', '1', Q(0));
FFD2: ffd PORT MAP (CLK, D(1), '1', '1', Q(1));
CLR <= NOT CLR_OUT;

END CKT;


--===================--
-- BLOCO OPERACIONAL --
--===================--
ENTITY BLOCK_OP IS
	PORT(W_DATA: IN BIT_VECTOR(12 DOWNTO 0);
		CLK, CLR, WR, RD: IN BIT;
		R_DATA: OUT BIT_VECTOR(12 DOWNTO 0);
		WRVA, RDVA: OUT BIT_VECTOR(3 DOWNTO 0);
		FU, EM: OUT BIT);
END BLOCK_OP;

ARCHITECTURE CKT OF BLOCK_OP IS

COMPONENT SOMAREG IS
	PORT(B: IN BIT_VECTOR(3 DOWNTO 0);
		CLK, CLR, EN: IN BIT;
		AC: OUT BIT_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT COMP4 is
    port(A,B: in bit_vector(3 downto 0);
              AgtB, AeqB, AltB: out bit);
END COMPONENT;

COMPONENT REG IS
    PORT( I: IN BIT;
        CLK, CLR, EN: IN BIT;
        O: OUT BIT);
END COMPONENT;

COMPONENT BANCO IS
	PORT(WD: IN BIT_VECTOR(12 DOWNTO 0); 
		W, R: IN BIT_VECTOR(3 DOWNTO 0); 
		CLR, CLK, WR: IN BIT;
		RD: OUT BIT_VECTOR(12 DOWNTO 0)); 
END COMPONENT;

SIGNAL WRV, RDV: BIT_VECTOR(3 DOWNTO 0);
SIGNAL WReqRD, WRgtRD, WRltRD, EN_OPB, D_OPB, OPB: BIT;

BEGIN
	
	CONT1: SOMAREG PORT MAP("0001", CLK, CLR, WR, WRV);
	CONT2: SOMAREG PORT MAP("0001", CLK, CLR, RD, RDV);

	COMP: COMP4 PORT MAP(WRV, RDV, WRgtRD, WReqRD, WRltRD);
	DEF_BANCO: BANCO PORT MAP(W_DATA, WRV, RDV, CLR, CLK, WR, R_DATA);

	EN_OPB <= WR OR RD;
	D_OPB <= NOT RD;
	DEF_OPB: REG PORT MAP( D_OPB, CLK, CLR, EN_OPB, OPB);

	FU <= WReqRD AND OPB;
	EM <= WReqRD AND NOT OPB;
	WRVA <= WRV;
	RDVA <= RDV;

END CKT;

--============--
-- FIFO 16x13 --
--============--
entity fifo is
	port(W_DATA: IN BIT_VECTOR (12 DOWNTO 0);
		CLK, WRB, RDB, CLR_FIFO: IN BIT;
		R_DATA: OUT BIT_VECTOR (12 DOWNTO 0);
		WRV, RDV: OUT BIT_VECTOR(3 DOWNTO 0);
		FU, EM: OUT BIT);
end fifo;

architecture ckt of fifo is

COMPONENT BLOCK_OP IS
	PORT(W_DATA: IN BIT_VECTOR(12 DOWNTO 0);
		CLK, CLR, WR, RD: IN BIT;
		R_DATA: OUT BIT_VECTOR(12 DOWNTO 0);
		WRVA, RDVA: OUT BIT_VECTOR(3 DOWNTO 0);
		FU, EM: OUT BIT);
END COMPONENT;

COMPONENT BLOCOCONTROLE IS
	PORT(CLK, CLRB, RDB, WRB, EM, FU: IN BIT;
		CLR, RD, WR: OUT BIT);
END COMPONENT;

SIGNAL CLR, WR, RD, FULL, EMPTY: BIT;

begin

OPERACIONAL: BLOCK_OP PORT MAP(W_DATA, CLK, CLR, WR, RD, R_DATA, WRV, RDV, FULL, EMPTY);
CONTROLE: BLOCOCONTROLE PORT MAP(CLK, CLR_FIFO, RDB, WRB, EMPTY, FULL, CLR, RD, WR);

FU <= FULL;
EM <= EMPTY;

end ckt;