----------------------------------------------------------------------------------
--Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Automat detectie secventa de biti
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity automat_detect is
    Port ( clk :     in STD_LOGIC;
           rst :     in STD_LOGIC;
           b:        in STD_LOGIC;
           detect:   out STD_LOGIC);
end automat_detect;
   
architecture Behavioral of automat_detect is
    type STATE_TYPE is (start, first1, second1, third1, fourth0, fifth1, sixth0, 
                            seventh1, eighth1);
    signal state : STATE_TYPE:=start;
begin
    
    state_register: process(clk, rst)
    begin
        if rst='1' then 
            state <= start;
        elsif rising_edge(clk) then 
            case state is
                when start => 
                    if b ='1' then 
                        state <= first1;
                    else 
                        state <= start;
                    end if;
                when first1 => 
                    if b='1' then 
                        state <= second1;
                    else 
                        state <= start;
                    end if;
                when second1 => 
                    if b='1' then 
                        state <= third1;
                    else 
                        state <= start;
                    end if;
                when third1 => 
                    if b='1' then 
                        state <= third1; 
                    else
                        state <= fourth0;
                    end if;
                when fourth0 => 
                    if b='1' then 
                        state <= fifth1; 
                    else 
                        state <= start;
                    end if;
                when fifth1 => 
                    if b='0' then 
                        state <= sixth0;
                    else 
                        state <= second1;
                    end if;
                when sixth0 => 
                    if b='1' then 
                        state <= seventh1; 
                    else 
                        state <= start; 
                    end if;
                when seventh1 => 
                    if b='1' then 
                        state <= eighth1; 
                    else 
                        state <= start;
                    end if;
                when eighth1 => 
                    if b='1' then 
                        state <= third1; 
                    else 
                        state <= start;
                    end if;
            end case;
        end if;
    end process state_register;

    gen_output: process(state)
    begin 
        if state = eighth1 then 
            detect <='1';
        else 
            detect <='0';
        end if;
    end process gen_output;
end Behavioral;
