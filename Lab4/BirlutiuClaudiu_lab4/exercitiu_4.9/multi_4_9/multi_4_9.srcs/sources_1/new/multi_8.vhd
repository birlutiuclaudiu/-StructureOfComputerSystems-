----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Inmultitor 8 biti
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
   
    -- declararea matricei pentru sumele partiale 
    type matrix_s is array(0 to nbBits-1) of STD_LOGIC_VECTOR(0 to nbBits);
    signal S      : matrix_s:=(others=>(others=>'0'));
    
    --declarare semnale de intrare pentru celule: matrice de 9 * 7 (+ o linie in plus)
    type matrix_cell is array(0 to nbBits-1) of STD_LOGIC_VECTOR(0 to nbBits-1);
    signal en1: matrix_cell:= (others=>(others=>'0'));
    signal en2: matrix_cell:= (others=>(others=>'0'));
    signal en3: matrix_cell:= (others=>(others=>'0'));
    
    --declararea unei matrici pentru transport
    type matrix_t is array(0 to nbBits-1) of STD_LOGIC_VECTOR(0 to nbBits);
    signal T      : matrix_t:=(others=>(others=>'0'));
    signal T_aux      : matrix_t:=(others=>(others=>'0'));
  
begin
    
    --maparea celulelor 
    CELL: 
       for i in 0 to nbBits-1 generate
            intern:  for j in 0 to nbBits-1 generate
                en1(i)(j) <= x(j); 
                en2(i)(j) <= y(i);
                en3(i)(j) <= '0' when i=0 else 
                            t_aux(i-1)(j+1) when j=7
                            else s(i-1)(j+1);
                           
                t(i)(j) <= '0' when j=0
                        else t_aux(i)(j);
               
                CELX: entity Work.cell_mul PORT MAP( 
                    x => en1(i)(j),
                    y => en2(i)(j),
                    a => en3(i)(j),
                    tin => t(i)(j),
                    s   => s(i)(j),   
                    tout => t_aux(i)(j+1)
                 );
            end generate intern;
    end generate CELL;
    
    --LOGICA DE DETERMINARE A IESIRII P
    determine_p: 
        for i in 0 to nbBits-1 generate 
            p(i) <= s(i)(0);
     end generate determine_p;
     determine_p2: 
        for i in 0 to nbBits-1 generate 
            p(i+7) <= s(7)(i);
     end generate determine_p2;
     --ultimul nu il mai asignez sumei si va fi ultimul transport din matrice
     p(2*nbBits-1) <= t_aux(nbBits-1)(nbBits);
    
end Behavioral;
