----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN Cti-ro
--Controller memorie
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity controller_memorie is
    Port ( clk   : in STD_LOGIC;
           rst   : in STD_LOGIC;
           busId : in STD_LOGIC_VECTOR (7 downto 0);
           rw    : in STD_LOGIC;
           burst : in STD_LOGIC;
           ready : in STD_LOGIC;
           oe    : out STD_LOGIC;
           we    : out STD_LOGIC;
           adr   : out STD_LOGIC_VECTOR(1 downto 0));
end controller_memorie;

architecture Behavioral of controller_memorie is
    --declarea tip enumerat pentru stare
    type STATE_TYPE is (idle, decision, write, read1, read2, read3, read4);
    --declarare semnal pentru registrul de stare
    signal state: STATE_TYPE:= idle;
    
begin

    state_register: process( clk) 
    begin 
        if rising_edge(clk) then 
            if rst='1' then 
                state <= idle;
            else 
                case state is 
                   when idle => 
                        if busId =x"A5" then 
                            state <= decision; 
                        else 
                            state <= idle;
                        end if;
                        
                   when decision => 
                        if rw = '0' then 
                            state <= write;
                        else  
                            state <= read1;
                        end if;
                        
                   when write => 
                        if ready ='1' then 
                            state <= idle;
                        else 
                            state <= write;
                        end if;
                        
                   when read1 => 
                        if ready='1' and burst ='0' then 
                            state <= idle;
                        elsif ready='1' and burst ='1' then 
                            state <= read2;     --else o sa ramana in starea read1
                        end if;
                        
                   when read2 =>
                        if ready ='1' then 
                            state <= read3;      --else o sa ramana in starea read2
                        end if;
                        
                   when read3 => 
                        if ready='1' then 
                            state <= read4; 
                        end if;
                        
                   when read4 => 
                        if ready ='1' then 
                            state <=idle;         --else o sa ramana in starea read3
                        end if;
                   when others=> state <= idle;  --tratatare toleranta                        
                end case;
            end if;
        end if;
    end process state_register;
    
    --process care creeaza circuitul combinational pentru 
    gen_outputs: process(state)
    begin
        case state is 
            when idle     => oe <='0'; we<='0'; adr<="00";
            when decision => oe <='0'; we<='0'; adr<="00";
            when read1    => oe <='1'; we<='0'; adr<="00";
            when read2    => oe <='1'; we<='0'; adr<="01";
            when read3    => oe <='1'; we<='0'; adr<="10";
            when read4    => oe <='1'; we<='0'; adr<="11";
            when write    => oe <='0'; we<='1'; adr<="00";
        end case;
    end process;
end Behavioral;
