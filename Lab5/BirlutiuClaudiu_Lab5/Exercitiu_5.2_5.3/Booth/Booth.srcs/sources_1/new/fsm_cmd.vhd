----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Unitate comanda inmultitor
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fsm_cmd is
    generic (n: INTEGER:=8);   --nr pasi 
    Port ( clk :    in STD_LOGIC;
           rst :    in STD_LOGIC;
           start :  in STD_LOGIC;
           q0 :     in STD_LOGIC;
           q_1 :    in STD_LOGIC;
           term :    out STD_LOGIC;
           loadB :   out STD_LOGIC;
           subB :    out STD_LOGIC;
           rstA :    out STD_LOGIC;
           loadA :   out STD_LOGIC;
           shrA_Q :  out STD_LOGIC;
           loadQ :   out STD_LOGIC;
           rstQ_1 :  out STD_LOGIC);
end fsm_cmd;

architecture Behavioral of fsm_cmd is
    type STATE_TYPE is (startState, init, condQQ, addState, subState, shiftState, condC, stop);
    signal state : STATE_TYPE:=startState;
    --counter pentru nr  de pasi
    signal C: INTEGER range 0 to n:=0;
    signal termp : STD_LOGIC:='0';
begin

    gen_next_state: process(clk)
    begin   
        if rising_edge(clk) then 
            if rst = '1' then 
                term<='0';
                state <= startState;
            else 
                case state is
                    when startState => 
                        if start = '1' then 
                            state <= init;
                        else 
                            state <= startState;
                        end if;

                    when init => 
                        term<='0';
                        C <=n;
                        state <= condQQ;

                    when condQQ => 
                        if ((q0='0' and  q_1 = '0') or (q0='1' and q_1='1')) then 
                            state <= shiftState;
                        elsif  q0='0' and  q_1 = '1' then 
                            state <= addState;
                        elsif q0='1' and q_1 = '0' then 
                            state <= subState;
                        else 
                            state <= condQQ;
                        end if;
                    
                    when addState =>
                        state <= shiftState;
                    
                    when subState => 
                        state <= shiftState;

                    when shiftState => 
                        C <= C - 1; 
                        state <= condC;
                    
                    when condC => 
                        if C=0 then 
                            state <= stop;
                        else 
                            state <= condQQ;
                        end if;
                    when stop => 
                        term <='1';
                        state <= startState;
                end case;
            end if;
        end if;
    end process gen_next_state;

            
    
    gen_outputs: process(state)
    begin
        --semnalele vor lua ultima valoare asignata deoarece e un proces
        loadB <='0'; subB <='0'; rstA <= '0'; loadA <= '0'; shrA_Q <='0'; loadQ <='0'; rstQ_1 <= '0'; 
        case state is
            when init        => loadB <='1';    rstA <='1';     loadQ <='1';    rstQ_1 <='1'; 
            when subState    => subB <='1';     loadA <='1';  
            when addState    => loadA <='1';    
            when shiftState  => shrA_Q <='1';   
            when others => null;
        end case;
    end process gen_outputs;
   
end Behavioral;
