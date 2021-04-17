--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
        -- F L I P - F L O P    T I P O     D
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--

entity FFD is
    port (D, S, R, clk: in bit; -- set e reset barrados
            Q, NQ: out bit);    
end FFD;
    
architecture hardware of FFD is

signal QS: bit;

begin
    process(CLK, S, R)
    begin
        if S = '0' then QS <= '1';
        elsif R = '0' then QS <= '0';
        elsif clk = '1' and clk'event then QS <= D;
        end if;
    end process;

    Q <= QS;
    NQ <= not(QS);

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
        -- S O M A D O R    D E     4   B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity ADD4 is
    port(A, B: in bit_vector(3 downto 0);
            O: out bit_vector(3 downto 0);
            CO: out bit);
end ADD4;

architecture hardware of ADD4 is

component COMP_ADD
    port(A, B, CI: in bit;
            S, CO: out bit);
end component;

signal VAI_UM: bit_vector(2 downto 0);

begin
    S0: COMP_ADD port map(A(0), B(0), '0', O(0), VAI_UM(0));
    S1: COMP_ADD port map(A(1), B(1), VAI_UM(0), O(1), VAI_UM(1));
    S2: COMP_ADD port map(A(2), B(2), VAI_UM(1), O(2), VAI_UM(2));
    S3: COMP_ADD port map(A(3), B(3), VAI_UM(2), O(3), CO);
end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- C O N T A D O R    D E     4 B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity CONT4 is
    port (ld, clr, clk: in bit; -- clr barrado
            O: out bit_vector(3 downto 0));
end CONT4;

architecture hardware of CONT4 is

component REGISTER4BITS is
    port (I: in bit_vector(3 downto 0);
            ld, clr, clk: in bit; -- clr barrado
            O: out bit_vector(3 downto 0));
end component;

component ADD4 is
    port(A, B: in bit_vector(3 downto 0);
            O: out bit_vector(3 downto 0);
            CO: out bit);
end component;

signal CO: bit;
signal D, Q: bit_vector(3 downto 0);

begin

    SOMADOR: ADD4 port map(Q, ('0', '0', '0', '1'), D, CO);
    REGISTER4: REGISTER4BITS port map(D, ld, clr, clk, Q);

    -- saida
    O <= Q;

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- C O M P A R A D O R    D E     4 B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity COMP4 is
    port (A, B: in bit_vector(3 downto 0);
            AmenorB, AigualB, AmaiorB: out bit);
end COMP4;

architecture hardware of COMP4 is

signal A0eqB0, A1eqB1, A2eqB2, A3eqB3: bit;
Signal A0gtB0, A1gtB1, A2gtB2, A3gtB3: bit;
signal AeqB, AgtB, AltB: bit;

begin
    -- A igual a B
    A0eqB0 <= not(A(0) xor B(0));
    A1eqB1 <= not(A(1) xor B(1));
    A2eqB2 <= not(A(2) xor B(2));
    A3eqB3 <= not(A(3) xor B(3));

    AeqB <= A0eqB0 and A1eqB1 and A2eqB2 and A3eqB3;

    -- A maior que B
    A0gtB0 <= A(0) and not(B(0)) and A3eqB3 and A2eqB2 and A1eqB1;
    A1gtB1 <= A(1) and not(B(1)) and A3eqB3 and A2eqB2;
    A2gtB2 <= A(2) and not(B(2)) and A3eqB3;
    A3gtB3 <= A(3) and not(B(3));

    AgtB <= A0gtB0 or A1gtB1 or A2gtB2 or A3gtB3;

    -- A menor que B
    AltB <= not(AeqB or AgtB);

    -- saidas
    AmenorB <= AltB;
    AigualB <= AeqB;
    AmaiorB <= AgtB;

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                    -- M U X    2 x 1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUX2x1 is
    port(A, B, S: in bit;
            Y: out bit);
end MUX2x1;

architecture hardware of MUX2x1 is

begin

    Y <= (A and (not S)) or (B and S);
end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                    -- D E M U X    1x16
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity DEMUX1x16 is
	port(I, en: in bit;
		S: in bit_vector(3 downto 0);
		O: out bit_vector(15 downto 0));
end DEMUX1x16;

architecture hardware of DEMUX1x16 is

