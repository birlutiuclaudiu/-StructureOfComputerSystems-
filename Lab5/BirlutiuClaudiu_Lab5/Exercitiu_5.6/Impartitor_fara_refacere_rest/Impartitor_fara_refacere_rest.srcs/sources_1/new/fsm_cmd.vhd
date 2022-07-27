----------------------------------------------------------------------------------
-- Birlutiu Claudiu 
-- UTCN CTI -ro 
-- Project: Booth
-- Unitate comanda impartitor fara refacerea restului
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
    type STATE_TYPE is (startState, init, shiftState, subState, addState1, updateQBS_decC, condC, addstate2, stop);
    signal state : STATE_TYPE:=startState;
    --counter pentru nr  de pasi
    signal C: INTEGER range 0 to n:=0;
    signal BS : STD_LOGIC:='0';
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
                        BS <='0';
                        state <= shiftState;

                    when shiftState => 
                        if BS='0' then 
                             state <= substate;
                        else 
                             state <= addState1;
                        end if;
                    
                    when substate =>
                        state <= updateQBS_decC;
                    when addstate1 =>
                        state <= updateQBS_decC;
                        
                    when updateQBS_decC =>     --am combinat mai multe stari din organigrama intr-una singura
                        BS <= an;
                        C  <= C-1;
                        state <= condC;
                    
                    when condC => 
                        if C=0 then 
                            if BS='1' then 
                                state  <= addState2;
                            else 
                                term<='1';
                                state <= stop;
                            end if;
                        else 
                            state <= shiftState;
                        end if;
                        
                    when addState2 => 
                        term <='1';
                        state <= stop;
                        
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
            when init             => loadB <='1';    loadA <='1';     loadQ <='1'; loadX <='1'; 
            when subState         => subB <='1';     loadA <='1';  
            when addState1        => loadA <='1'; 
            when addState2        => loadA <='1';   
            when shiftState       => shlA_Q <='1';   
            when updateQBS_decC   => updateQ <='1'; loadQ<='1';
            when others => null;
        end case;
    end process gen_outputs;
   
end Behavioral;
