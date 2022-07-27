----------------------------------------------------------------------------------
-- Company: UTCN
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity detect is
    Port( CLK: in STD_LOGIC;
            X: in STD_LOGIC;
            Z: out STD_LOGIC);
end detect;

architecture automat_stare of detect is
    type TIP_STARE is (A, B, C, D);
    signal Stare: TIP_STARE;
begin
    tranz_stare: process(CLK)
    begin
       if rising_edge(CLK) then
         case Stare is
            when A => 
               if (X = '1') then Stare <= B; end if;
            when B => 
               if (X = '0') then Stare <= C; end if;
            when C => 
               if (X = '0') then Stare <= A;
               else Stare <= D; end if;
            when D => 
               if (X = '0') then Stare <= C;
               else Stare <= B; end if;
         end case;
        end if;
   end process tranz_stare;
   
   Z <= '1' when Stare = D else '0';
end automat_stare;
   
     
            
            

