----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Test bench pentru sumatorul pe 8 biti
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;



entity sumator_8_tb is
end sumator_8_tb;

architecture Behavioral of sumator_8_tb is
    --declarea semnalelor
    signal x   : STD_LOGIC_VECTOR (7 downto 0):=x"00";
    signal y   : STD_LOGIC_VECTOR (7 downto 0):=x"00";
    signal tin : STD_LOGIC:='0';
    signal s   : STD_LOGIC_VECTOR(7 downto 0):=x"00";
    signal tout: STD_LOGIC:='0';
    
begin
    DUT: entity Work.sumator_8 PORT MAP(
        x=> x,
        y=> y,
        tin => tin, 
        s => s, 
        tout => tout
         );
         
    gen_signals: process
    --constanta interval numere
        constant maxValue : INTEGER:=2**8-1;
        constant timeVal : TIME :=10ns;
        variable nbErr : INTEGER:=0;
        variable result : STD_LOGIC_VECTOR(8 downto 0):= (others=>'0');
    begin 
        for i in 0 to maxValue loop 
            for j in 0 to maxValue loop
                x <= CONV_STD_LOGIC_VECTOR(i, 8);
                y <= CONV_STD_LOGIC_VECTOR(j, 8);
                tin <= '1'; 
                wait for timeVal;
                result := tout & s;
                if CONV_STD_LOGIC_VECTOR(i+j+1, 9) /= result then 
                    report "Error in adding " & INTEGER'IMAGE(i) & " + 1 + " & INTEGER'IMAGE(j) & "/=" & INTEGER'IMAGE(conv_integer(unsigned(result))) severity ERROR;
                    nbErr := nbErr + 1;
                end if;
                wait for timeVal;
                
                tin <='0';
                wait for timeVal;
                result := tout & s;
                if CONV_STD_LOGIC_VECTOR(i+j, 9) /= result then 
                    report "Error in adding " & INTEGER'IMAGE(i) & " + " & INTEGER'IMAGE(j) & "/=" & INTEGER'IMAGE(conv_integer(unsigned(result))) severity ERROR;
                    nbErr := nbErr + 1;
                end if;
                wait for timeVal;
                
            end loop;
        end loop;
        if nbErr = 0 then 
            report "NO ERRORS" severity NOTE;
        else 
            report INTEGER'IMAGE(nbErr) & " errors" severity FAILURE;
        end if;
        wait;
        
    end process gen_signals;

end Behavioral;
