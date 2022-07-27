----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN Cti -ro 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity sumator_4_digits_tb is
end sumator_4_digits_tb;

architecture Behavioral of sumator_4_digits_tb is
    signal x : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
    signal y : STD_LOGIC_VECTOR(15 downto 0):=X"0000";
    signal s : STD_LOGIC_VECTOR(15 downto 0):=x"0000";
    signal t : STD_LOGIC:='0';
    
    ---decalrarea unei functii de conversie 
    function int_to_bcd (
         int : in INTEGER)
    return std_logic_vector is
      variable v_TEMP : std_logic_vector(15 downto 0);
    begin
        v_temp(15 downto 12) := conv_std_logic_vector( int/1000, 4);
        v_temp(11 downto 8)  := conv_std_logic_vector( int/100 mod 10, 4);
        v_temp(7 downto 4)   := conv_std_logic_vector( int/10 mod 10, 4);
        v_temp(3 downto 0)   := conv_std_logic_vector( int mod 10, 4);
    return std_logic_vector(v_TEMP);
    end;
    
begin

    DUT: entity work.sumator_4_digits PORT MAP(  
        x=>x, 
        y=>y, 
        s=>s, 
        tout=>t
    );
    
    gen_signals: process
        variable nbErr: INTEGER:=0;
        variable result: INTEGER:=0;
        constant timeVal : TIME:=2ns;
    begin 
        --verificare pentru niste combinatiile de numere 
        for i in 2345 to 2400 loop
            for j in 5400 to 5431 loop
                x <= int_to_bcd(i);
                y <= int_to_bcd(j);
                wait for timeVal;
                result := conv_integer(t)*1000;
                result := result + conv_integer(s(15 downto 12)) * 1000;
                result := result + conv_integer(s(11 downto 8)) * 100;
                result := result + conv_integer(s(7 downto 4)) * 10;
                result := result + conv_integer(s(3 downto 0));
               
                if result/= i+j then 
                    report "FAIL " & INTEGER'IMAGE(result) & "\=" & INTEGER'IMAGE(i+j) severity ERROR;
                    nbErr := nbErr +1;
                 end if; 
                 wait for timeVal;
            end loop;  
            
        end loop;
        
        if nbErr =0 then 
            report "NO ERRORS" severity NOTE;
        else 
            report INTEGER'IMAGE(nbErr) & " errors" severity FAILURE;
        end if;
        
        wait;
    end process;
end Behavioral;
