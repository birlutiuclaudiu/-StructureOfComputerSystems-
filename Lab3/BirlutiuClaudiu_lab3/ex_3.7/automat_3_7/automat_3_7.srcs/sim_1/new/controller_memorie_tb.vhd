----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei 
-- UTCN Cti-ro
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity controller_memorie_tb is
end controller_memorie_tb;

architecture Behavioral of controller_memorie_tb is

    --declararea semnalelor pentru sistemul de testat
        signal clk:  STD_LOGIC:='0';
        signal rst:  STD_LOGIC:='0';
        signal busId:  STD_LOGIC_VECTOR (7 downto 0):=x"00";
        signal rw:  STD_LOGIC:='0';
        signal burst:  STD_LOGIC:='0';
        signal ready:  STD_LOGIC:='0';
        signal oe:  STD_LOGIC:='0';
        signal we:  STD_LOGIC:='0';
        signal adr   :  STD_LOGIC_VECTOR(1 downto 0):="00";
    --declarare constanta pentru perioada de ceas
    constant CLK_PERIOD : TIME:= 10ns;

begin
    
    DUT: entity WORK.controller_memorie PORT MAP (
            clk => clk,
            rst => rst,
            busId => busId,
            rw => rw, 
            burst => burst, 
            ready => ready, 
            oe => oe, 
            we => we, 
            adr => adr 
            );
        
    generate_clk: clk <= not clk after CLK_PERIOD/2;
    
    gen_signals: process
        --declarea varibila ce contorizeza numarul de erori 
        variable nbErr : INTEGER:=0; 
        
    begin 
        --verificare magistrala
        busId <= x"01";
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "pentru busId=x01 gresit " severity ERROR;
            nbErr := nbErr+1;
        end if;
        
        --scriere 
        busId <= x"A5";
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "Nu a intrat in decision cu datele corecte" severity ERROR;
            nbErr := nbErr+1;
        end if;
        rw <= '0';
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='1' and adr="00") then
            report "pentru write gresit " severity ERROR;
            nbErr := nbErr+1;
        end if;
        ready <= '1';
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "Nu s-a incheiat scrierea corect " severity ERROR;
            nbErr := nbErr+1;
        end if;
        
        --citire simpla
        busId <= x"A5";
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "Nu a intrat in decision cu datele corecte" severity ERROR;
            nbErr := nbErr+1;
        end if;
        rw <= '1';
        wait for CLK_PERIOD;
        if not (oe ='1' and we ='0' and adr="00") then
            report "pentru read1 gresit " severity ERROR;
            nbErr := nbErr+1;
        end if;
        ready <= '1';
        burst <= '0';
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "Nu s-a incheiat citirea simpla bine " severity ERROR;
            nbErr := nbErr+1;
        end if;
        
        --citire exploziv
        busId <= x"A5";
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "Nu a intrat in decision cu datele corecte" severity ERROR;
            nbErr := nbErr+1;
        end if;
        rw <= '1';
        wait for CLK_PERIOD;
        if not (oe ='1' and we ='0' and adr="00") then
            report "pentru read1 gresit " severity ERROR;
            nbErr := nbErr+1;
        end if;
        ready <= '1';
        burst <= '1';
        wait for CLK_PERIOD;
        if not (oe ='1' and we ='0' and adr="01") then
            report "Nu s-a ajuns in read2 " severity ERROR;
            nbErr := nbErr+1;
        end if;
        ready<= '1';
        wait for CLK_PERIOD;
        if not (oe ='1' and we ='0' and adr="10") then
            report "Nu s-a ajuns in read3 " severity ERROR;
            nbErr := nbErr+1;
        end if;
        ready<= '1';
        wait for CLK_PERIOD;
        if not (oe ='1' and we ='0' and adr="11") then
            report "Nu s-a ajuns in read4 " severity ERROR;
            nbErr := nbErr+1;
        end if;
        ready<= '1';
        wait for CLK_PERIOD;
        if not (oe ='0' and we ='0' and adr="00") then
            report "Nu s-a ajuns in idle dupa citirea exploziv " severity ERROR;
            nbErr := nbErr+1;
        end if;
        rst <= '1';
        
        if nbErr = 0 then 
            report "NO ERRORS" severity NOTE;
        else 
            report INTEGER'IMAGE(nbErr) & " errors" severity FAILURE;
        end if;
        wait;
        
    end process gen_signals;

end Behavioral;
