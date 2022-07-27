----------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity automat is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           frame: in STD_LOGIC;
           hit  : in STD_LOGIC;
           oe  : out STD_LOGIC;
           go  : out STD_LOGIC;
           act : out STD_LOGIC);
end automat;

architecture Behavioral of automat is
    --definirea tipului de stare
    type TIP_STARE is (idle, decode, busy, xfer1, xfer2);
    signal stare: TIP_STARE:=idle;
    
begin

    proc1: process(clk)
        begin 
            if rising_edge(clk) then 
                if rst='1' then                  --reset sincron
                    stare <= idle;
                else
                    case stare is
                        when idle => 
                            if frame = '1' then 
                                stare <= decode;
                            else 
                                stare <= idle;    --nu e necesar, dar il pun pentru definirea corecta a mux-ului
                            end if;
                        when decode => 
                            if hit='0' then 
                                stare <= busy;
                            else 
                                stare <= xfer1;
                            end if;
                        when xfer1 => 
                             if frame='1' then 
                                stare <= xfer2;
                             else
                                stare <= xfer1;
                             end if;
                        when xfer2 =>
                            stare <= idle;
                        when busy => 
                            if frame='1' then 
                                stare <= idle;
                            else
                                stare <= busy;
                            end if; 
                    end case;
                end if;
            end if;
    end process proc1;
    
    
    --automat de tip MOORE
    proc2: process(stare)
    begin 
        case stare is
            when idle   => oe <='0'; go<='0'; act <='0';
            when decode => oe <='0'; go<='0'; act <='0';
            when busy   => oe <='0'; go<='0'; act <='1';
            when xfer1  => oe <='1'; go<='1'; act <='1';
            when xfer2  => oe <='1'; go<='0'; act <='1';
        end case;
    end process proc2;

end Behavioral;
