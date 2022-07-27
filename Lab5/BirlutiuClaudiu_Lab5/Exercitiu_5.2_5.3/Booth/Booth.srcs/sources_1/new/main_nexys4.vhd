----------------------------------------------------------------------------------
--Birlutiu Claudiu-Andrei
-- UTCN -CTI ro
-- Project: Inmultitor cu metoda BOOTH
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity main_nexys4 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           Start : in STD_LOGIC;
           x :      in STD_LOGIC_VECTOR(7 downto 0);
           y :      in STD_LOGIC_VECTOR(7 downto 0);
           an :     out STD_LOGIC_VECTOR (7 downto 0);
           seg :    out STD_LOGIC_VECTOR (7 downto 0);
           term :   out STD_LOGIC);
end main_nexys4;

architecture Behavioral of main_nexys4 is

  constant n :INTEGER:=8;
  signal startD : STD_LOGIC:='0';
  signal a :      STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal q :      STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal data :   STD_LOGIC_VECTOR(31 downto 0):=(others=>'0');
begin
    
    MUL: entity work.mul_booth GENERIC MAP (n=>n) PORT MAP( clk=>clk, rst=>rst, start=>startD, x=>x, y=>y, a=>a, q=>q, term=>term);
    
    debounce: entity work.debounce PORT MAP (clk=>clk, rst=>rst, Din => Start, QOut=>startD);  
    
    data<= (x & y & a & q) ;
    display_seg:    entity work.displ7seg PORT MAP( clk=>clk, rst=>rst, data=>data, an=>an, seg=>seg); 
    
end Behavioral;
