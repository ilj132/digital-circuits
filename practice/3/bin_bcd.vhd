entity 7seg is 
port( I: in bit_vector (0 to 4);
O: out bit_vector (0 to 7) 
);
end 7seg;

architecture segmentos of 7seg is
	signal A,B,C,D,NA,NB,NC,ND: bit;
	
begin

A<= I(0);
B<= I(1);
C<= I(2);
D<= I(3);
NA<= not A;
NB<= not B;
NC<= not C;
ND<= not D;

O(0) <= ;
O(1) <= ;
O(2) <= ;
O(3) <= ;
O(4) <= ;
O(5) <= ;
O(6) <= ;

end segmentos;


entity bin_bcd is
port(  );
end bin_bcd;
