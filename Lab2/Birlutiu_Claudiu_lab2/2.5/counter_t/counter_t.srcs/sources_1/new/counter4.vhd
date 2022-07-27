----------------------------------------------------------------------------------
--NAme: Birlutiu Claudiu-Andrei 
--CTI-ro, UTCN
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity counter4 is
    Port ( clk : in STD_LOGIC;
           en : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC_VECTOR (3 downto 0));
end counter4;

architecture Behavioral of counter4 is
    component bist_t is
         Port ( clk : in STD_LOGIC;
                rst : in STD_LOGIC;
                t   : in STD_LOGIC;
                q   : out STD_LOGIC);
    end component bist_t;
    
    signal q0 : STD_LOGIC:='0';
    signal q1 : STD_LOGIC:='0';
    signal q2 : STD_LOGIC:='0';
    signal q3 : STD_LOGIC:='0';
    signal t1 : STD_LOGIC:='0';
    signal t2 : STD_LOGIC:='0';
    signal t3 : STD_LOGIC:='0';
    
begin
    t1<=q0 and en;
    t2<=q1 and t1;
    t3<=q2 and t2;
    bist0: bist_t PORT MAP ( clk=>clk, rst=>rst, t=>en, q=>q0);
    bist1: bist_t PORT MAP ( clk=>clk, rst=>rst, t=>t1, q=>q1);
    bist2: bist_t PORT MAP ( clk=>clk, rst=>rst, t=>t2, q=>q2);
    bist3: bist_t PORT MAP ( clk=>clk, rst=>rst, t=>t3, q=>q3);
    
    q <= q3 & q2 & q1 & q0;
end Behavioral;
