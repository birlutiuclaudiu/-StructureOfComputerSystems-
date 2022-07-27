----------------------------------------------------------------------------------
-- Name: Birlutiu Claudiu-Andrei
-- Project: num4 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity num4_tb is
--  Port ( );
end num4_tb;

architecture simulare of num4_tb is
    --decalararea semnalelor
   signal Clk :  STD_LOGIC:='0';
   signal Rst :  STD_LOGIC:='0';
   signal En  :  STD_LOGIC:='0';
   signal Num :  STD_LOGIC_VECTOR (3 downto 0):=(others=>'0');
   
   constant CLK_PERIOD : TIME := 10 ns;
begin
   --instatare modul de testat
   DUT: entity WORK.num4 PORT MAP( 
                    Clk=>Clk, 
                    Rst => Rst,
                    En =>En,
                    Num => Num);
                    
   --generarea semnalului de ceas
   gen_clk: process
     begin
        Clk <= '0';
        wait for (CLK_PERIOD/2);
        Clk <= '1';
        wait for (CLK_PERIOD/2);
   end process gen_clk;
   
   --procesul pentru datele de intrare
    sim_proc: process
        variable RezCorect: STD_LOGIC_VECTOR(3 downto 0):="0000"; --rezultat asteptat
        variable NrErori: INTEGER:=0;                             --numarul de erori
        begin
            Rst <= '1';
            wait for CLK_PERIOD; 
            Rst <= '0';
            wait for CLK_PERIOD;
            En <= '1';
            
            for i in 0 to 15 loop
                if ( Num /= RezCorect) then
                    report "Rezultat corect "  & STD_LOGIC'image (RezCorect(3)) & STD_LOGIC'image (RezCorect(2)) & STD_LOGIC'image (RezCorect(1)) & STD_LOGIC'image (RezCorect(0)) &
                             "Rezultat obtinut" & STD_LOGIC'image(Num(3)) & STD_LOGIC'image(Num(2)) &  STD_LOGIC'image(Num(1)) &  STD_LOGIC'image(Num(0))  --- sau INTEGER'image (to_ineger(unsigned(Num))) &
                             & " la time t=" & TIME'image(now) 
                             severity ERROR;
                     NrErori := NrErori +1;
                end if;                
                wait for CLK_PERIOD;
                RezCorect := RezCorect + 1;
             end loop;
             
             if ( NrErori = 0) then
                report "Simularea s-a terminat fara nicio eroare" severity NOTE; 
             else
                report "Simularea s-a terminat cu " & INTEGER'image(NrErori) & " erori" severity WARNING ;
             end if;
          wait; 
          end process sim_proc;

end simulare;
