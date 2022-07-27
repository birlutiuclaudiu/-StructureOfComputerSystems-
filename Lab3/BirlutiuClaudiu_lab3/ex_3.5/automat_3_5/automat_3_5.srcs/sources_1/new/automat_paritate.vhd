----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
--UTCN CTI -ro
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity automat_paritate is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           sync: in STD_LOGIC;
           data: in STD_LOGIC;
           perror:out STD_LOGIC);
end automat_paritate;
  
architecture Behavioral of automat_paritate is
    --declarea tipului stare
    type TIP_STARE is (idle, start, par0, impar0, par1, impar1, par2, impar2, par3, impar3,
                        par4, impar4, par5, impar5, par6, impar6, par7, impar7);
    signal stare     : TIP_STARE:=idle;
    signal stare_urm : TIP_STARE:=idle;
    
begin
    -- determine the next state
    next_state_proc: process(stare, data, sync)
    begin 
        case stare is 
            when idle => 
                if sync ='0' then
                    stare_urm <= start;
                else 
                    stare_urm <= idle;
                end if;
            when start => 
                   if data ='1' then
                        stare_urm <= impar0;
                   else 
                        stare_urm <= par0;
                   end  if;
            when par0 => 
                    if data = '1' then
                        stare_urm <= impar1; 
                    else 
                        stare_urm <= par1;
                    end if;
            when impar0 => 
                    if data ='1' then 
                        stare_urm <= par1;
                    else 
                        stare_urm <= impar1;
                    end if;
            when par1 => 
                    if data ='1' then 
                        stare_urm <= impar2;
                    else 
                        stare_urm <= par2;
                    end if;
            when impar1 => 
                    if data ='1' then 
                        stare_urm <= par2;
                    else 
                        stare_urm <= impar2;
                    end if;
           when par2 => 
                    if data ='1' then 
                        stare_urm <= impar3;
                    else 
                        stare_urm <= par3;
                    end if;
            when impar2 => 
                    if data ='1' then 
                        stare_urm <= par3;
                    else 
                        stare_urm <= impar3;
                    end if;
                    
            when par3 => 
                    if data ='1' then 
                        stare_urm <= impar4;
                    else 
                        stare_urm <= par4;
                    end if;
            when impar3 => 
                    if data ='1' then 
                        stare_urm <= par4;
                    else 
                        stare_urm <= impar4;
                    end if;
            when par4 => 
                    if data ='1' then 
                        stare_urm <= impar5;
                    else 
                        stare_urm <= par5;
                    end if;
            when impar4 => 
                    if data ='1' then 
                        stare_urm <= par5;
                    else 
                        stare_urm <= impar5;
                    end if;       
            when par5 => 
                    if data ='1' then 
                        stare_urm <= impar6;
                    else 
                        stare_urm <= par6;
                    end if;       
            when impar5 => 
                    if data ='1' then 
                        stare_urm <= par6;
                    else 
                        stare_urm <= impar6;
                    end if;       
             when par6 => 
                    if data ='1' then 
                        stare_urm <= impar7;
                    else 
                        stare_urm <= par7;
                    end if;       
            when impar6 => 
                    if data ='1' then 
                        stare_urm <= par7;
                    else 
                        stare_urm <= impar7;
                    end if;       
             when par7 => 
                    stare_urm <= idle;
            when impar7 => 
                    stare_urm <= idle;  
            end case;
    end process next_state_proc;
    
    
    --update state register
    state_reg: process(clk, rst)
    begin 
        if rst = '1' then        --asynchronous reset
            stare <= idle;
        elsif rising_edge(clk) then 
            stare <= stare_urm;
        else 
            stare <= stare;
        end if;
    end process state_reg;
    
    
    --detemnine the output 
    generate_output: process(stare)
        variable perrorSignal : STD_LOGIC:='0';
    begin 
        case stare is 
            when par7   => perrorSignal := '0';
            when impar7 => perrorSignal := '1';
            when start  => perrorSignal := '0';
            when others => perrorSignal := perrorSignal;
        end case; 
       perror <= perrorSignal;
    end process generate_output; 

end Behavioral;
