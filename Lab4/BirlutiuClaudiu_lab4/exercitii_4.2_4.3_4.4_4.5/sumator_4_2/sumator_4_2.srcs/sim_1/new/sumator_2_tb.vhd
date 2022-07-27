----------------------------------------------------------------------------------
--Birlutiu Claudiu-Andrei
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity sumator_2_tb is
--  Port ( );
end sumator_2_tb;

architecture Behavioral of sumator_2_tb is
     --declarea semnalelor
    signal x   : STD_LOGIC_VECTOR (1 downto 0):="00";
    signal y   : STD_LOGIC_VECTOR (1 downto 0):="00";
    signal tin : STD_LOGIC:='0';
    signal s   : STD_LOGIC_VECTOR(1 downto 0):="00";
    signal P: STD_LOGIC:='0';
    signal G: STD_LOGIC:='0';
    
begin
    DUT: entity Work.sumator_2 PORT MAP ( x  => x,
           y => y, 
           tin => tin,
           s => s,
           P => p, 
           G=> g);
   gen_signals: process
   begin 
        for i in 0 to 2**2 loop
            for j in 0 to 2**2 loop
                tin<='0';
                x <= CONV_STD_LOGIC_VECTOR(i, 2);
                y <= CONV_STD_LOGIC_VECTOR(j, 2);
                wait for 10 ns;
                tin<='1';
                x <= CONV_STD_LOGIC_VECTOR(i, 2);
                y <= CONV_STD_LOGIC_VECTOR(j, 2);
                wait for 10 ns;
            end loop;
        end loop;
        wait;
   end process;
end Behavioral;