begin

	O(0)  <= en and I and (not S(3) and not S(2) and not S(1) and not S(0));
	O(1)  <= en and I and (not S(3) and not S(2) and not S(1) and     S(0));
	O(2)  <= en and I and (not S(3) and not S(2) and     S(1) and not S(0));
	O(3)  <= en and I and (not S(3) and not S(2) and     S(1) and     S(0));
	O(4)  <= en and I and (not S(3) and     S(2) and not S(1) and not S(0));
	O(5)  <= en and I and (not S(3) and     S(2) and not S(1) and     S(0));
	O(6)  <= en and I and (not S(3) and     S(2) and     S(1) and not S(0));
	O(7)  <= en and I and (not S(3) and     S(2) and     S(1) and     S(0));
	O(8)  <= en and I and (    S(3) and not S(2) and not S(1) and not S(0));
	O(9)  <= en and I and (    S(3) and not S(2) and not S(1) and     S(0));
	O(10) <= en and I and (    S(3) and not S(2) and     S(1) and not S(0));
	O(11) <= en and I and (    S(3) and not S(2) and     S(1) and     S(0));
	O(12) <= en and I and (    S(3) and     S(2) and not S(1) and not S(0));
	O(13) <= en and I and (    S(3) and     S(2) and not S(1) and     S(0));
	O(14) <= en and I and (    S(3) and     S(2) and     S(1) and not S(0));
	O(15) <= en and I and (    S(3) and     S(2) and     S(1) and     S(0));
	
end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                    -- M U X    16x1
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUX16x1 is
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT;
		S: in bit_vector(3 downto 0);
		O: out bit);
end MUX16x1;

architecture hardware of MUX16x1 is

begin

	O <= (I0  and not S(3) and not S(2) and not S(1) and not S(0)) 
      or (I1  and not S(3) and not S(2) and not S(1) and     S(0)) 
      or (I2  and not S(3) and not S(2) and     S(1) and not S(0))
      or (I3  and not S(3) and not S(2) and     S(1) and     S(0)) 
      or (I4  and not S(3) and     S(2) and not S(1) and not S(0)) 
      or (I5  and not S(3) and     S(2) and not S(1) and     S(0))
      or (I6  and not S(3) and     S(2) and     S(1) and not S(0)) 
      or (I7  and not S(3) and     S(2) and     S(1) and     S(0)) 
      or (I8  and     S(3) and not S(2) and not S(1) and not S(0))
      or (I9  and     S(3) and not S(2) and not S(1) and     S(0)) 
      or (I10 and     S(3) and not S(2) and     S(1) and not S(0)) 
      or (I11 and     S(3) and not S(2) and     S(1) and     S(0))
      or (I12 and     S(3) and     S(2) and not S(1) and not S(0))
      or (I13 and     S(3) and     S(2) and not S(1) and     S(0))
      or (I14 and     S(3) and     S(2) and     S(1) and not S(0))
      or (I15 and     S(3) and     S(2) and     S(1) and     S(0));

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                    -- M U X    16x1_13
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity MUX16x1_13 is
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT_VECTOR(12 DOWNTO 0);
		S: in bit_vector(3 downto 0);
		O: out BIT_VECTOR(12 DOWNTO 0));
end MUX16x1_13;

architecture hardware of MUX16x1_13 is

component MUX16x1 is
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT;
		S: in bit_vector(3 downto 0);
		O: out bit);
end component;

