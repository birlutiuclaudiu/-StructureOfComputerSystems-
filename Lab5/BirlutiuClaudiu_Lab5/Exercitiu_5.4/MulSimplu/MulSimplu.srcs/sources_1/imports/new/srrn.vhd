----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Registru pe n biti cu deplasare dreapta
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity srrn is
    generic (n : INTEGER:=4);
    Port ( clk :    in STD_LOGIC;
           d :      in STD_LOGIC_VECTOR (n-1 downto 0);
           sri :    in STD_LOGIC;
           load :   in STD_LOGIC;
           ce :     in STD_LOGIC;
           rst :    in STD_LOGIC;
           q :      out STD_LOGIC_VECTOR (n-1 downto 0));
end srrn;

architecture Behavioral of srrn is
     signal aux_q: STD_LOGIC_VECTOR (n-1 downto 0):=(others => '0');
begin
    
    n_register: process( clk )
   
    begin
        if rising_edge(clk) then 
            if rst = '1' then 
                aux_q <= (others => '0');
            elsif load = '1' then 
                aux_q <= d; 
            elsif ce = '1' then 
                aux_q <= sri & aux_q(n-1 downto 1);
            end if;
        end if;
       
       
    end process n_register;
    
     q <= aux_q;

end Behavioral;
