
------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--UTC CTI-ro 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity contr_mem is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ready : in STD_LOGIC;
           rw : in STD_LOGIC;
           oe : out STD_LOGIC;
           we : out STD_LOGIC);
end contr_mem;

architecture Behavioral of contr_mem is
    
    type TIP_STARE is (idle, decision, read, write);
    signal stare: TIP_STARE:= idle;

begin
    proc1: process(clk)
    begin 
        if rising_edge(clk) then 
            if (rst='1') then 
                stare <= idle;
            else 
                case stare is
                    when idle => 
                        if (ready='1') then 
                            stare <= decision; 
                        else 
                            stare <= idle; 
                        end if;
                     when decision => 
                         if (rw ='0') then 
                            stare <= write; 
                         else
                            stare <= read;
                         end if;
                     when read => 
                          if (ready ='1') then 
                            stare <= idle;
                          else
                             stare <= read; 
                          end if;
                     when write => 
                          if (ready ='1') then 
                            stare <= idle;
                          else
                             stare <= write; 
                          end if;
                  end case; 
               end if;
            end if;
       end process proc1;    
      
      --se determeina iesirile in functie de satrea curenta
      --automat de tip Moore
      proc2: process(stare)
        begin 
            case stare is
                when idle     => oe <= '0'; we <='0';
                when decision => oe <= '0'; we <='0';
                when read     => oe <= '1'; we <='0';
                when write    => oe <= '0'; we <='1';       
             end case;
      end process proc2;

end Behavioral;
