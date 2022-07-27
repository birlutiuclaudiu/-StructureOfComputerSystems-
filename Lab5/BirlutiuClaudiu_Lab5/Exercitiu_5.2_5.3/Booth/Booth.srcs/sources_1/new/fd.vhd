----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- bistabil d
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity fd is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC;
           ce : in STD_LOGIC;
           rst : in STD_LOGIC;
           q : out STD_LOGIC);
end fd;

architecture Behavioral of fd is
    signal q_aux: STD_LOGIC:='0';
begin
    --proces pentrru descirearea bistabilului
    flip_flop: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then      --reset sincron
                q_aux <= '0';
            elsif ce = '1' then  
                q_aux <= d;
            end if;
        end if;
    end process flip_flop;

    q<= q_aux;
    
end Behavioral;
