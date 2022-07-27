----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN Cti -ro
-- Sumator cu salvarea trasnportului cu generic pentru numarul de biti
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sumator_sst is
   generic ( nbSE : INTEGER:=15);
   port ( 
         x : in STD_LOGIC_VECTOR(nbSE-1 downto 0);
         y : in STD_LOGIC_VECTOR(nbSE-1 downto 0);
         z : in STD_LOGIC_VECTOR(nbSE-1 downto 0);
         s : out STD_LOGIC_VECTOR(nbSE-1 downto 0);
         t : out STD_LOGIC_VECTOR(nbSE-1 downto 0));         
end sumator_sst;

architecture Behavioral of sumator_sst is
    

begin   
    --generarea primului sst
    SST: 
        for i in 0 to nbSE-1 generate
            SE: entity Work.sumator_elementar    
            PORT MAP( 
                x => x(i),
                y => y(i),
                tin => z(i),
                s => s(i),    
                t => t(i)   
            ); 
    end generate SST; 
    
end Behavioral;
