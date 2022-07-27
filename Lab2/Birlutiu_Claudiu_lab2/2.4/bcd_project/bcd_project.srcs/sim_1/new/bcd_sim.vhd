----------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--Project: hex to bcd 
--Simulation
---------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--fara porturi I/O
entity bcd_sim is
end bcd_sim;

architecture bcd_simulation of bcd_sim is
     --declarare semnale interne pentru mapare
     signal  data_in:   STD_LOGIC_VECTOR (3 downto 0):=(others=>'0'); 
     signal  bcd1   :   STD_LOGIC_VECTOR (3 downto 0):=(others=>'0'); 
     signal  bcd0   :   STD_LOGIC_VECTOR (3 downto 0):=(others=>'0'); 
     
begin
   
   DUT: entity WORK.b_bcd PORT MAP( data_in=>data_in, 
                        bcd1 => bcd1,
                        bcd0 => bcd0);
   
   sim_proc: process
      variable NbErrors: INTEGER:=0;   --varibila pentru numarul de erori  
      
    begin
        wait for 10 ns;
        for i in 0 to 15 loop
         case data_in is 
              when x"0" => if(bcd1 /="0000" or bcd0 /="0000") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0000 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"1" => if(bcd1 /="0000" or bcd0 /="0001") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0001 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"2" => if(bcd1 /="0000" or bcd0 /="0010") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0010 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"3" => if(bcd1 /="0000" or bcd0 /="0011") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0011 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
                             
               when x"4" => if(bcd1 /="0000" or bcd0 /="0100") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0100 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"5" => if(bcd1 /="0000" or bcd0 /="0101") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0101 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"6" => if(bcd1 /="0000" or bcd0 /="0110") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0110 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"7" => if(bcd1 /="0000" or bcd0 /="0111") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 0111 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"8" => if(bcd1 /="0000" or bcd0 /="1000") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 1000 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"9" => if(bcd1 /="0000" or bcd0 /="1001") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0000 1001 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"A" => if(bcd1 /="0001" or bcd0 /="0000") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0001 0000 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"B" => if(bcd1 /="0001" or bcd0 /="0001") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0001 0001 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"C" => if(bcd1 /="0001" or bcd0 /="0010") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0001 0010 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"D" => if(bcd1 /="0001" or bcd0 /="0011") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0001 0011 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"E" => if(bcd1 /="0001" or bcd0 /="0100") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0001 0100 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when x"F" => if(bcd1 /="0001" or bcd0 /="0101") then
                                         NbErrors:=NbErrors+1;
                                         report "Valoare asteptata 0001 0101 Valoare obtinuta: " & STD_LOGIC'image (bcd1(3)) & STD_LOGIC'image (bcd1(2)) & STD_LOGIC'image (bcd1(1)) & STD_LOGIC'image (bcd1(0)) & "  " &
                                               STD_LOGIC'image (bcd0(3)) & STD_LOGIC'image (bcd0(2)) & STD_LOGIC'image (bcd0(1)) & STD_LOGIC'image (bcd0(0)) severity ERROR;
                             end if;
               when others => NbErrors := NbErrors+1;
            end case;
            wait for 10 ns;
            data_in <= data_in +1;
        end loop;
        report "TOTAL ERRORS " & INTEGER'image(NbErrors) severity WARNING;
        wait;
    end process sim_proc;
    

end bcd_simulation;
