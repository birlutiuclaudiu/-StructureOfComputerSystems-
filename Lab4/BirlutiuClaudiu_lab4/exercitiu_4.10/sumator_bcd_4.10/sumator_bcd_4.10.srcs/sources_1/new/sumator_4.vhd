----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN Cti-ro
-- Sumator pe 4 biti
---------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sumator_4 is
     Port ( x   : in STD_LOGIC_VECTOR (3 downto 0);
            y   : in STD_LOGIC_VECTOR (3 downto 0);
            tin : in STD_LOGIC;
            s   : out STD_LOGIC_VECTOR (3 downto 0);
            tout: out STD_LOGIC);
end sumator_4;
    
architecture Behavioral of sumator_4 is
    signal g0 : STD_LOGIC:='0';
    signal g1 : STD_LOGIC:='0';
    signal g2 : STD_LOGIC:='0';
    signal g3 : STD_LOGIC:='0';
    signal p0 : STD_LOGIC:='0';
    signal p1 : STD_LOGIC:='0';
    signal p2 : STD_LOGIC:='0';
    signal p3 : STD_LOGIC:='0';
    --transport pentru sumator 1
    signal t1 : STD_LOGIC:='0';
    signal t2 : STD_LOGIC:='0';
    signal t3 : STD_LOGIC:='0';
begin
    --calcul pentru functiile g si p
    g0 <= x(0) and y(0);
    g1 <= x(1) and y(1);
    g2 <= x(2) and y(2);
    g3 <= x(3) and y(3);
    p0 <= x(0) or y(0);
    p1 <= x(1) or y(1);
    p2 <= x(2) or y(2); 
    p3 <= x(3) or y(3);
    
    --calculare transport cu anticipare
    t1 <= g0 or (p0 and tin);
    t2 <= g1 or (p1 and g0) or (p1 and p0 and tin);
    t3 <= g2 or (p2 and g1) or (p2 and p1 and g0) or  (p2 and p1 and p0 and tin);
    tout <= g3 or (p3 and g2) or (p3 and p2 and g1) or  (p3 and p2 and p1 and g0) or ( p3 and p2  and p1 and p0 and tin);
    --calcul biti suma
    s(0) <= x(0) xor y(0) xor tin;
    s(1) <= x(1) xor y(1) xor t1;
    s(2) <= x(2) xor y(2) xor t2; 
    s(3) <= x(3) xor y(3) xor t3;
end Behavioral;
