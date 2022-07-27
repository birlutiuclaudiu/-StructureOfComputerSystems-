----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Unitate comanda impartitor
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity fsm_cmd is
    generic (n: INTEGER:=8);   --nr pasi 
    Port ( clk :    in STD_LOGIC;
           rst :    in STD_LOGIC;
           start :  in STD_LOGIC;
           an:      in STD_LOGIC;
           term :    out STD_LOGIC;
           loadB :   out STD_LOGIC;
           subB :    out STD_LOGIC;
           loadA :   out STD_LOGIC;
           shlA_Q :  out STD_LOGIC;
           loadQ :   out STD_LOGIC;
           updateQ:  out STD_LOGIC;
           loadX:    out STD_LOGIC
             );
end fsm_cmd;

architecture Behavioral of fsm_cmd is
    type STATE_TYPE is (startState, init, shiftState,subState, condA, addState, decC,condC, stop);
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
                        state <= shiftState;

                    when shiftState => 
                        state <= substate;
                    
                    when substate =>
                        state<=condA;
                        
                    when condA =>
                        if an ='1' then 
                            state<= addState;
                        else 
                            state<=decC;
                        end if;
                    
                    when addState => 
                        state <= decC;

                    when decC => 
                        C <= C - 1; 
                        state <= condC;
                    
                    when condC => 
                        if C=0 then 
                            term<='1';
                            state <= stop;
                        else 
                            state <= shiftState;
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
       
           loadB <='0'; subB <='0'; loadA <='0'; shlA_Q <='0'; loadQ<='0'; updateQ<='0'; loadX <='0';
        case state is
            when init        => loadB <='1';    loadA <='1';     loadQ <='1'; loadX <='1';
            when subState    => subB <='1';     loadA <='1';  
            when addState    => loadA <='1';    
            when shiftState  => shlA_Q <='1';   
            when condA       => updateQ <='1'; loadQ<='1';
            when others => null;
        end case;
    end process gen_outputs;
   
end Behavioral;