begin

	BIT0:  MUX16x1 port map (I0(0),  I1(0),  I2(0),  I3(0),  I4(0),  I5(0),  I6(0),  I7(0),  I8(0),  I9(0),  I10(0),  I11(0),  I12(0),  I13(0),  I14(0),  I15(0),  S, O(0));
	BIT1:  MUX16x1 port map (I0(1),  I1(1),  I2(1),  I3(1),  I4(1),  I5(1),  I6(1),  I7(1),  I8(1),  I9(1),  I10(1),  I11(1),  I12(1),  I13(1),  I14(1),  I15(1),  S, O(1));
	BIT2:  MUX16x1 port map (I0(2),  I1(2),  I2(2),  I3(2),  I4(2),  I5(2),  I6(2),  I7(2),  I8(2),  I9(2),  I10(2),  I11(2),  I12(2),  I13(2),  I14(2),  I15(2),  S, O(2));
	BIT3:  MUX16x1 port map (I0(3),  I1(3),  I2(3),  I3(3),  I4(3),  I5(3),  I6(3),  I7(3),  I8(3),  I9(3),  I10(3),  I11(3),  I12(3),  I13(3),  I14(3),  I15(3),  S, O(3));
	BIT4:  MUX16x1 port map (I0(4),  I1(4),  I2(4),  I3(4),  I4(4),  I5(4),  I6(4),  I7(4),  I8(4),  I9(4),  I10(4),  I11(4),  I12(4),  I13(4),  I14(4),  I15(4),  S, O(4));
	BIT5:  MUX16x1 port map (I0(5),  I1(5),  I2(5),  I3(5),  I4(5),  I5(5),  I6(5),  I7(5),  I8(5),  I9(5),  I10(5),  I11(5),  I12(5),  I13(5),  I14(5),  I15(5),  S, O(5));
	BIT6:  MUX16x1 port map (I0(6),  I1(6),  I2(6),  I3(6),  I4(6),  I5(6),  I6(6),  I7(6),  I8(6),  I9(6),  I10(6),  I11(6),  I12(6),  I13(6),  I14(6),  I15(6),  S, O(6));
	BIT7:  MUX16x1 port map (I0(7),  I1(7),  I2(7),  I3(7),  I4(7),  I5(7),  I6(7),  I7(7),  I8(7),  I9(7),  I10(7),  I11(7),  I12(7),  I13(7),  I14(7),  I15(7),  S, O(7));
	BIT8:  MUX16x1 port map (I0(8),  I1(8),  I2(8),  I3(8),  I4(8),  I5(8),  I6(8),  I7(8),  I8(8),  I9(8),  I10(8),  I11(8),  I12(8),  I13(8),  I14(8),  I15(8),  S, O(8));
	BIT9:  MUX16x1 port map (I0(9),  I1(9),  I2(9),  I3(9),  I4(9),  I5(9),  I6(9),  I7(9),  I8(9),  I9(9),  I10(9),  I11(9),  I12(9),  I13(9),  I14(9),  I15(9),  S, O(9));
	BIT10: MUX16x1 port map (I0(10), I1(10), I2(10), I3(10), I4(10), I5(10), I6(10), I7(10), I8(10), I9(10), I10(10), I11(10), I12(10), I13(10), I14(10), I15(10), S, O(10));
	BIT11: MUX16x1 port map (I0(11), I1(11), I2(11), I3(11), I4(11), I5(11), I6(11), I7(11), I8(11), I9(11), I10(11), I11(11), I12(11), I13(11), I14(11), I15(11), S, O(11));
	BIT12: MUX16x1 port map (I0(12), I1(12), I2(12), I3(12), I4(12), I5(12), I6(12), I7(12), I8(12), I9(12), I10(12), I11(12), I12(12), I13(12), I14(12), I15(12), S, O(12));

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- R E G I S T R A D O R    D E     4 B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity REGISTER4BITS is
    port (I: in bit_vector(3 downto 0);
            ld, clr, clk: in bit; -- clr barrado
            O: out bit_vector(3 downto 0));
end REGISTER4BITS;

architecture hardware of REGISTER4BITS is

component FFD is
    port (D, S, R, clk: in bit; -- set e reset barrados
            Q, NQ: out bit);    
end component;

component MUX2x1 is
    port(A, B, S: in bit;
            Y: out bit);
end component;

signal D, Q, NQ: bit_vector(3 downto 0);

begin
    -- condicao de carregamento
    MUX1: MUX2x1 port map(Q(0), I(0), ld, D(0));
    MUX2: MUX2x1 port map(Q(1), I(1), ld, D(1));
    MUX3: MUX2x1 port map(Q(2), I(2), ld, D(2));
    MUX4: MUX2x1 port map(Q(3), I(3), ld, D(3));

    -- flip-flops:
    FF0: FFD port map(D(0), '1', clr, clk, Q(0), NQ(0));
    FF1: FFD port map(D(1), '1', clr, clk, Q(1), NQ(1));
    FF2: FFD port map(D(2), '1', clr, clk, Q(2), NQ(2));
    FF3: FFD port map(D(3), '1', clr, clk, Q(3), NQ(3));

    -- saída
    O <= Q;

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- R E G I S T R A D O R    D E     13 B I T S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity REGISTER13BITS is
    port( I: in bit_vector(12 downto 0);
            ld, clr, clk: in bit; -- clr barrado
            O: out bit_vector(12 downto 0));
end REGISTER13BITS;

architecture hardware of REGISTER13BITs is

