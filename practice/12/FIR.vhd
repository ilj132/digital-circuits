-- AUTOR: ISAAC DE LRYA JUNIOR

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
-- SOMADOR 8 BITS --
--=================--
entity ADD8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: OUT BIT);
end ADD8;

architecture CKT of ADD8 is

component HALF_ADD is
    port(A, B: in bit;
        S, CO: out bit);
end component;

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM : bit_vector(6 downto 0);

begin

    S0: HALF_ADD port map(A(0), B(0), O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), B(6), VAI_UM(5), O(6), VAI_UM(6));
    S7: COMP_ADD port map(A(7), B(7), VAI_UM(6), O(7), CO);

end CKT;


--=================--
-- SOMADOR 9 BITS --
--=================--
entity ADD9 is
    port(A, B: in bit_vector(8 downto 0);
            O: out bit_vector(8 downto 0);
            CO: OUT BIT );
end ADD9;

architecture CKT of ADD9 is

component HALF_ADD is
    port(A, B: in bit;
        S, CO: out bit);
end component;

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM: bit_vector(7 downto 0);

begin

    S0: HALF_ADD port map(A(0), B(0), O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), B(6), VAI_UM(5), O(6), VAI_UM(6));
	S7: COMP_ADD port map(A(7), B(7), VAI_UM(6), O(7), VAI_UM(7));
    S8: COMP_ADD port map(A(8), B(8), VAI_UM(7), O(8), CO);
	
end CKT;

