--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M E I O    S O M A D O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity HALF_ADD is
    port(A, B: in bit;
            S, CO: out bit);
end HALF_ADD;

architecture hardware of HALF_ADD is

begin
    S <= A xor B;
    CO <= A and B;
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- S O M A D O R    C O M P L E T O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity COMP_ADD is
    port(A, B, CI: in bit;
            S, CO: out bit);
end COMP_ADD;

architecture hardware of COMP_ADD is

begin
    S <= A xor B xor CI;
    CO <= (B and CI) or (A and CI) or (A and B);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- S O M A D O R    D E     8   B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity ADD8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end ADD8;

architecture hardware of ADD8 is

component HALF_ADD is
    port(A, B: in bit;
        S, CO: out bit);
end component;

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM: bit_vector(6 downto 0);

begin
    S0: HALF_ADD port map(A(0), B(0), O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), B(6), VAI_UM(5), O(6), VAI_UM(6));
    S7: COMP_ADD port map(A(7), B(7), VAI_UM(6), O(7), CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- S U B T R A T O R    DE  8   B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SUB is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO, Z: out bit);
end SUB;

architecture hardware of SUB is

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM: bit_vector(6 downto 0);
signal AUX_B: bit_vector(7 downto 0);

begin
    -- Como é subtrator, então inverte B e soma 1 (VAI_UM='1'). (Complemento de 2: A-B=A+B'+1)

    AUX_B(0) <= not B(0);
    AUX_B(1) <= not B(1);
    AUX_B(2) <= not B(2);
    AUX_B(3) <= not B(3);
    AUX_B(4) <= not B(4);
    AUX_B(5) <= not B(5);
    AUX_B(6) <= not B(6);
    AUX_B(7) <= not B(7);

    S0: COMP_ADD port map(A(0), AUX_B(0), '1', O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), AUX_B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), AUX_B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), AUX_B(3), VAI_UM(2), O(3), VAI_UM(3));
    S4: COMP_ADD port map(A(4), AUX_B(4), VAI_UM(3), O(4), VAI_UM(4));
    S5: COMP_ADD port map(A(5), AUX_B(5), VAI_UM(4), O(5), VAI_UM(5));
    S6: COMP_ADD port map(A(6), AUX_B(6), VAI_UM(5), O(6), VAI_UM(6));
    S7: COMP_ADD port map(A(7), AUX_B(7), VAI_UM(6), O(7), CO);
end hardware ;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- I N C R E M E N T A D O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity INC is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end INC;

architecture hardware of INC is

component ADD8
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

signal UM: bit_vector(7 downto 0);

begin
    UM <= "00000001";
    INC1: ADD8 port map(A, UM, O, CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- D E C R E M E N T A D O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity DEC is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO, Z: out bit);
end DEC;

architecture hardware of DEC is

component SUB
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;
    
signal UM: bit_vector(7 downto 0);
    