component FFD is
    port (D, S, R, clk: in bit; -- set e reset barrados
            Q, NQ: out bit);    
end component;

component MUX2x1 is
    port(A, B, S: in bit;
            Y: out bit);
end component;

signal D, Q, NQ: bit_vector(12 downto 0);

begin
    -- condicao de carregamento
    MUX0:  MUX2x1 port map(Q(0),  I(0),  ld, D(0));
    MUX1:  MUX2x1 port map(Q(1),  I(1),  ld, D(1));
    MUX2:  MUX2x1 port map(Q(2),  I(2),  ld, D(2));
    MUX3:  MUX2x1 port map(Q(3),  I(3),  ld, D(3));
    MUX4:  MUX2x1 port map(Q(4),  I(4),  ld, D(4));
    MUX5:  MUX2x1 port map(Q(5),  I(5),  ld, D(5));
    MUX6:  MUX2x1 port map(Q(6),  I(6),  ld, D(6));
    MUX7:  MUX2x1 port map(Q(7),  I(7),  ld, D(7));
    MUX8:  MUX2x1 port map(Q(8),  I(8),  ld, D(8));
    MUX9:  MUX2x1 port map(Q(9),  I(9),  ld, D(9));
    MUX10: MUX2x1 port map(Q(10), I(10), ld, D(10));
    MUX11: MUX2x1 port map(Q(11), I(11), ld, D(11));
    MUX12: MUX2x1 port map(Q(12), I(12), ld, D(12));

    -- flip-flops:
    FF0:  FFD port map(D(0),  '1', clr, clk, Q(0),  NQ(0));
    FF1:  FFD port map(D(1),  '1', clr, clk, Q(1),  NQ(1));
    FF2:  FFD port map(D(2),  '1', clr, clk, Q(2),  NQ(2));
    FF3:  FFD port map(D(3),  '1', clr, clk, Q(3),  NQ(3));
    FF4:  FFD port map(D(4),  '1', clr, clk, Q(4),  NQ(4));
    FF5:  FFD port map(D(5),  '1', clr, clk, Q(5),  NQ(5));
    FF6:  FFD port map(D(6),  '1', clr, clk, Q(6),  NQ(6));
    FF7:  FFD port map(D(7),  '1', clr, clk, Q(7),  NQ(7));
    FF8:  FFD port map(D(8),  '1', clr, clk, Q(8),  NQ(8));
    FF9:  FFD port map(D(9),  '1', clr, clk, Q(9),  NQ(9));
    FF10: FFD port map(D(10), '1', clr, clk, Q(10), NQ(10));
    FF11: FFD port map(D(11), '1', clr, clk, Q(11), NQ(11));
    FF12: FFD port map(D(12), '1', clr, clk, Q(12), NQ(12));

    -- saída
    O <= Q;

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- B A N C O    D E     R E G I S T R A D O R E S
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity BANCO_REG is
    port(w_data: in bit_vector(12 downto 0); -- dado a ser escrito
            wr_en: in bit; -- habilitador de leitura
            waddr, raddr: in bit_vector(3 downto 0); -- endereços de memoria de escrita e leitura, respectivamente
            clr, clk: in bit; -- clear barrado
            r_data: out bit_vector(12 downto 0)); -- dado a ser lido
end BANCO_REG;

architecture hardware of BANCO_REG is

component REGISTER13BITS is
    port( I: in bit_vector(12 downto 0);
        ld, clr, clk: in bit; -- clr barrado
        O: out bit_vector(12 downto 0));
end component;

component MUX16x1_13 is
	port(I0, I1, I2, I3, I4, I5, I6, I7, I8, I9, I10, I11, I12, I13, I14, I15: in BIT_VECTOR(12 DOWNTO 0);
		S: in bit_vector(3 downto 0);
		O: out BIT_VECTOR(12 DOWNTO 0));
end component;

component DEMUX1x16 is
	port(I, en: in bit;
		S: in bit_vector(3 downto 0);
		O: out bit_vector(15 downto 0));
end component;

signal ld: bit_vector (15 downto 0);
signal r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15: bit_vector(12 downto 0);

