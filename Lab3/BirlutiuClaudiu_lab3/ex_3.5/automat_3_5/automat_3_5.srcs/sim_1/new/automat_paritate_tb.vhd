----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN Cti-ro
-- teste bench for automat_paritate
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.ALL;

entity automat_paritate_tb is
end automat_paritate_tb;


architecture Behavioral of automat_paritate_tb is
    --declarare semnale pentru simulare
    signal clk :  STD_LOGIC :='0';
    signal rst :  STD_LOGIC :='0';
    signal sync :  STD_LOGIC :='0';
    signal data :  STD_LOGIC :='0';
    signal perror :  STD_LOGIC :='0';
    
    --daclarare perioada ceas
    constant CLK_PERIOD : TIME:= 10 ns;
  
begin
    DUT: entity Work.automat_paritate  PORT MAP (
            clk => clk,
            rst => rst,
            sync => sync,
            data =>data, 
            perror => perror );
    
    gen_clk: process
    begin
        clk <= '0';
        wait for (CLK_PERIOD/2);
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process gen_clk;
    
    gen_signals: process 
        --variabila pentru 
        variable nbError : INTEGER:= 0;
        variable data_vec: STD_LOGIC_VECTOR(7 downto 0):=x"00";
        --variabila folosita pentru calculul paritatii; aceasta se va calcula cu XOR; se va face xor intre toti bitii numarului si rezultatul va fi interpretat astfel: 
        -- 1- daca exista un numar impar de biti de 1 ; 0- daca exista un numar par de biti; ex: 1010 => 1 XOR 0 XOR 1 XOR 0 = 0 (nr par de bti de 1)
        variable parity: STD_LOGIC:='0'; 
    begin
        --se verifica initialiarea si prima trecere in starea start
        rst <= '1';
        wait for CLK_PERIOD; 
        rst <= '0';
        sync <= '1';
        wait for CLK_PERIOD;
        if not perror = '0' then
            report "perror must be 0 not 1" severity ERROR;
            nbError := nbError +1;
        end if;
        
        sync <= '0';
        wait for CLK_PERIOD;
        if not perror = '0' then
            report "perror must be 0 not 1" severity ERROR;
            nbError := nbError +1;
        end if;
        
        for i in 0 to 2**8-1 loop 
           parity := '0';        --se initializeaza pentru fiecare combinatie a vectorului data_vec
           for i in  0 to 7 loop
                data <= data_vec(i);
                parity := parity XOR data_vec(i);
                wait for CLK_PERIOD;
           end loop;
           
           if  parity /= perror then 
                nbError := nbError +1; 
                report "Gresit for" & INTEGER'IMAGE(to_integer(unsigned(data_vec))) severity ERROR;
           end if;
           wait for 10 ns;   --idle 
           if  parity /= perror then 
                nbError := nbError +1; 
                report "Gresit for" & INTEGER'IMAGE(to_integer(unsigned(data_vec))) severity ERROR;
           end if;
           data_vec := data_vec + 1;
           wait for 10 ns;
        end loop;
        if nbError =0 then 
            report "No errors" severity NOTE;
        else
            report INTEGER'IMAGE(nbError) & " errors" severity FAILURE;
        end if;
        wait;
   end process gen_signals;
    
end Behavioral;
