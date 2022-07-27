----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Sumator cu anticiparea transportului pe 8 biti
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity sumator_8 is
    Port ( x    : in STD_LOGIC_VECTOR (7 downto 0);
           y    : in STD_LOGIC_VECTOR (7 downto 0);
           tin  : in STD_LOGIC;
           s    : out STD_LOGIC_VECTOR(7 downto 0);
           tout : out STD_LOGIC);
end sumator_8;

architecture Behavioral of sumator_8 is
    --declar vectori pentru semnalele P si G ce sunt date de cele 4 sumatoare de 2 biti
    signal P : STD_LOGIC_VECTOR(3 downto 0):=x"0";
    signal G : STD_LOGIC_VECTOR(3 downto 0):=x"0";
    
    --vector pentru semnalele de transport
    signal T : STD_LOGIC_VECTOR(3 downto 0):= x"0"; 
    
    --declarare componentei 
    component sumator_2 is
    Port ( x : in STD_LOGIC_VECTOR (1 downto 0);
           y : in STD_LOGIC_VECTOR (1 downto 0);
           tin : in STD_LOGIC;
           s : out STD_LOGIC_VECTOR (1 downto 0);
           P : out STD_LOGIC;
           G : out STD_LOGIC);
    end component sumator_2;

begin
    --folosirea instructiunii generate pentru a instantia 4 sumatoare pe 2 biti
    GEN_SUM: 
        for i in 0 to 3 generate
            SUMX: sumator_2 PORT MAP ( 
                x   => x(2*i+1 downto 2*i), 
                y   => y(2*i+1 downto 2*i),
                tin => T(i),
                s   => s(2*i+1 downto 2*i),
                P   => P(i),
                G   => G(i)
               );
        end generate GEN_SUM;
   
    --generatorul de transport
    t(0) <= tin;
    t(1) <= G(0) or (P(0) and T(0));
    t(2) <= G(1) or (P(1) and G(0)) or (P(1) and P(0) and T(0));
    t(3) <= G(2) or (P(2) and G(1)) or (P(2) and P(1) and G(0)) or (P(2) and P(1) and P(0) and T(0));
    tout  <= G(3) or (P(3) and G(2)) or (P(3) and P(2) and G(1)) or (P(3) and P(2) and P(1) and G(0)) or (P(3) and P(2) and P(1) and P(0) and T(0));
    
    

end Behavioral;
