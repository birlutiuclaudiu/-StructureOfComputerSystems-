
------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--UTC CTI-ro 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contr_mem_proc3 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ready : in STD_LOGIC;
           rw : in STD_LOGIC;
           oe : out STD_LOGIC;
           we : out STD_LOGIC);
end contr_mem_proc3;

architecture Behavioral of contr_mem_proc3 is
    
    type TIP_STARE is (idle, decision, read, write);
    signal starePrez: TIP_STARE:= idle;
    signal stareUrm: TIP_STARE:=idle;

begin
    proc1: process(starePrez, ready, rw, rst)
    begin
        if (rst='1') then 
            stareUrm <= idle;
        else 
            case starePrez is
                when idle => 
                    if (ready='1') then 
                        stareUrm<= decision; 
                    else 
                        stareUrm <= idle; 
                    end if;
                 when decision => 
                     if (rw ='0') then 
                        stareUrm <= write; 
                     else
                        stareUrm <= read;
                     end if;
                 when read => 
                      if (ready ='1') then 
                        stareUrm <= idle;
                      else
                         stareUrm <= read; 
                      end if;
                 when write => 
                      if (ready ='1') then 
                        stareUrm <= idle;
                      else
                         stareUrm <= write; 
                      end if;
              end case; 
          end if;
       end process proc1;    
      
      proc2: process(clk) 
             begin 
                if rising_edge(clk) then 
                    starePrez <= stareUrm;
                end if; 
       end process proc2;
       
      --se determeina iesirile in functie de satrea curenta
      --automat de tip Moore
      proc3: process(starePrez)
        begin 
            case starePrez is
                when idle     => oe <= '0'; we <='0';
                when decision => oe <= '0'; we <='0';
                when read     => oe <= '1'; we <='0';
                when write    => oe <= '0'; we <='1';       
             end case;
      end process proc3;

end Behavioral;
