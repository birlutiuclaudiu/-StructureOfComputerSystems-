----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- test Bench for multi_8
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity multi_8_tb is
end multi_8_tb;

architecture Behavioral of multi_8_tb is
    signal x :  STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
    signal y :  STD_LOGIC_VECTOR (7 downto 0):=(others=>'0');
    signal p :  STD_LOGIC_VECTOR (15 downto 0):=(others=>'0');
    --time pentru stabilizare semnale
    constant timeVal: TIME:=5ns;
begin
    DUT: entity WORK.multi PORT MAP(
        x=>x, 
        y=>y, 
        p=>p
    );
    
    generate_signals: process
        variable nbErr : INTEGER:=0;
        variable result: STD_LOGIC_VECTOR(15 downto 0):=x"0000";
    begin
        for i in 0 to 9 loop
            for j in 0 to 9 loop 
                x<=CONV_STD_LOGIC_VECTOR(i,8);
                y<=CONV_STD_LOGIC_VECTOR(j,8);
                wait for timeVal;
                result := CONV_STD_LOGIC_VECTOR(i*j, 16);
                if result /= p then 
                    report INTEGER'image(i) & "*" & INTEGER'IMAGE(j) & "\=" &  INTEGER'IMAGE(conv_integer(unsigned(p))) severity ERROR;
                    nbErr := nbErr + 1;
                end if;
                wait for timeVal;
            end loop;
        end loop;
        
          for i in 230 to 255 loop
            for j in 230 to 255 loop 
                x<=CONV_STD_LOGIC_VECTOR(i,8);
                y<=CONV_STD_LOGIC_VECTOR(j,8);
                wait for timeVal;
                result := CONV_STD_LOGIC_VECTOR(i*j, 16);
                if result /= p then 
                    report INTEGER'image(i) & "*" & INTEGER'IMAGE(j) & "\=" &  INTEGER'IMAGE(conv_integer(unsigned(p))) severity ERROR;
                    nbErr := nbErr + 1;
                end if;
                wait for timeVal;
            end loop;
            
        end loop;
        
         if nbErr = 0 then 
                report "NO ERRORS" severity NOTE;
            else 
                report INTEGER'IMAGE(nbErr) & " ERRORS" severity FAILURE;
            end if;
        wait;
 
    end process generate_signals;
    
end Behavioral;
