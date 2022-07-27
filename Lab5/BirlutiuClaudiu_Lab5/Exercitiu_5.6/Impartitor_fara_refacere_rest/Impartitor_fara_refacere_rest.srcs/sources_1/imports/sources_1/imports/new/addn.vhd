----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Sumator pe n biti
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity addn is
    generic (n: INTEGER:=4);

    Port ( x :    in STD_LOGIC_VECTOR (n-1 downto 0);
           y :    in STD_LOGIC_VECTOR (n-1 downto 0);
           tin :  in STD_LOGIC;
           s :    out STD_LOGIC_VECTOR (n-1 downto 0);
           tout : out STD_LOGIC;
           ovf :  out STD_LOGIC);
end addn;

architecture Behavioral of addn is
    signal tins : STD_LOGIC_VECTOR (n downto 0):=(others => '0');
    
begin
    
    sumx: process(x,y,tin)
    variable tr :STD_LOGIC_VECTOR(n downto 0):=(others => '0' );
    begin
        tr(0) :=tin;
        for i in x'reverse_range loop 
            s(i) <= x(i) xor y(i) xor tr(i);
            tr(i+1) := (x(i) and y(i)) or ((x(i) or y(i)) and tr(i));
        end loop;
        tout <=tr(n);
        ovf <= tr(n) xor tr(n-1);        
    end process sumx;

end Behavioral;