begin    
    UM <= "00000001";
    DEC1: SUB port map(A, UM, O, CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L I C A D O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUL is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end MUL;

architecture hardware of MUL is

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
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- A N D
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity AND8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end AND8;

architecture hardware of AND8 is

begin 
    O(0) <= A(0) and B(0);
    O(1) <= A(1) and B(1);
    O(2) <= A(2) and B(2);
    O(3) <= A(3) and B(3);
    O(4) <= A(4) and B(4);
    O(5) <= A(5) and B(5);
    O(6) <= A(6) and B(6);
    O(7) <= A(7) and B(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity OR8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end OR8;

architecture hardware of OR8 is

begin
    O(0) <= A(0) or B(0);
    O(1) <= A(1) or B(1);
    O(2) <= A(2) or B(2);
    O(3) <= A(3) or B(3);
    O(4) <= A(4) or B(4);
    O(5) <= A(5) or B(5);
    O(6) <= A(6) or B(6);
    O(7) <= A(7) or B(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- X O R
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity XOR8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end XOR8;

architecture hardware of XOR8 is

begin
    O(0) <= A(0) xor B(0);
    O(1) <= A(1) xor B(1);
    O(2) <= A(2) xor B(2);
    O(3) <= A(3) xor B(3);
    O(4) <= A(4) xor B(4);
    O(5) <= A(5) xor B(5);
    O(6) <= A(6) xor B(6);
    O(7) <= A(7) xor B(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- N O T
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity NOT8 is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end NOT8;

architecture hardware of NOT8 is

begin
    O(0) <= not A(0);
    O(1) <= not A(1);
    O(2) <= not A(2);
    O(3) <= not A(3);
    O(4) <= not A(4);
    O(5) <= not A(5);
    O(6) <= not A(6);
    O(7) <= not A(7);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L E X A D O R    2 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUX21 is
    port(A, B, S: in bit;
            O: out bit);
end MUX21;

architecture hardware of MUX21 is

begin
    O <= (B and S) or (A and (not S));
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    E S Q U E R D A 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHL1 is
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end SHL1;

architecture hardware of SHL1 is

component MUX21
    port(A, B, S: in bit;
            O: out bit);
end component;

begin
    COUT: MUX21 port map(CI, A(7), SH, CO);
    O7: MUX21 port map(A(7), A(6), SH, O(7));
    O6: MUX21 port map(A(6), A(5), SH, O(6));
    O5: MUX21 port map(A(5), A(4), SH, O(5));
    O4: MUX21 port map(A(4), A(3), SH, O(4));
    O3: MUX21 port map(A(3), A(2), SH, O(3));
    O2: MUX21 port map(A(2), A(1), SH, O(2));
    O1: MUX21 port map(A(1), A(0), SH, O(1));
    O0: MUX21 port map(A(0), '0', SH, O(0));
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    E S Q U E R D A 2
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHL2 is
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end SHL2;

architecture hardware of SHL2 is

component SHL1
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

signal AUX: bit_vector(7 downto 0);
signal AUX_CI: bit;

begin
    DES1: SHL1 port map(A, SH, CI, AUX, AUX_CI);
    DES2: SHL1 port map(AUX, SH, AUX_CI, O, CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    E S Q U E R D A 4
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHL4 is
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end SHL4;

architecture hardware of SHL4 is

component SHL2
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

signal AUX: bit_vector(7 downto 0);
signal AUX_CI: bit;

begin
    DESl1: SHL2 port map(A, SH, CI, AUX, AUX_CI);
    DESL2: SHL2 port map(AUX, SH, AUX_CI, O, CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    E S Q U E R D A 
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHL is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end SHL;

architecture hardware of SHL is

component SHL1
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

component SHL2
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

component SHL4
    port(A: in bit_vector(7 downto 0);
            SH, CI: in bit;
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

signal AUX1, AUX2: bit_vector(7 downto 0);
signal AUX_CI1, AUX_CI2: bit;

begin
    SH0: SHL1 port map(A, B(0), '0', AUX1, AUX_CI1);
    SH1: SHL2 port map(AUX1, B(1), AUX_CI1, AUX2, AUX_CI2);
    SH2: SHL4 port map(AUX2, B(2), AUX_CI2, O, CO);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    D I R E I T A 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHR1 is
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end SHR1;

architecture hardware of SHR1 is

component MUX21
    port(A, B, S: in bit;
            O: out bit);
end component;

begin
    O7: MUX21 port map(A(7), '0', SH, O(7));
    O6: MUX21 port map(A(6), A(7), SH, O(6));
    O5: MUX21 port map(A(5), A(6), SH, O(5));
    O4: MUX21 port map(A(4), A(5), SH, O(4));
    O3: MUX21 port map(A(3), A(4), SH, O(3));
    O2: MUX21 port map(A(2), A(3), SH, O(2));
    O1: MUX21 port map(A(1), A(2), SH, O(1));
    O0: MUX21 port map(A(0), A(1), SH, O(0));
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    D I R E I T A 2
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHR2 is
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end SHR2;

architecture hardware of SHR2 is

component SHR1
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end component;

signal AUX: bit_vector(7 downto 0);

begin
    DES1: SHR1 port map(A, SH, AUX);
    DES2: SHR1 port map(AUX, SH, O);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    D I R E I T A 4
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHR4 is
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end SHR4;

architecture hardware of SHR4 is

component SHR2
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end component;

signal AUX: bit_vector(7 downto 0);

begin
    DESl1: SHR2 port map(A, SH, AUX);
    DESL2: SHR2 port map(AUX, SH, O);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    --D E S L O C A D O R     A    D I R E I T A 
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity SHR is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end SHR;

architecture hardware of SHR is

component SHR1
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end component;

component SHR2
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end component;

component SHR4
    port(A: in bit_vector(7 downto 0);
            SH: in bit;
            O: out bit_vector(7 downto 0));
end component;

signal AUX1, AUX2: bit_vector(7 downto 0);

begin
    SH0: SHR1 port map(A, B(0), AUX1);
    SH1: SHR2 port map(AUX1, B(1), AUX2);
    SH2: SHR4 port map(AUX2, B(2), O);
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            -- B I T    Z E R O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity ZERO is                          -- Checar se o vetor de saída da ULA é nulo                    
    port(O: in bit_vector(7 downto 0);
            Z: out bit);
end ZERO;

architecture hardware of ZERO is

component NOT8 is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end component;

signal NO: bit_vector(7 downto 0);

begin
    
    NOT_O: NOT8 port map(O, NO);

    Z <= (NO(0) and NO(1) and NO(2) and NO(3) and 
          NO(4) and NO(5) and NO(6) and NO(7));

end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L E X A D O R    8 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUX8x1 is
    port (A: in bit_vector(7 downto 0);
            S: in bit_vector(2 downto 0);
            E: in bit;
            O: out bit);
end MUX8x1;

architecture hardware of MUX8x1 is

begin
    O <= (A(0) and (not S(2)) and (not S(1)) and (not S(0)) and (not E))
        or (A(1) and (not S(2)) and (not S(1)) and       S(0) and (not E))
        or (A(2) and (not S(2)) and       S(1) and (not S(0)) and (not E))
        or (A(3) and (not S(2)) and       S(1) and       S(0) and (not E))
        or (A(4) and       S(2) and (not S(1)) and (not S(0)) and (not E))
        or (A(5) and       S(2) and (not S(1)) and       S(0) and (not E))
        or (A(6) and       S(2) and       S(1) and (not S(0)) and (not E))
        or (A(7) and       S(2) and       S(1) and       S(0) and (not E));    
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- M U L T I P L E X A D O R    16 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUX16x1 is
    port (A: in bit_vector(15 downto 0);
            S: in bit_vector(3 downto 0);
            O: out bit);
end MUX16x1;

architecture hardware of MUX16x1 is

component MUX8x1
    port(A: in bit_vector(7 downto 0);
            S: in bit_vector(2 downto 0);
            E: in bit;
            O: out bit);
end component;

signal Z1, Z2, E2: bit;
signal AUX1, AUX2: bit_vector(7 downto 0);
signal SEL: bit_vector(2 downto 0);

begin
    AUX1 <= A(15 downto 8);
    AUX2 <= A(7 downto 0);
    SEL <= S(2 downto 0);
    E2 <= not S(3);

    MUX1: MUX8x1 port map(AUX1, SEL, E2, Z1);
    MUX2: MUX8x1 port map(AUX2, SEL, S(3), Z2);

    O <= Z1 or Z2;

end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            -- COMPONENTE AUXILIAR
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity AUXILIAR is
    port(O_ADD, O_SUB, O_INC, O_DEC, O_MUL, O_AND8, O_OR8, O_XOR8, O_NOT8, O_SHL, O_SHR: in bit;
            E: out bit_vector(15 downto 0));
end AUXILIAR;
 
architecture hardware of AUXILIAR is
begin
    E(0) <= O_ADD;
    E(1) <= O_SUB;
    E(2) <= O_INC;
    E(3) <= O_DEC;
    E(4) <= O_MUL;
    E(5) <= O_AND8;
    E(6) <= O_OR8;
    E(7) <= O_XOR8;
    E(8) <= O_NOT8;
    E(9) <= O_SHL;
    E(10) <= O_SHR;
    E(15 downto 11) <= "00000";
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- U L A
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity ULA is
    port(A, B: in bit_vector(7 downto 0);
            S: in bit_vector(3 downto 0);
            O: out bit_vector(7 downto 0);
            C, Z: out bit);
end ULA;

architecture hardware of ULA is
-- Somador
component ADD8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

-- Subtrator
component SUB is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

-- Incrementa 1
component INC is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

-- Decrementa 1
component DEC is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

-- Multiplicador
component MUL is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

-- AND8
component AND8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end component;

-- OR8
component OR8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end component;

-- XOR8
component XOR8 is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end component;

-- NOT8
component NOT8 is
    port(A: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end component;

-- SHL
component SHL is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0);
            CO: out bit);
end component;

-- SHR
component SHR is
    port(A, B: in bit_vector(7 downto 0);
            O: out bit_vector(7 downto 0));
end component;

component AUXILIAR is
    port(O_ADD, O_SUB, O_INC, O_DEC, O_MUL, O_AND8, O_OR8, O_XOR8, O_NOT8, O_SHL, O_SHR: in bit;
            E: out bit_vector(15 downto 0));
end component;

component MUX16x1 is
    port (A: in bit_vector(15 downto 0);
            S: in bit_vector(3 downto 0);
            O: out bit);
end component;

component ZERO is                  
    port(O: in bit_vector(7 downto 0);
            Z: out bit);
end component;

    signal O_ADD, O_SUB, O_INC, O_DEC, O_MUL, O_AND8, O_OR8, O_XOR8, O_NOT8, O_SHL, O_SHR, O_AUX: bit_vector(7 downto 0); -- Resultado de cada operação
    signal E0, E1, E2, E3, E4, E5, E6, E7, AUX_CO: bit_vector(15 downto 0); -- Vetores que representararão cada uma das possíveis entradas para
                                                                              -- cada saída O(i) e que entrarão no MUX
begin
    SOMA: ADD8 port map(A, B, O_ADD, AUX_CO(0));
    SUBTRACAO: SUB port map(A, B, O_SUB, AUX_CO(1));
    INCREMENTADOR: INC port map(A, O_INC, AUX_CO(2));
    DECREMENTADOR: DEC port map(A, O_DEC, AUX_CO(3));
    MULTIPLICADOR: MUL port map(A, B, O_MUL, AUX_CO(4));
    PORTAAND: AND8 port map(A, B, O_AND8);
    PORTAOR: OR8 port map(A, B, O_OR8);
    PORTAXOR: XOR8 port map(A, B, O_XOR8);
    PORTANOT: NOT8 port map(A, O_NOT8);
    DESLOCADORESQ: SHL port map(A, B, O_SHL, AUX_CO(9));
    DESLOCADORDIR: SHR port map(A, B, O_SHR);

    AUX_CO(8 downto 5) <= "0000";
    AUX_CO(15 downto 10) <= "000000";

    AUX0: AUXILIAR port map(O_ADD(0), O_SUB(0), O_INC(0), O_DEC(0), O_MUL(0),
                            O_AND8(0), O_OR8(0), O_XOR8(0), O_NOT8(0), O_SHL(0), O_SHR(0), E0);

    AUX1: AUXILIAR port map(O_ADD(1), O_SUB(1), O_INC(1), O_DEC(1), O_MUL(1),
                            O_AND8(1), O_OR8(1), O_XOR8(1), O_NOT8(1), O_SHL(1), O_SHR(1), E1);

    AUX2: AUXILIAR port map(O_ADD(2), O_SUB(2), O_INC(2), O_DEC(2), O_MUL(2),
                            O_AND8(2), O_OR8(2), O_XOR8(2), O_NOT8(2), O_SHL(2), O_SHR(2), E2);

    AUX3: AUXILIAR port map(O_ADD(3), O_SUB(3), O_INC(3), O_DEC(3), O_MUL(3),
                            O_AND8(3), O_OR8(3), O_XOR8(3), O_NOT8(3), O_SHL(3), O_SHR(3), E3);

    AUX4: AUXILIAR port map(O_ADD(4), O_SUB(4), O_INC(4), O_DEC(4), O_MUL(4),
                            O_AND8(4), O_OR8(4), O_XOR8(4), O_NOT8(4), O_SHL(4), O_SHR(4), E4);

    AUX5: AUXILIAR port map(O_ADD(5), O_SUB(5), O_INC(5), O_DEC(5), O_MUL(5),
                            O_AND8(5), O_OR8(5), O_XOR8(5), O_NOT8(5), O_SHL(5), O_SHR(5), E5);

    AUX6: AUXILIAR port map(O_ADD(6), O_SUB(6), O_INC(6), O_DEC(6), O_MUL(6),
                            O_AND8(6), O_OR8(6), O_XOR8(6), O_NOT8(6), O_SHL(6), O_SHR(6), E6);

    AUX7: AUXILIAR port map(O_ADD(7), O_SUB(7), O_INC(7), O_DEC(7), O_MUL(7),
                            O_AND8(7), O_OR8(7), O_XOR8(7), O_NOT8(7), O_SHL(7), O_SHR(7), E7);

    SAIDA0: MUX16x1 port map(E0, S, O_AUX(0));
    SAIDA1: MUX16x1 port map(E1, S, O_AUX(1));
    SAIDA2: MUX16x1 port map(E2, S, O_AUX(2));
    SAIDA3: MUX16x1 port map(E3, S, O_AUX(3));
    SAIDA4: MUX16x1 port map(E4, S, O_AUX(4));
    SAIDA5: MUX16x1 port map(E5, S, O_AUX(5));
    SAIDA6: MUX16x1 port map(E6, S, O_AUX(6));
    SAIDA7: MUX16x1 port map(E7, S, O_AUX(7));
    
    CARRYOUT: MUX16x1 port map(AUX_CO, S, C);
    CARRYZERO: ZERO port map(O_AUX, Z);

    O(7 downto 0) <= O_AUX(7 downto 0);    
end hardware;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- D I S P L A Y        DE      7       S E G M E N T O S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--

entity Display7Seg is
    port (SW: in bit_vector (3 downto 0);	-- Vetor de entradas, com 4 posicoes, que representa um numero, em binario, a ser convertido
    HEX: out bit_vector (6 downto 0));	-- Vetor de saidas, com 7 posicoes, que representa os 7 segmentos do display que serão acesos 
                                        
end Display7Seg;

architecture display of Display7Seg is
    signal A, B, C, D, NA, NB, NC, ND: bit;
begin
    A <= SW(3);
    B <= SW(2);
    C <= SW(1);
    D <= SW(0);

    NA <= not A;
    NB <= not B;
    NC <= not C;
    ND <= not D;
    
    -- HEX[0] = C + A + B'D' + BD
    HEX(0) <= C or A or (NB and ND) or (B and D);
    
    -- HEX[1] = B' + C'D' + CD
    HEX(1) <= NB or (NC and ND) or (C and D);
    
    -- HEX[2] = C' + D + B
    HEX(2) <= NC or D or B;

    -- HEX[3] = B'D' + B'C + CD' + BC'D
    HEX(3) <= (NB and ND) or (NB and C) or (C and ND) or (B and NC and D);

    -- HEX[4] = B'D' + CD'
    HEX(4) <= (NB and ND) or (C and ND);

    -- HEX[5] = A + C'D' + BC' + BD'
    HEX(5) <= A or (NC and ND) or (B and NC) or (B and ND);

    -- HEX[6] = A + B'C + CD' + BC'
    HEX(6) <= A or (NB and C) or (C and ND) or (B and NC);

end display;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- B L O C O S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--

entity Bloco is
    port (A: in bit_vector (3 downto 0);
            S: out bit_vector(3 downto 0));
end Bloco;

architecture display of Bloco is
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

end display;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
-- B I N A R Y        C O D E D        D E C I M A L        ( B C D )
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity BIN_BCD is
    port (SW: in bit_vector (7 downto 0);
            bcd: out bit_vector (11 downto 0));
end BIN_BCD;

architecture display of BIN_BCD is

component Display7Seg
    port (SW: in bit_vector (3 downto 0);
            HEX: out bit_vector (6 downto 0));
end component;

component Bloco is
    port (A: in bit_vector (3 downto 0);
            S: out bit_vector(3 downto 0));
end component;

signal B1_A, B1_S, B2_A, B2_S, B3_A, B3_S, B4_A, B4_S,
    B5_A, B5_S, B6_A, B6_S, B7_A, B7_S: bit_vector (3 downto 0);

signal CEN, DEZ, UNI: bit_vector (3 downto 0);

begin
    B1_A(3) <= '0';
    B1_A(2) <= SW(7);
    B1_A(1) <= SW(6);
    B1_A(0) <= SW(5);

    B1: Bloco port map(B1_A, B1_S);

    B2_A(3) <= B1_S(2);
    B2_A(2) <= B1_S(1);
    B2_A(1) <= B1_S(0);
    B2_A(0) <= SW(4);

    B2: Bloco port map(B2_A, B2_S);

    B3_A(3) <= B2_S(2);
    B3_A(2) <= B2_S(1);
    B3_A(1) <= B2_S(0);
    B3_A(0) <= SW(3);

    B3: Bloco port map(B3_A, B3_S);

    B4_A(3) <= '0';
    B4_A(2) <= B1_S(3);
    B4_A(1) <= B2_S(3);
    B4_A(0) <= B3_S(3);

    B4: Bloco port map(B4_A, B4_S);

    B5_A(3) <= B3_S(2);
    B5_A(2) <= B3_S(1);
    B5_A(1) <= B3_S(0);
    B5_A(0) <= SW(2);

    B5: Bloco port map(B5_A, B5_S);

    B6_A(3) <= B4_S(2);
    B6_A(2) <= B4_S(1);
    B6_A(1) <= B4_S(0);
    B6_A(0) <= B5_S(3);

    B6: Bloco port map(B6_A, B6_S);

    B7_A(3) <= B5_S(2);
    B7_A(2) <= B5_S(1);
    B7_A(1) <= B5_S(0);
    B7_A(0) <= SW(1);

    B7: Bloco port map(B7_A, B7_S);

    bcd(11) <= '0';
    bcd(10) <= '0';
    bcd(9) <= B4_S(3);
    bcd(8) <= B6_S(3);
    bcd(7) <= B6_S(2);
    bcd(6) <= B6_S(1);
    bcd(5) <= B6_S(0);
    bcd(4) <= B7_S(3);
    bcd(3) <= B7_S(2);
    bcd(2) <= B7_S(1);
    bcd(1) <= B7_S(0);
    bcd(0) <= SW(0);
end display;
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                -- C I R C U I T O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity CIRCUITO is
    port(A, B: in bit_vector(7 downto 0);
            S: in bit_vector(3 downto 0);
            O: out bit_vector(7 downto 0);
            C, Z: out bit;
            HEX2, HEX1, HEX0: out bit_vector(6 downto 0));
end CIRCUITO;

architecture display of CIRCUITO is

component ULA is
    port(A, B: in bit_vector(7 downto 0);
            S: in bit_vector(3 downto 0);
            O: out bit_vector(7 downto 0);
            C, Z: out bit);
end component;

component BIN_BCD
port (SW: in bit_vector (7 downto 0);
            bcd: out bit_vector (11 downto 0));
end component;

component Display7Seg
    port (SW: in bit_vector (3 downto 0);
            HEX: out bit_vector (6 downto 0));
end component;

signal CEN, DEZ, UNI: bit_vector (3 downto 0);
signal AUX_O: bit_vector (7 downto 0);
signal BCD: bit_vector (11 downto 0);

begin
    MakeULA: ULA port map(A, B, S, AUX_O, C, Z);

    O(7 downto 0) <= AUX_O (7 downto 0);

    CONVERSORbinBCD: BIN_BCD port map(AUX_O, BCD);

    -- DISPLAYS DE 7 SEG

    CEN(3) <= BCD(11);
    CEN(2) <= BCD(10);
    CEN(1) <= BCD(9);
    CEN(0) <= BCD(8);

    CENT: Display7Seg port map(CEN, HEX2);

    DEZ(3) <= BCD(7);
    DEZ(2) <= BCD(6);
    DEZ(1) <= BCD(5);
    DEZ(0) <= BCD(4);

    DEZE: Display7Seg port map(DEZ, HEX1);

    UNI(3) <= BCD(3);
    UNI(2) <= BCD(2);
    UNI(1) <= BCD(1);
    UNI(0) <= BCD(0);
    
    UNID: Display7Seg port map(UNI, HEX0);
end display;