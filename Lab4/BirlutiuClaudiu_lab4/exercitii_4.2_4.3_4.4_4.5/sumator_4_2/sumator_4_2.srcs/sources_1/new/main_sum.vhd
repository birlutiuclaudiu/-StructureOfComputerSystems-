----------------------------------------------------------------------------------
--Birlutiu Claudiu-Andrei
-- UTCN Cti-ro
-- Ahritectura peinrcipala pentru implementare pe placa Nexys 4 DDR a sumatorului
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity main_sum is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           x : in STD_LOGIC_VECTOR (7 downto 0);
           y : in STD_LOGIC_VECTOR (7 downto 0);
           an : out STD_LOGIC_VECTOR (7 downto 0);
           seg : out STD_LOGIC_VECTOR(7 downto 0));
end main_sum;

architecture Behavioral of main_sum is
    signal s:    STD_LOGIC_VECTOR (7 downto 0) :=x"00";
    signal tout: STD_LOGIC:='1';
    signal data: STD_LOGIC_VECTOR (31 downto 0) :=(others=>'0');
begin

    sum_8: entity WORK.sumator_8 PORT MAP (
           x   => x,
           y   => y,
           tin  =>'0',
           s    =>s,
           tout => tout
    );
    
    mux_disp:  entity Work.displ7seg PORT MAP ( 
           clk  =>clk,
           rst  =>rst,
           data => data,
           an   => an,
           seg  => seg);
           
    data <= x & y & x"0" & ("000" & tout) & s;
    


end Behavioral;
