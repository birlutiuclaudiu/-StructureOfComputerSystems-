----------------------------------------------------------------------------------

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity summator_tb is
--  Port ( );
end summator_tb;

architecture Behavioral of summator_tb is
    signal x: STD_LOGIC:='0';
    signal y : STD_LOGIC:='0';
    signal tin : STD_LOGIC:='0';
    signal s : STD_LOGIC:='0';
    signal t : STD_LOGIC:='0';
begin
      dut: entity Work.sumator Port MAP(
           x =>x,
           y =>y,
           tin =>tin, 
           s => s,
           t =>t);

    gen_signals: process
        variable value: STD_LOGIC_VECTOR(2 downto 0):="000";
    begin 
        for i in 0 to 7 loop 
            x<= value(0);
            y<= value(1);
            tin <= value(2);
            wait for 10 ns;
            value := value+1;
        end loop;
       
       wait;
    end process;
end Behavioral;