--======================--
-- MULTIPLICADOR 4 BITS --
--======================--
entity MUL4 is
    port(A, B: in bit_vector(3 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end MUL4;

architecture hardware of MUL4 is

component ADD8
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

signal PP1, PP2, PP3, PP4, S0, S1: bit_vector(7 downto 0);
signal VAI_UM: bit_vector(1 downto 0);

begin
    PP1(0) <= B(0) and A(0);
    PP1(1) <= B(0) and A(1);
    PP1(2) <= B(0) and A(2);
    PP1(3) <= B(0) and A(3);
    PP1(4) <= '0';
    PP1(5) <= '0';
    PP1(6) <= '0';
    PP1(7) <= '0';
    
    PP2(0) <= '0';
    PP2(1) <= B(1) and A(0);
    PP2(2) <= B(1) and A(1);
    PP2(3) <= B(1) and A(2);
    PP2(4) <= B(1) and A(3);
    PP2(5) <= '0';
    PP2(6) <= '0';
    PP2(7) <= '0';
    
    PP3(0) <= '0';
    PP3(1) <= '0';
    PP3(2) <= B(2) and A(0);
    PP3(3) <= B(2) and A(1);
    PP3(4) <= B(2) and A(2);
    PP3(5) <= B(2) and A(3);
    PP3(6) <= '0';
    PP3(7) <= '0';

    PP4(0) <= '0';
    PP4(1) <= '0';
    PP4(2) <= '0';
    PP4(3) <= B(3) and A(0);
    PP4(4) <= B(3) and A(1);
    PP4(5) <= B(3) and A(2);
    PP4(6) <= B(3) and A(3);
    PP4(7) <= '0'; 
    
    SOMA0: ADD8 port map(PP1, PP2, S0, VAI_UM(0));
    SOMA1: ADD8 port map(S0, PP3, S1, VAI_UM(1));
    SOMA2: ADD8 port map(S1, PP4, O, CO);
	
end hardware;

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

    CLEAR <= CLR;

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


--=====================--
-- REGISTRADOR 10 BITS --
--=====================--
ENTITY REG10 IS
    PORT( I: IN BIT_VECTOR(9 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(9 DOWNTO 0));
END REG10;

ARCHITECTURE CKT OF REG10 IS

COMPONENT ffd IS
    port ( clk ,D ,P , C : IN BIT ;
    q : OUT BIT );
END COMPONENT;

COMPONENT MUX21 is
    port(A, B, S: in bit;
       O: out bit);
 end COMPONENT;

SIGNAL CLEAR:BIT;
SIGNAL Q,D: BIT_VECTOR(9 DOWNTO 0);

BEGIN

CLEAR <= CLR;

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

O<= Q;

END CKT;


--===========--
-- BLOCO RxC --
--===========--
ENTITY RC_BLOCK IS
    PORT(C, Y : IN BIT_VECTOR(3 DOWNTO 0);
        ld_r, ld_c, clr_r, CLK: IN BIT;
        S: OUT BIT_VECTOR(7 DOWNTO 0);
        YS: OUT BIT_VECTOR(3 DOWNTO 0));
END RC_BLOCK;

ARCHITECTURE CKT OF RC_BLOCK IS

COMPONENT MUL4 IS
    port(A, B: in bit_vector(3 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
END COMPONENT;

COMPONENT REG4 IS
    PORT( I: IN BIT_VECTOR(3 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(3 DOWNTO 0));
END COMPONENT;

SIGNAL CS, Ym: BIT_VECTOR(3 DOWNTO 0);
SIGNAL CO: BIT;

BEGIN

REG1: REG4 PORT MAP(C, CLK, '1', ld_c, CS);
REG2: REG4 PORT MAP(Y, CLK, clr_r, ld_r, Ym);

MULTIPLICADOR: MUL4 PORT MAP(CS, Ym, S, CO);

YS<= Ym;

END CKT;


--=================--
-- CODIFICADOR 2X4 --
--=================--
ENTITY COD24 IS
    PORT(SC0, SC1, EN: IN BIT;
        S0,S1,S2,S3: OUT BIT);
END COD24;

ARCHITECTURE CKT OF COD24 IS

BEGIN 

S0 <= NOT SC0 AND NOT SC1 AND EN;
S1 <= SC0 AND NOT SC1 AND EN;
S2 <= NOT SC0 AND SC1 AND EN;
S3 <= SC0 AND SC1 AND EN;

END CKT;


--===================--
-- BLOCO OPERACIONAL --
--===================--
ENTITY BLOCK_OP IS
    PORT( C, Y : IN BIT_VECTOR (3 DOWNTO 0);  
        clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1, CLK: IN BIT;
        F: OUT BIT_VECTOR(9 DOWNTO 0));
END BLOCK_OP;

ARCHITECTURE CKT OF BLOCK_OP IS

COMPONENT COD24 IS
    PORT(SC0, SC1, EN: IN BIT;
        S0,S1,S2,S3: OUT BIT);
END COMPONENT;

COMPONENT RC_BLOCK IS
    PORT(C, Y : IN BIT_VECTOR(3 DOWNTO 0);
        ld_r, ld_c, clr_r, CLK: IN BIT;
        S: OUT BIT_VECTOR(7 DOWNTO 0);
        YS: OUT BIT_VECTOR(3 DOWNTO 0));
END COMPONENT;

COMPONENT REG10 IS
    PORT( I: IN BIT_VECTOR(9 DOWNTO 0);
        CLK, CLR, EN: IN BIT;
        O: OUT BIT_VECTOR(9 DOWNTO 0));
END COMPONENT;

COMPONENT ADD9 is
    port(A, B: in bit_vector(8 downto 0);
            O: out bit_vector(8 downto 0);
            CO: OUT BIT );
end COMPONENT;

COMPONENT ADD8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: OUT BIT );
end COMPONENT;


SIGNAL  ld_c0, ld_c1, ld_c2, ld_c3, CO1,CO2: BIT;
SIGNAL Y1, Y2, Y3: BIT_VECTOR(3 DOWNTO 0);
SIGNAL YC1, YC2, YC3, AUXSUM1: BIT_VECTOR(7 DOWNTO 0);
SIGNAL AUX, SUM1, AUXSUM2: BIT_VECTOR(8 DOWNTO 0);
SIGNAL SUM2: BIT_VECTOR(9 DOWNTO 0);

BEGIN

C_DEF: COD24 PORT MAP(s_cod0, s_cod1 , en_cod, ld_c0, ld_c1, ld_c2, ld_c3);


RC1: RC_BLOCK PORT MAP(C, Y, ld_r, ld_c0, clr_r, CLK, YC1, Y1);
RC2: RC_BLOCK PORT MAP(C, Y1, ld_r, ld_c1, clr_r, CLK, YC2, Y2);
RC3: RC_BLOCK PORT MAP(C, Y2, ld_r, ld_c2, clr_r, CLK, YC3, Y3);

AUX(8) <= '0';
AUX(7 DOWNTO 0) <= YC3;

SOMA1: ADD8 PORT MAP(YC1, YC2, AUXSUM1, CO1);
SOMA2: ADD9 PORT MAP(SUM1, AUX, AUXSUM2, CO2);

SUM1(8)<= CO1;
SUM1(7 DOWNTO 0) <= AUXSUM1;

SUM2(9)<= CO2;
SUM2(8 DOWNTO 0) <= AUXSUM2 ;

REGISTRA: REG10 PORT MAP(SUM2, CLK, '1', ld_out, F);

END CKT;


--===========================--
-- LÓGICA BOTÃO SINCRONIZADO --
--===========================--
ENTITY LOG_BS IS
    PORT(Q1, Q0, B: IN BIT;
        D1, D0, PRESS: OUT BIT);
END LOG_BS;

ARCHITECTURE CKT OF LOG_BS IS

BEGIN

D1 <= (NOT Q1 AND Q0) OR (Q1 AND NOT Q0 AND B);
D0 <= NOT Q1 AND NOT Q0 AND B;
PRESS <= NOT Q1 AND Q0;

END CKT;


--====================--
-- BOTÃO SINCRONIZADO --
--====================--
ENTITY BS IS
PORT(CLK, B: IN BIT;
    PRESS: OUT BIT);
END BS;

ARCHITECTURE CKT OF BS IS

COMPONENT ffd IS
    port ( clk ,D ,P , C : IN BIT ;
    q : OUT BIT );
END COMPONENT;

COMPONENT LOG_BS IS
    PORT(Q1, Q0, B: IN BIT;
        D1, D0, PRESS: OUT BIT);
END COMPONENT;

SIGNAL Q1,Q0,D1,D0:BIT;

BEGIN

LOGIC: LOG_BS PORT MAP (Q1, Q0, B, D1, D0, PRESS);
FFD1: ffd PORT MAP(CLK, D1, '1', '1', Q1);
FFD2: ffd PORT MAP(CLK, D0, '1', '1', Q0);

END CKT;


--===========================================--
-- LÓGICA COMBINACIONAL DO BLOCO DE CONTROLE --
--===========================================--
ENTITY LOG_COMB IS
PORT(Q2, Q1, Q0, PRESS: IN BIT;
    D2, D1, D0, clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1: OUT BIT);
END LOG_COMB;

ARCHITECTURE CKT OF LOG_COMB IS

BEGIN

D2 <= NOT Q2 AND Q1 AND Q0;
D1 <= (NOT Q2 AND NOT Q1 AND Q0) OR ( NOT Q2 AND Q1 AND NOT Q0);
D0 <= (NOT Q2 AND NOT Q0 AND PRESS) OR  (NOT Q2 AND Q1 AND NOT Q0);
clr_r <= (NOT Q1 AND NOT Q0) OR  (NOT Q2 AND Q1);
ld_r <= (NOT Q2 AND Q0) OR  (NOT Q2 AND Q1) OR  (Q2 AND NOT Q1 AND NOT Q0);
ld_out <= NOT Q2 AND NOT Q1 AND NOT Q0;
en_cod <= (NOT Q2 AND Q1) OR  (Q2 AND NOT Q1 AND NOT Q0);
s_cod0 <= NOT Q2 AND Q1 AND Q0;
s_cod1 <= Q2 AND NOT Q1 AND NOT Q0;

END CKT;


--===================--
-- BLOCO DE CONTROLE --
--===================--
ENTITY BLOCK_CON IS
PORT(B, CLK: IN BIT;
    clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1: OUT BIT);
END BLOCK_CON;

ARCHITECTURE CKT OF BLOCK_CON IS

COMPONENT ffd IS
    port ( clk ,D ,P , C : IN BIT ;
    q : OUT BIT );
END COMPONENT;

COMPONENT LOG_COMB IS
PORT(Q2, Q1, Q0, PRESS: IN BIT;
    D2, D1, D0, clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1: OUT BIT);
END COMPONENT;

COMPONENT BS IS
PORT(CLK, B: IN BIT;
    PRESS: OUT BIT);
END COMPONENT;

SIGNAL Q2, Q1, Q0, PRESS, D2, D1, D0: BIT;

BEGIN

DEF_PRESS: BS PORT MAP(CLK, B, PRESS);

LOGIC: LOG_COMB PORT MAP (Q2, Q1, Q0, PRESS, D2, D1, D0, clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1);

FFD1: ffd PORT MAP(CLK, D2, '1', '1', Q2);
FFD2: ffd PORT MAP(CLK, D1, '1', '1', Q1);
FFD3: ffd PORT MAP(CLK, D0, '1', '1', Q0);

END CKT;


--============--
-- FILTRO FIR --
--============--
ENTITY FIR IS
	PORT(Y, C : IN BIT_VECTOR(3 DOWNTO 0);
		B, CLK: IN BIT;
		F: OUT BIT_VECTOR(9 DOWNTO 0));
END FIR;

ARCHITECTURE CKT OF FIR IS

COMPONENT BLOCK_CON IS
PORT(B, CLK: IN BIT;
    clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1: OUT BIT);
END COMPONENT;

COMPONENT BLOCK_OP IS
    PORT( C, Y : IN BIT_VECTOR (3 DOWNTO 0);  
        clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1, CLK: IN BIT;
        F: OUT BIT_VECTOR(9 DOWNTO 0));
END COMPONENT;

SIGNAL clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1: BIT;

BEGIN

BLOCOCONTROLE: BLOCK_CON PORT MAP(B, CLK, clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1);
BLOCOOPERACIONAL: BLOCK_OP PORT MAP(C, Y, clr_r, ld_r, ld_out, en_cod, s_cod0, s_cod1, CLK, F);

END CKT;