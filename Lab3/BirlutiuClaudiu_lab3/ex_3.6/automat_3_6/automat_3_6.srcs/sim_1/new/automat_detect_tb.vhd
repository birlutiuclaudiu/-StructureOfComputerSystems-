----------------------------------------------------------------------------------
--Birlutiu Claudiu-Andrei
--UTCN CTI-ro
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity automat_detect_tb is
end automat_detect_tb;

architecture Behavioral of automat_detect_tb is
    --declarea semnale pentru sistemul testat
    signal clk: STD_LOGIC:='0';
    signal rst: STD_LOGIC:='0';
    signal b:   STD_LOGIC:='0';    --intrarea seriala
    signal detect: STD_LOGIC:='0';
    
    --declarea perioada semnal de ceas
    constant CLK_PERIOD : TIME:=10ns;
begin
    DUT: entity Work.automat_detect PORT MAP (
                clk => clk, 
                rst => rst, 
                b   => b,
                detect => detect);
    gen_clk: process
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process;
    
    generate_signals: process
        --pentru testarea unor sevente directe
        variable data_vec : STD_LOGIC_VECTOR(7 downto 0):=x"00";
        --numarul de erori
        variable nbErr : INTEGER:=0;
        --cateva combinatii hardcodate; secevanta  11101011
        variable comb1 :STD_LOGIC_VECTOR(15 downto 0):="1110101111101011"; --ar trebui sa genereze doua detectu-ri
        variable comb2 :STD_LOGIC_VECTOR(13 downto 0):="11101011101011";
        variable comb3 :STD_LOGIC_VECTOR (10 downto 0):="11011101011";  --start -> first1->second1 -> start ->....detect
        variable comb4 :STD_LOGIC_VECTOR (11 downto 0):="111011101011";  --start -> first1->second1 -> third1 -> fourth0-> fifth1 -> second1
        
    begin
        rst <= '1'; 
        wait for CLK_PERIOD;
        rst <= '0';
        wait for CLK_PERIOD;
        for i in 0 to 2**8-1 loop
            
            for j in 7 downto 0 loop 
                b <= data_vec(j);
                wait for CLK_PERIOD;
            end loop;
            
            if data_vec = "11101011" then
                if detect='1' then 
                    report "SECVENTA IDENTIFICATA CORECT" severity NOTE;
                else 
                    report "SECVENTA GRESIT IDENTIFICATA detect must be 1" severity ERROR;
                    nbErr := nbErr + 1;
                end if;
            elsif detect='1' then 
                     report "SECVENTA GERSIT IDENTIFICATA detect must be 1" severity ERROR;
            end if;
            rst <='1';                    --resetam pentru a porni tot de la inceput
            wait for CLK_PERIOD;
            rst <='0';                    --resetam pentru a porni tot de la inceput
            wait for CLK_PERIOD;
          data_vec := data_vec + 1;
       end loop;
       
       
       ------------------alte combinatii hardcodate------------------------------------
       rst <='1';                    --resetam pentru a porni tot de la inceput
       wait for CLK_PERIOD;
       rst <='0';                    --resetam pentru a porni tot de la inceput
       wait for CLK_PERIOD;
       for i in comb1'range loop 
            b<= comb1(i);
            wait for CLK_PERIOD;
            if i=8 or i=0 then 
                if detect /= '1' then 
                    report "expected value for detect is 1 not 0 "  severity ERROR;
                    nbErr := nbErr +1; 
                end if;
            elsif detect ='1' then 
                report "expected value for detect is 0 not 1 comb1 "  severity ERROR;
                nbErr := nbErr +1; 
            end if;
       end loop;
       rst <='1';
       wait for CLK_PERIOD;
       rst <='0';
       wait for CLK_PERIOD;
       ---------------------------------------
       for i in comb2'range loop 
            b<= comb2(i);
            wait for CLK_PERIOD;
            if i=0 or i=6 then 
                if detect /= '1' then 
                    report "expected value for detect is 1 not 0" severity ERROR;
                    nbErr := nbErr +1; 
                end if;
            elsif detect ='1' then 
                report "expected value for detect is 0 not 1 comb2" severity ERROR;
                nbErr := nbErr +1; 
            end if;
           
       end loop;
       rst <='1';
       wait for CLK_PERIOD;
       rst <='0';
       wait for CLK_PERIOD;
      -----------------------------------------------------
       
      for i in comb3'range loop 
            b<= comb3(i);
             wait for CLK_PERIOD;
            if i=0 then 
                if detect /= '1' then 
                    report "expected value for detect is 1 not 0" severity ERROR;
                    nbErr := nbErr +1; 
                end if;
            elsif detect ='1' then 
                report "expected value for detect is 0 not 1 comb3" severity ERROR;
                nbErr := nbErr +1; 
            end if;         
       end loop;
       rst <='1';
       wait for CLK_PERIOD;
       rst <='0';
       wait for CLK_PERIOD;
      ------------------------------------------------------
      
      for i in comb4'range loop 
            b<= comb4(i);
            wait for CLK_PERIOD;
            if i=0 then 
                if detect /= '1' then 
                    report "expected value for detect is 1 not 0" severity ERROR;
                    nbErr := nbErr +1; 
                end if;
            elsif detect ='1' then 
                report "expected value for detect is 0 not 1 comb4" severity ERROR;
                nbErr := nbErr +1; 
            end if;
       end loop;
       -------------------------------------------VERIFICARE----------------------------------------------------------------
       if nbErr =0 then 
            report "NO ERRORS" severity NOTE;
        else 
            report INTEGER'IMAGE(nbErr) & " errors" severity FAILURE;
        end if;
        
        rst <='1';
        wait;
    end process generate_signals;
    

end Behavioral;
