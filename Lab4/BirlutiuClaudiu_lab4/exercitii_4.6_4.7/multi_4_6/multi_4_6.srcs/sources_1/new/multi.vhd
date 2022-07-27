----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multi is
     generic (  nbBits : INTEGER:=8
     );
    Port ( x : in STD_LOGIC_VECTOR (nbBits-1 downto 0);
           y : in STD_LOGIC_VECTOR (nbBits-1 downto 0);
           p : out STD_LOGIC_VECTOR (2*nbBits-1 downto 0));
end multi;

architecture Behavioral of multi is
    --matrix
    type matrix_pp is array(0 to nbBits-1) of STD_LOGIC_VECTOR(0 to nbBits-1);
    type matrix_s is array(0 to nbBits-1) of STD_LOGIC_VECTOR(0 to nbBits);
    type matrix_t is array(0 to nbBits-2) of STD_LOGIC_VECTOR(0 to nbBits);
    signal PP     : matrix_pp:=(others=>(others=>'0'));
    signal S      : matrix_s:=(others=>(others=>'0'));
    signal S_aux  : matrix_s:=(others=>(others=>'0'));    --am fost nevoit sa iau niste semnale auxiliare pentru vectorul de suma si transport deoarece imi apareau conflicte pe semnale in momentul maparilor 
    signal T      : matrix_t:=(others=>(others=>'0'));
    signal T_aux  : matrix_t:=(others=>(others=>'0'));
    
begin
    --calculcarea produselor partiale
    partial_products: 
        for i in 0 to nbBits-1 generate
            intern:  for j in 0 to nbBits-1 generate
                pp(i)(j) <= x(j) and y(i); 
            end generate intern;
    end generate partial_products;
    
    --determinarea vectorului suma
    determine_sum: 
         for i in 0 to nbBits-1 generate
            intern:  for j in 0 to nbBits generate
                s(i)(j) <=  '0' when (i=0 and j=8) 
                             else t_aux(i-1)(j) when j=8
                             else pp(i)(j) when i=0 and j/=8
                             else s_aux(i)(j);
            end generate intern;
    end generate determine_sum;
    
    --maparea sumatoarelor elementare 
    SE: 
       for i in 0 to nbBits-2 generate
            intern:  for j in 0 to nbBits-1 generate
                t(i)(j) <= '0' when j=0
                        else t_aux(i)(j);
                SUMXY: entity Work.sumator PORT MAP( 
                    x => pp(i+1)(j),
                    y => s(i)(j+1),
                    tin => t(i)(j),
                    s => s_aux(i+1)(j),    --apareau conflicte pe semnalul s daca foloseam s(i+1)(j)
                    t => T_aux(i)(j+1)
                 );
            end generate intern;
    end generate SE;
    
    --LOGICA DE DETERMINARE A IESIRII P
    determine_p: 
        for i in 0 to nbBits-2 generate 
            p(i) <= s(i)(0);
     end generate determine_p;
     determine_p2: 
        for i in 0 to nbBits generate 
            p(i+7) <= s(7)(i);
     end generate determine_p2;
    
end Behavioral;
