
------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--UTC CTI-ro 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity automat_mem_opt is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           ready : in STD_LOGIC;
           rw : in STD_LOGIC;
           oe : out STD_LOGIC;
           we : out STD_LOGIC);
end automat_mem_opt;

architecture Behavioral of automat_mem_opt is
    
    signal stare:      STD_LOGIC_VECTOR(2 downto 0);
    constant idle:     STD_LOGIC_VECTOR(2 downto 0):="000";
    constant decision: STD_LOGIC_VECTOR(2 downto 0):="001";
    constant read:     STD_LOGIC_VECTOR(2 downto 0):="100";
    constant write:    STD_LOGIC_VECTOR(2 downto 0):="010";
    

begin
    tranz_st: process(clk)
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
                      when others => stare<= idle;
                  end case; 
               end if;
            end if;
       end process tranz_st;    
      
      we <= stare(1);
      oe <= stare(2);

end Behavioral;
