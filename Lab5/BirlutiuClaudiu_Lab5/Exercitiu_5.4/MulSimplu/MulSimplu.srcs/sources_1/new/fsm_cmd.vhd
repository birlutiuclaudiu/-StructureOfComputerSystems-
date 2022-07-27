----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI-ro
-- Unitate de control inmultitor simplu
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity fsm_cmd is
    generic ( n : INTEGER:=8);
    Port ( clk :     in STD_LOGIC;
           rst :     in STD_LOGIC;
           start :   in STD_LOGIC;
           q0 :      in STD_LOGIC;
           term :   out STD_LOGIC;
           rstA :   out STD_LOGIC;
           loadA :  out STD_LOGIC;
           loadQ :  out STD_LOGIC;
           loadB :  out STD_LOGIC;
           shrAQ :  out STD_LOGIC
           );
end fsm_cmd;

architecture Behavioral of fsm_cmd is
    
 type STATE_TYPE is (startState, init, condQQ, addState, shiftState, condC, stop);
    signal state : STATE_TYPE:=startState;
    --counter pentru nr  de pasi
    signal C: INTEGER range 0 to n:=0;
   
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
                            term<='0';
                        else 
                            state <= startState;
                        end if;

                    when init => 
                        C <=n;
                        state <= condQQ;

                    when condQQ => 
                        if q0 = '1' then 
                            state <= addState;
                        else 
                            state <= shiftState;
                        end if;
                    
                    when addState =>
                        state <= shiftState;

                    when shiftState => 
                        C <= C - 1; 
                        state <= condC;
                    
                    when condC => 
                        if C=0 then 
                            state <= stop;
                            term <='1';
                        else 
                            state <= condQQ;
                        end if;
                    when stop => 
                        state <= startState;
                end case;
            end if;
        end if;
    end process gen_next_state;

            
    
    gen_outputs: process(state)
    begin
        --semnalele vor lua ultima valoare asignata deoarece e un proces
       rstA<='0';  shrAQ<='0'; loadA<='0'; loadB<='0'; loadQ<='0'; 
       case state is
            when init     =>  rstA<='1'; loadB <='1'; loadQ <='1'; 
            when addState =>  loadA<='1';
            when shiftState => shrAQ<='1'; 
            when others=> null;
       end case; 
    end process gen_outputs;
   
end Behavioral;
