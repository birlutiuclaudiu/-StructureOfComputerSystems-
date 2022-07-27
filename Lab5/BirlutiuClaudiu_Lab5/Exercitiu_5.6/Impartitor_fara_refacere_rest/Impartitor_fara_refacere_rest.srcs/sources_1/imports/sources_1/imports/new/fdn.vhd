----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Registru pe n biti 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fdn is
    generic ( n : INTEGER :=4);
    Port ( clk  :    in STD_LOGIC;
           d    :    in STD_LOGIC_VECTOR (n-1 downto 0);
           ce   :    in STD_LOGIC;
           rst  :    in STD_LOGIC;
           q    :    out STD_LOGIC_VECTOR (n-1 downto 0));
end fdn;

architecture Behavioral of fdn is

begin

    n_register: process(clk)
    begin 
        if rising_edge(clk) then 
            
            if rst = '1' then 
                q <= (others=>'0');
            elsif ce = '1' then 
                q <= d; 
            end if;

        end if;
    end process n_register;
end Behavioral;
