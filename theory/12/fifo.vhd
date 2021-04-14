--======================--
-- DEMULTIPLEXADOR 1x16 --
--======================--
ENTITY DEMUX16 IS
	PORT(I: in bit;
		W: in bit_vector(3 downto 0);
		LD: out bit_vector(15 downto 0));
END DEMUX16;

ARCHITECTURE CKT OF DEMUX16 IS

BEGIN

	LD(0) <=  I and (not W(3) and not W(2) and not W(1) and not W(0));
	LD(1) <=  I and (not W(3) and not W(2) and not W(1) and W(0));
	LD(2) <=  I and (not W(3) and not W(2) and W(1) and not W(0));
	LD(3) <=  I and (not W(3) and not W(2) and W(1) and W(0));
	LD(4) <=  I and (not W(3) and W(2) and not W(1) and not W(0));
	LD(5) <=  I and (not W(3) and W(2) and not W(1) and W(0));
	LD(6) <=  I and (not W(3) and W(2) and W(1) and not W(0));
	LD(7) <=  I and (not W(3) and W(2) and W(1) and W(0));
	LD(8) <=  I and (W(3) and not W(2) and not W(1) and not W(0));
	LD(9) <=  I and (W(3) and not W(2) and not W(1) and W(0));
	LD(10) <= I and (W(3) and not W(2) and W(1) and not W(0));
	LD(11) <= I and (W(3) and not W(2) and W(1) and W(0));
	LD(12) <= I and (W(3) and W(2) and not W(1) and not W(0));
	LD(13) <= I and (W(3) and W(2) and not W(1) and W(0));
	LD(14) <= I and (W(3) and W(2) and W(1) and not W(0));
	LD(15) <= I and (W(3) and W(2) and W(1) and W(0));
	
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
		CLR, CLK: IN BIT; -- CLEAR E CLOCK
		RD,REGD0, REGD1, REGD2, REGD3, REGD4, REGD5, REGD6, REGD7, REGD8, REGD9, REGD10, REGD11, REGD12, REGD13, REGD14, REGD15: OUT BIT_VECTOR(12 DOWNTO 0)); -- RD É O VALOR A SER LIDO, OS REGDs SÃO OS VALORES ARMAZENADOS DOS 16 REGISTRADORES
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
	port(I: in bit;
		W: in bit_vector(3 downto 0);
		LD: out bit_vector(15 downto 0));
END COMPONENT;

SIGNAL LD: BIT_VECTOR (15 DOWNTO 0);
SIGNAL R0, R1, R2, R3, R4, R5, R6, R7, R8, R9, R10, R11, R12, R13, R14, R15: BIT_VECTOR(12 DOWNTO 0);

BEGIN

DEF_LD: DEMUX16 PORT MAP('1', W, LD);

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

REGD0 <= R0;
REGD1 <= R1;
REGD2 <= R2;
REGD3 <= R3;
REGD4 <= R4;
REGD5 <= R5;
REGD6 <= R6;
REGD7 <= R7;
REGD8 <= R8;
REGD9 <= R9;
REGD10 <= R10;
REGD11 <= R11;
REGD12 <= R12;
REGD13 <= R13;
REGD14 <= R14;
REGD15 <= R15;

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




-----------------------------------------------------------
entity fifo is
	port(A: in bit;
		B: out bit);
end fifo;

architecture ckt of fifo is

begin

end ckt;