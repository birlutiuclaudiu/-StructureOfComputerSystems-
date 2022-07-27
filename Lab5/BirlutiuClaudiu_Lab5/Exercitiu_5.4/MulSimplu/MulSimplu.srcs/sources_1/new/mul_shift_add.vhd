----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Inmultitor cu shiftare si adunari
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mul_shift_add is
    generic (
        n: INTEGER:=8
    );
    Port ( clk :     in STD_LOGIC;
           rst :     in STD_LOGIC;
           start :   in STD_LOGIC;
           x :       in STD_LOGIC_VECTOR(n-1 downto 0);
           y :       in STD_LOGIC_VECTOR(n-1 downto 0);
           a :       out STD_LOGIC_VECTOR(n-1 downto 0);
           q :       out STD_LOGIC_VECTOR(n-1 downto 0);
           term :    out STD_LOGIC);
end mul_shift_add;

architecture Behavioral of mul_shift_add is
    --semnanle unitatea de control 
    signal loadB, loadA, loadQ, rstA, shrAQ: STD_LOGIC:='0';
    signal q_1 : STD_LOGIC:='0';
    --semnale pentru sumator
    signal sum :      STD_LOGIC_VECTOR(n -1 downto 0):=(others=>'0');
    signal t, ovf:    STD_LOGIC:='0';
    signal total_sum: STD_LOGIC_VECTOR(n downto 0):=(others=>'0');
 
    --semnale registre
    signal A_reg : STD_LOGIC_VECTOR(n downto 0):=(others=>'0');
    signal B_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    signal Q_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    
    --pentru resetare registru a si cand se apasa resetul general
    signal resetA: STD_LOGIC:='0';
    signal resetQ: STD_LOGIC:='0';

begin
    
    resetA <= rstA or rst;
    total_sum <= t & sum;
    
    b_register: entity work.fdn GENERIC MAP ( n => n)
                    PORT MAP(clk=>clk, rst=> rst, ce => loadB, d=> x, q=>B_reg);
    
    a_register: entity work.srrn GENERIC MAP (n => n+1)
                    PORT MAP (clk=>clk, d => total_sum, sri => '0' , load=>loadA, ce => shrAQ, rst => resetA, q => A_reg );
    
    q_register: entity work.srrn GENERIC MAP (n => n)
                    PORT MAP (clk=>clk, d => y, sri => A_reg(0), load=>loadQ, ce => shrAQ, rst =>rst, q => Q_reg );
    
    sum_n: entity work.addn GENERIC MAP (n=>n)
                    PORT MAP (x=>A_reg(n-1 downto 0), y=>B_reg, tin => '0', s=>sum, tout=>t, ovf=>ovf);


    control_unit: entity work.fsm_cmd GENERIC MAP (n=>n)
        PORT MAP ( clk=>clk, rst=>rst, start=>start, q0=>Q_reg(0), term=>term, 
                    loadB=>loadB, rstA=>rstA, loadA=>loadA, shrAQ=>shrAQ, loadQ=>loadQ );
    
    
    q <= Q_reg;
    a <= A_reg(n-1 downto 0);
end Behavioral;
