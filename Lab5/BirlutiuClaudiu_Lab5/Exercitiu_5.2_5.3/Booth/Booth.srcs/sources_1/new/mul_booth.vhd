----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Inmultitor cu tehnica booth
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity mul_booth is
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
end mul_booth;

architecture Behavioral of mul_booth is
    --semnanle unitatea de control 
    signal loadB, subB, loadQ, rstQ_1, rstA, loadA, shrA_Q: STD_LOGIC:='0';
    signal q_1 : STD_LOGIC:='0';
    --semnale pentru sumator
    signal sum :     STD_LOGIC_VECTOR(n -1 downto 0):=(others=>'0');
    signal t, ovf:   STD_LOGIC:='0';
    signal opReg:    STD_LOGIC_VECTOR(n-1 downto 0):=(others =>'0');
    signal auxiliar: STD_LOGIC_VECTOR(n-1 downto 0):=(others =>'1');
    --semnale registre
    signal A_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    signal B_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    signal Q_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    
    --pentru resetare registru a si cand se apasa resetul general
    signal resetA: STD_LOGIC:='0';
    signal resetQ1: STD_LOGIC:='0';

begin
    
    resetA <= rstA or rst;
    resetQ1 <= rstQ_1 or rst;
    b_register: entity work.fdn GENERIC MAP ( n => n)
                    PORT MAP(clk=>clk, rst=> rst, ce => loadB, d=> x, q=>B_reg);
    
    a_register: entity work.srrn GENERIC MAP (n => n)
                    PORT MAP (clk=>clk, d => sum, sri => A_reg(n-1), load=>loadA, ce => shrA_Q, rst => resetA, q => A_reg );
    
    q_register: entity work.srrn GENERIC MAP (n => n)
                    PORT MAP (clk=>clk, d => y, sri => A_reg(0), load=>loadQ, ce => shrA_Q, rst =>rst, q => Q_reg );
    
    sum_n: entity work.addn GENERIC MAP (n=>n)
                    PORT MAP (x=>A_reg, y=>opReg, tin => subB, s=>sum, tout=>t, ovf=>ovf);

    q_1_bistabil: entity work.fd PORT MAP( clk=>clk, d=>Q_reg(0), ce => shrA_Q, rst => resetQ1, q => Q_1 );

    control_unit: entity work.fsm_cmd GENERIC MAP (n=>n)
        PORT MAP ( clk=>clk, rst=>rst, start=>start, q0=>Q_reg(0), q_1=>q_1, term=>term, 
                    loadB=>loadB, subB=>subB, rstA=>rstA, loadA=>loadA, shrA_Q=>shrA_Q, loadQ=>loadQ, rstQ_1=>rstQ_1 );
    
    opReg <= B_reg xor auxiliar when subB ='1' else B_reg;
    q <= Q_reg;
    a <= A_reg;
end Behavioral;
