----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/03/2021 01:38:40 AM
-- Design Name: 
-- Module Name: bist_t - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
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

entity bist_t is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           t : in STD_LOGIC;
           q : out STD_LOGIC);
end bist_t;

architecture Behavioral of bist_t is
     signal q_out: STD_LOGIC:='0';
begin
   
    process(clk)
       
    begin
        if rising_edge(clk) then 
            if rst='1' then 
                q_out<= '0';
            elsif t='1' then 
                q_out<= not q_out;
            else 
                q_out<= q_out;
            end if;
        end if;
        end process;
     
     q<= q_out;
    

end Behavioral;
