----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN Cti- ro
-- Sumator elementar
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sumator_elementar is
    Port ( x :      in STD_LOGIC;
           y :      in STD_LOGIC;
           tin :    in STD_LOGIC;
           s :      out STD_LOGIC;
           t :      out STD_LOGIC);
end sumator_elementar;

architecture Behavioral of sumator_elementar is

begin
    s <= x xor y xor tin;
    t <= (x and y) or ((x or y) and tin);

end Behavioral;