begin
    -- demux para selecionar qual registrador deve ser carregado (endereco waddr)
    DEFINE_LOAD: DEMUX1x16 port map('1', wr_en, waddr, ld);

    -- registradores, so ira carregar no registrador correspondente a saida do demux anterior
    DEFINE_REG0:  REGISTER13BITS port map(w_data, ld(0),  clr, clk, r0);
    DEFINE_REG1:  REGISTER13BITS port map(w_data, ld(1),  clr, clk, r1);
    DEFINE_REG2:  REGISTER13BITS port map(w_data, ld(2),  clr, clk, r2);
    DEFINE_REG3:  REGISTER13BITS port map(w_data, ld(3),  clr, clk, r3);
    DEFINE_REG4:  REGISTER13BITS port map(w_data, ld(4),  clr, clk, r4);
    DEFINE_REG5:  REGISTER13BITS port map(w_data, ld(5),  clr, clk, r5);
    DEFINE_REG6:  REGISTER13BITS port map(w_data, ld(6),  clr, clk, r6);
    DEFINE_REG7:  REGISTER13BITS port map(w_data, ld(7),  clr, clk, r7);
    DEFINE_REG8:  REGISTER13BITS port map(w_data, ld(8),  clr, clk, r8);
    DEFINE_REG9:  REGISTER13BITS port map(w_data, ld(9),  clr, clk, r9);
    DEFINE_REG10: REGISTER13BITS port map(w_data, ld(10), clr, clk, r10);
    DEFINE_REG11: REGISTER13BITS port map(w_data, ld(11), clr, clk, r11);
    DEFINE_REG12: REGISTER13BITS port map(w_data, ld(12), clr, clk, r12);
    DEFINE_REG13: REGISTER13BITS port map(w_data, ld(13), clr, clk, r13);
    DEFINE_REG14: REGISTER13BITS port map(w_data, ld(14), clr, clk, r14);
    DEFINE_REG15: REGISTER13BITS port map(w_data, ld(15), clr, clk, r15);

    --seleciona qual registrador deve ser lido (endereco raddr)
    DEFINE_READ: MUX16x1_13 port map(r0, r1, r2, r3, r4, r5, r6, r7, r8, r9, r10, r11, r12, r13, r14, r15, raddr, r_data);

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
            -- B O T A O    S I N C R O N O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity BS is
    port(t, clk: in bit;
        press: out bit);
end BS;

architecture hardware of BS is

component FFD is
    port (D, S, R, clk: in bit; -- set e reset barrados
            Q, NQ: out bit);    
end component;

signal D, Q, NQ: bit_vector (1 downto 0);

begin
    -- logica combinacional
    D(1) <= (NQ(1) and Q(0)) or (Q(1) and NQ(0) and t);
    D(0) <= NQ(1) and NQ(0) and t;

    -- estados
    FF0: FFD port map(D(0), '1', '1', clk, Q(0), NQ(0));
    FF1: FFD port map(D(1), '1', '1', clk, Q(1), NQ(1));

    --saida
    press <= NQ(1) and Q(0);

end hardware;


--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- B L O C O    D E     C O N T R O L E
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity BLOCO_DE_CONTROLE is
    port (wr, rd, clr_fifo, empty, full, clk: in bit;
            wr_en, rd_en, clr, fu, em: out bit);
end BLOCO_DE_CONTROLE;

architecture hardware of BLOCO_DE_CONTROLE is

component FFD is
port (D, S, R, clk: in bit; -- set e reset barrados
        Q, NQ: out bit);    
end component;

component BS is
    port(t, clk: in bit;
        press: out bit);
end component;

signal Nem, Nfu: bit; -- barrados
signal wr_b, rd_b, clr_b, Nwr_b, Nrd_b, Nclr_b: bit; -- botoes sincronos
signal Dff, Q, NQ: bit_vector(1 downto 0); -- estados

begin
    -- auxiliares
    Nem <= not empty;
    Nfu <= not full;
    Nwr_b <= not wr_b;
    Nrd_b <= not rd_b;
    --Nclr_b <= not clr_b;

    -- botao sincrono
    BOTAO_WR:  BS port map(wr, clk, wr_b);
    BOTAO_RD:  BS port map(rd, clk, rd_b);
    --BOTAO_CLR: BS port map(clr_fifo, clk, clr_b);

    -- estados
    Dff(0) <= (NQ(1) and NQ(0) and clr_fifo) or (NQ(1) and NQ(0) and Nrd_b and wr_b and Nfu);
    Dff(1) <= (NQ(1) and NQ(0) and clr_fifo) or (NQ(1) and NQ(0) and rd_b and Nem);

    FF0: FFD port map(Dff(0), '1', '1', clk, Q(0), NQ(0));
    FF1: FFD port map(Dff(1), '1', '1', clk, Q(1), NQ(1));

    -- saidas
    clr <= not(Q(1) and Q(0));
    rd_en <= Q(1) and NQ(0);
    wr_en <= NQ(1) and Q(0);
    fu <= full;
    em <= empty;

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
    -- B L O C O    O P E R A C I O N A L
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity BLOCO_OPERACIONAL is
    port (w_data: in bit_vector(12 downto 0);
            wr_en, rd_en, clr, clk: in bit;
            r_data: out bit_vector(12 downto 0);
				WRaddr, RDaddr: out bit_vector(3 downto 0);
            empty, full: out bit);
