----------------------------------------------------------------------------------
--Birlutiu Claudiu-Andrei
-- UTCN Cti-ro
-- Ahritectura peinrcipala pentru implementare pe placa Nexys 4 DDR a sumatorului
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main_mul is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           x :  in STD_LOGIC_VECTOR (7 downto 0);
           y :  in STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg :out STD_LOGIC_VECTOR(7 downto 0));
end main_mul;

architecture Behavioral of main_mul is
    signal p:    STD_LOGIC_VECTOR (15 downto 0) :=x"0000";
    signal data: STD_LOGIC_VECTOR (31 downto 0) :=(others=>'0');
begin

    sum_8: entity WORK.multi PORT MAP (
           x   => x,
           y   => y,
           p    =>p );
    
    mux_disp:  entity Work.displ7seg PORT MAP ( 
           clk  =>clk,
           rst  =>rst,
           data => data,
           an   => an,
           seg  => seg);
           
    data <= x & y & p;
    


end Behavioral;
