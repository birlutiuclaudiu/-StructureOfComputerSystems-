----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/02/2021 09:50:58 PM
-- Design Name: 
-- Module Name: num4 - Behavioral
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
entity num4 is
port (Clk : in STD_LOGIC;
      Rst : in STD_LOGIC;
      En : in STD_LOGIC;
      Num : out STD_LOGIC_VECTOR (3 downto 0));
end num4;

architecture simul of num4 is
    function INC_BV (A : STD_LOGIC_VECTOR) return STD_LOGIC_VECTOR is
            variable Rez : STD_LOGIC_VECTOR (A'range);
            variable C : STD_LOGIC;
        begin
         C := '1';
            for i in A'reverse_range loop
                Rez(i) := A(i) xor C;
                C := A(i) and C;
            end loop;
       return Rez;
    end INC_BV;
    
    signal Num_int : STD_LOGIC_VECTOR (3 downto 0);

begin
    process (Clk)
    begin
        if (Clk'event and Clk = '1') then
            if (Rst = '1') then
                Num_int <= (others => '0');
            elsif (En = '1') then
                Num_int <= INC_BV (Num_int);
            end if;
        end if;
    end process;

    Num <= Num_int;
end simul;
