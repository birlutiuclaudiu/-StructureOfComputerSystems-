----------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--Project: hex to bcd
---------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity b_bcd is
     port ( data_in: in  STD_LOGIC_VECTOR (3 downto 0); 
            bcd1   : out STD_LOGIC_VECTOR (3 downto 0);
            bcd0   : out STD_LOGIC_VECTOR (3 downto 0)
           );
end b_bcd;

architecture Behavioral of b_bcd is

begin

    bcd1 <= "0000" when data_in< x"A"
             else "0001";
    bcd0 <= data_in when data_in< x"A" else
            data_in-x"A";
end Behavioral;
