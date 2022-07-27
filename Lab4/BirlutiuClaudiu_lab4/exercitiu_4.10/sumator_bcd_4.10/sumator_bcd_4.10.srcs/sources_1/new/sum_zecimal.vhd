----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI -ro 
-- Sumator zecimal pe d4 biti
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sum_zecimal is
    Port ( x :   in STD_LOGIC_VECTOR (3 downto 0);
           y :   in STD_LOGIC_VECTOR (3 downto 0);
           tin : in STD_LOGIC;
           s :   out STD_LOGIC_VECTOR (3 downto 0);
           tout: out STD_LOGIC);
end sum_zecimal;

architecture Behavioral of sum_zecimal is
    --semnal pentru suma intermediara
    signal s_sum1 : STD_LOGIC_VECTOR(3 downto 0):=x"0";
    signal t_sum1: STD_LOGIC:='0';
    --valoare nefolosita; trabsportul celui de-al doilea sumator
    signal t_foo : STD_LOGIC:='0';
    
    --opernad pentru sumatorul 2
    signal op2 : STD_LOGIC_VECTOR(3 downto 0):=x"0";
    --semnal pentru transportul final; 
    signal t_aux : STD_LOGIC:='0';
begin
    
    SUM1: entity work.sumator_4 PORT MAP (
        x => x, 
        y => y, 
        tin => tin,
        s => s_sum1,       
        tout => t_sum1
    );
    --calculare transport 
    t_aux <= t_sum1 or ( s_sum1(3) and s_sum1(2) ) or (s_sum1(3) and s_sum1(1));
    tout <= t_aux;
    op2 <= '0' & t_aux & t_aux & '0';
    --maparea celei de-a 2 sume (+6 in cazul unei depasiri)
    SUM2: entity work.sumator_4 PORT MAP (
        x => s_sum1, 
        y => op2, 
        tin => '0',
        s => s,       
        tout => t_foo
    );

end Behavioral;
