--=============--
-- Flip-Flop D	--
--=============--

ENTITY ffd IS
	port (clk ,D,P,C: IN BIT ;
		q: OUT BIT );
END ffd;

ARCHITECTURE ckt OF ffd IS

	SIGNAL qS: BIT;
	
BEGIN

	PROCESS (clk ,P,C)
	BEGIN
		IF P = '0' THEN qS <= '1';
		ELSIF C = '0' THEN qS <= '0';
		ELSIF clk ='1' AND clk ' EVENT THEN
		qS <= D;
		END IF;
	END PROCESS ;
	
	q <= qS;
	
END ckt;


--======================--
-- LÓGICA COMBINACIONAL --
--======================--

ENTITY LOGICA_COMB IS
	PORT( E1,E0,y,u: in bit;
		E1P, E0P, z: out bit);
END LOGICA_COMB;

ARCHITECTURE CKT OF LOGICA_COMB IS

BEGIN

	E1P <= (not E1 and not E0 and not y and not u) or (not E1 and E0 and y and not u) or 
			(E1 and E0 and not y) or (E1 and not E0 and y) or (E1 and u) ;
			
	E0P <= (not E0 and not u) or (E0 and u);
	
	z <= u;
	
END CKT;
	
	
--====================--
-- MÁQUINA DE ESTADOS --
--====================--

ENTITY mealy_machine IS
	PORT(CLK, y, u, CLR: in bit;
		E: out bit_Vector(1 downto 0);
		z: out bit);
END mealy_machine;

ARCHITECTURE CKT OF mealy_machine IS

COMPONENT ffd IS
	PORT (clk, D, P, C: IN BIT ;
		q: OUT BIT );
END COMPONENT;

COMPONENT LOGICA_COMB IS
	PORT( E1,E0,y,u: in bit;
		E1P, E0P, z: out bit);
END COMPONENT;

signal E1, E0, E1P, E0P, clear: bit;

BEGIN
	clear <= not CLR;
	
	FFD1: ffd port map (CLK, E1P, '1', clear, E1);
	FFD2: ffd port map (CLK, E0P, '1', clear, E0);
	
	LC: LOGICA_COMB port map( E1, E0, y, u, E1P, E0P,z);
	
	E(0) <= E0;
	E(1) <= E1;
	
END CKT;

