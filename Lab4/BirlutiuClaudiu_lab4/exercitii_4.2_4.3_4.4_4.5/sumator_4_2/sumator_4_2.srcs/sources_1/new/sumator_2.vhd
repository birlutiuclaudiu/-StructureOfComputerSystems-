----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Sumator cu anticiparea transportului pe 2 biti
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sumator_2 is
    Port ( x   : in STD_LOGIC_VECTOR (1 downto 0);
           y   : in STD_LOGIC_VECTOR (1 downto 0);
           tin : in STD_LOGIC;
           s   :   out STD_LOGIC_VECTOR (1 downto 0);
           P   :   out STD_LOGIC;
           G   :   out STD_LOGIC);
end sumator_2;

architecture Behavioral of sumator_2 is
    signal g0 : STD_LOGIC:='0';
    signal g1 : STD_LOGIC:='0';
    signal p0 : STD_LOGIC:='0';
    signal p1 : STD_LOGIC:='0';
    --transport pentru sumator 1
    signal t1 : STD_LOGIC:='0';
    
begin
    --calcul pentru functiile g si p
    g0 <= x(0) and y(0);
    p0 <= x(0) or y(0);
    
    g1 <= x(1) and y(1);
    p1 <= x(1) or y(1);
    
    --determinarea functiilor de grup
    G <= g1 or (p1 and g0);
    P <= p1 and p0;
    
    --calculare transport
    t1 <= g0 or (p0 and tin);
    s(0) <= x(0) xor y(0) xor tin;
    s(1) <= x(1) xor y(1) xor t1;

end Behavioral;
