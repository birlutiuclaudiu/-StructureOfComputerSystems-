----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Celula din matricea de inmultire
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
Use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity cell_mul is
    Port ( x :      in STD_LOGIC;
           a :      in STD_LOGIC;
           y :      in STD_LOGIC;
           tin :    in STD_LOGIC;
           s :      out STD_LOGIC;
           tout :   out STD_LOGIC);
end cell_mul;

architecture Behavioral of cell_mul is
     signal prod : STD_LOGIC:='0';
begin
    prod <= x and y;
    SE: entity work.sumator_elementar PORT MAP (
        x => a, 
        y => prod,
        tin => tin , 
        t => tout, 
        s => s
    );
end Behavioral;