end BLOCO_OPERACIONAL;
    
architecture hardware of BLOCO_OPERACIONAL is

component CONT4 is
port (ld, clr, clk: in bit; -- clr barrado
        O: out bit_vector(3 downto 0));
end component;

component COMP4 is
port (A, B: in bit_vector(3 downto 0);
        AmenorB, AigualB, AmaiorB: out bit);
end component;

component FFD is
port (D, S, R, clk: in bit; -- set e reset barrados
        Q, NQ: out bit);    
end component;

component MUX2x1 is
port(A, B, S: in bit;
        Y: out bit);
end component;

component BANCO_REG is
    port(w_data: in bit_vector(12 downto 0); -- dado a ser escrito
            wr_en: in bit; -- habilitador de leitura
            waddr, raddr: in bit_vector(3 downto 0); -- endereços de memoria de escrita e leitura, respectivamente
            clr, clk: in bit; -- clear barrado
            r_data: out bit_vector(12 downto 0)); -- dado a ser lido            
end component;

signal waddr_lt_raddr, waddr_eq_raddr, waddr_gt_raddr: bit; -- variaveis do comparador
signal I_vc, ld_vc, D_vc, Q_vc, NQ_vc: bit; -- variaveis pras saidas vazio e cheio
signal waddr, raddr: bit_vector(3 downto 0); -- endereços dos comparadores de escrita e leitura

begin
    -- contadores
    CONTADOR_ESCRITA: CONT4 port map(wr_en, clr, clk, waddr);
    CONTADOR_LEITURA: CONT4 port map(rd_en, clr, clk, raddr);

    -- banco de registradores
    BANCO_DE_REG: BANCO_REG port map(w_data, wr_en, waddr, raddr, clr, clk, r_data);

    -- comparador
    COMPARADOR: COMP4 port map(waddr, raddr, waddr_lt_raddr, waddr_eq_raddr, waddr_gt_raddr);

    -- vazio ou cheio
    ld_vc <= rd_en or wr_en;

    LOAD_VC: MUX2X1 port map(Q_vc, I_vc, ld_vc, D_vc);
    INP_VC: MUX2x1 port map('1', '0', rd_en, I_vc);
    FF0: FFD port map(D_vc, '1', clr, clk, Q_vc, NQ_vc);

	 WRaddr<= waddr;
	 RDaddr <= raddr;
    empty <= NQ_vc and waddr_eq_raddr;
    full <= Q_vc and waddr_eq_raddr;

end hardware;

--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
                        -- F I F O
--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--
entity FIFO is
    port (w_data: in bit_vector(12 downto 0);
            wr, rd, clr_fifo, clk: in bit;
            r_data: out bit_vector(12 downto 0);
				waddr, raddr: out bit_vector(3 downto 0);
            fu, em: out bit);
end FIFO;

architecture hardware of FIFO is

component BLOCO_DE_CONTROLE is
    port (wr, rd, clr_fifo, empty, full, clk: in bit;
            wr_en, rd_en, clr, fu, em: out bit);
end component;

component BLOCO_OPERACIONAL is
    port (w_data: in bit_vector(12 downto 0);
            wr_en, rd_en, clr, clk: in bit;
            r_data: out bit_vector(12 downto 0);
				WRaddr, RDaddr: out bit_vector(3 downto 0);
            empty, full: out bit);
end component;

signal wr_en, rd_en, clr, empty, full: bit;

begin

    BlocoDeControle: BLOCO_DE_CONTROLE port map(wr, rd, clr_fifo, empty, full, clk, wr_en, rd_en, clr, fu, em);
    BlocoOperacional: BLOCO_OPERACIONAL port map(w_data, wr_en, rd_en, clr, clk, r_data, waddr, raddr,empty, full);

end hardware ; -- hardware