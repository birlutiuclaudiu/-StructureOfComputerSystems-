----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Impartitor cu refacerea restului
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity divider_ref is
    generic (
        n: INTEGER:=8
    );
    Port ( clk :     in STD_LOGIC;
           rst :     in STD_LOGIC;
           start :   in STD_LOGIC;
           x :       in STD_LOGIC_VECTOR(2*n-1 downto 0);
           y :       in STD_LOGIC_VECTOR(n-1 downto 0);
           a :       out STD_LOGIC_VECTOR(n-1 downto 0);
           q :       out STD_LOGIC_VECTOR(n-1 downto 0);
           term :    out STD_LOGIC);
end divider_ref;

architecture Behavioral of divider_ref is
    --semnanle unitatea de control 
    signal loadB, subB, loadA , shlA_Q , loadQ, updateQ, loadX: STD_LOGIC:='0';
    
    --semnale pentru sumator
    signal sum :     STD_LOGIC_VECTOR(n downto 0):=(others=>'0');   --pentru a putea face calculele cu numere negative; am luat pe n +1 biti suma
    signal t, ovf:   STD_LOGIC:='0';
    signal opReg:    STD_LOGIC_VECTOR(n downto 0):=(others =>'0');
    signal auxiliar: STD_LOGIC_VECTOR(n downto 0):=(others =>'1');
    --semnale registre
    signal A_reg : STD_LOGIC_VECTOR(n downto 0):=(others=>'0');
    signal B_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    signal Q_reg : STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    
    --pentru resetare registru a si cand se apasa resetul general
    signal loadA_reg: STD_LOGIC_VECTOR(n downto 0):=(others=>'0');
    signal totalSum:  STD_LOGIC_VECTOR(n+1 downto 0):=(others=>'0');
    signal loadQ_reg: STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
    

begin
    loadA_reg <= '0' & x(2*n-1 downto n) when loadX='1' else sum;
    totalSum <= t & sum;
    b_register: entity work.fdn GENERIC MAP ( n => n)
                    PORT MAP(clk=>clk, rst=> rst, ce => loadB, d=> y, q=>B_reg);
    
    a_register: entity work.srln GENERIC MAP (n => n+1)
                    PORT MAP (clk=>clk, d => loadA_reg, sli =>Q_reg(n-1), load=>loadA, ce => shlA_Q, rst => rst, q => A_reg );
    
    q_register: entity work.srln GENERIC MAP (n => n)
                    PORT MAP (clk=>clk, d => loadQ_reg, sli => '0', load=>loadQ, ce => shlA_Q, rst =>rst, q => Q_reg );
    
    sum_n: entity work.addn GENERIC MAP (n=>n+1)
                    PORT MAP (x=>A_reg(n downto 0), y=>opReg, tin => subB, s=>sum, tout=>t, ovf=>ovf);


    control_unit: entity work.fsm_cmd GENERIC MAP (n=>n)
        PORT MAP ( clk=>clk, rst=>rst, start=>start, an=> A_reg(n), term=>term, 
                    loadB=>loadB, subB=>subB, loadA=>loadA, shlA_Q=>shlA_Q, loadQ=>loadQ, updateQ=>updateQ, loadX => loadX);
   
   --pentru a putea introduce Q0=An; trebuie sa se faca load pe registrul q astfel
    loadQ_reg <= Q_reg(n-1 downto 1) & not(A_reg(n)) when updateQ='1' else x(n-1 downto 0);
   
    opReg <= ('0'& B_reg) xor auxiliar when subB ='1' else '0' & B_reg;
    q <= Q_reg;
    a <= A_reg(n-1 downto 0);
end Behavioral;
