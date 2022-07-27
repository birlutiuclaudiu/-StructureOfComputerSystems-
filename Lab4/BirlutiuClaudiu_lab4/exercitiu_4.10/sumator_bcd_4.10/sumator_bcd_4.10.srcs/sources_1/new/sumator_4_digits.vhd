----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI -ro 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sumator_4_digits is
    Port ( x :       in STD_LOGIC_VECTOR (15 downto 0);
           y :       in STD_LOGIC_VECTOR (15 downto 0);
           s :       out STD_LOGIC_VECTOR (15 downto 0);
           tout :    out STD_LOGIC);
end sumator_4_digits;

architecture Behavioral of sumator_4_digits is
    -- trasnport sumatoare
    signal t : STD_LOGIC_VECTOR(4 downto 0):="00000";
begin

   SUMX: for i in 0 to 3  generate
        SUMx: entity work.sum_zecimal PORT MAP (
            x => x(4*i+3 downto 4*i),
            y => y(4*i+3 downto 4*i),
            tin => t(i),
            s => s(4*i+3 downto 4*i),
            tout => t(i+1)
        );    
   end generate SUMX;
     
     --logica pentru transport
     t(0) <= '0';   --nu exista transport initial; semnlalele de intrare sunt doar cele 2 numere de 4 cifre
     tout <= t(4);
     
end Behavioral;
