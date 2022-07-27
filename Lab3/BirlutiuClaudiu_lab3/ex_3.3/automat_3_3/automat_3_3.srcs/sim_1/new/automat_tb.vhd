----------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei 
--UTCN Cti-ro
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED;

entity automat_tb is
end automat_tb;

architecture Behavioral of automat_tb is
    --declararea semnalelor
     signal clk  :  STD_LOGIC:='1';
     signal rst  :  STD_LOGIC:='0';
     signal frame:  STD_LOGIC:='0';
     signal hit  :  STD_LOGIC:='0';
     signal oe   :  STD_LOGIC:='0';
     signal go   :  STD_LOGIC:='0';
     signal act  :  STD_LOGIC:='0';
    
     
    --constanta pentru perioada de ceas
    constant CLK_PERIOD: TIME:=10 ns;
    --declararea iesirilor pentru starile corespunzatoar
    constant idle_value :   STD_LOGIC_VECTOR(2 downto 0):="000";
    constant decode_value : STD_LOGIC_VECTOR(2 downto 0):="000";
    constant busy_value :   STD_LOGIC_VECTOR(2 downto 0):="001";
    constant xfer1_value:   STD_LOGIC_VECTOR(2 downto 0):="111";
    constant xfer2_value:   STD_LOGIC_VECTOR(2 downto 0):="101";
    
begin
    --generarea semnalului de ceas
    generate_clk: process
    begin 
        clk <='0';
        wait for CLK_PERIOD/2;
        clk <='1';
        wait for CLK_PERIOD/2;
     end process generate_clk;
    
    --maparea entitatii de testat
    DUT: entity Work.automat PORT MAP (
           clk =>clk,
           rst =>rst,
           frame => frame,
           hit   => hit,
           oe    => oe, 
           go     => go,
           act    => act);
          
   --generarea unor cazuri
   --ideea simularii consta in parcurgerea celor doua ramuri ale automaturlui de stare
   -- traseul: idle -> idle -> decode -> xfer1-> xfer1 ->xfer2 ->idle ->decode -> busy -> busy -> idle ->idle...
   gen: process
        variable nbErr:  INTEGER:=0;
   begin 
        rst <= '1' ;
        wait for 10 ns;
        if not  (oe & go & act)=idle_value then
            report "GRESIT" severity ERROR;   --idle
            nbErr := nbErr + 1;
        end if;
        
        rst <= '0';
        frame <= '0';
        wait for 15 ns;
        if not (oe & go & act)=idle_value then
            report "GRESIT" severity ERROR;      --idle
            nbErr := nbErr + 1;
        end if;
        
        frame <= '1';
        wait for 10 ns;
        if not (oe & go & act)=decode_value then 
          report "GRESIT" severity ERROR;  --decode
          nbErr := nbErr + 1; 
        end if; 
        
        hit <= '1';
        wait for 10 ns;
        if not (oe & go & act)=xfer1_value then
            report "GRESIT" severity ERROR;  --xfer1
            nbErr := nbErr + 1;
        end if;
        
        frame <= '0';
        wait for 10 ns; 
        if not (oe & go & act)=xfer1_value then 
            report "GRESIT" severity ERROR;   --xfer1
            nbErr := nbErr + 1;
        end if;
        
        frame <= '1';
        wait for 10 ns;   
        if not (oe & go & act)=xfer2_value then
            report "GRESIT" severity ERROR;   --xfer2
            nbErr := nbErr + 1;
        end if;
        
        wait for 10 ns;
        if not (oe & go & act)=idle_value then
            report "GRESIT" severity ERROR;   --idle
            nbErr := nbErr + 1;
        end if;
        
        wait for 10 ns;
        if not (oe & go & act)=decode_value then
             report "GRESIT" severity ERROR;   --decode
             nbErr := nbErr + 1;
        end if;
       
        hit <='0';
        wait for 10 ns;
        if not (oe & go & act)=busy_value then
            report "GRESIT" severity ERROR;   --busy
             nbErr := nbErr + 1;
        end if;
        frame <= '0';
        wait for 10 ns;
        if not (oe='0' and go='0' and act='1') then
            report "GRESIT" severity ERROR;   --busy
            nbErr := nbErr + 1;
        end if;
        frame <='1';
        wait for 10 ns;
        if not (oe & go & act)=busy_value then
            report "GRESIT" severity ERROR;   --idle
            nbErr := nbErr + 1;
        end if;
        
        if nbErr =0 then 
            report "Nicio eroare" severity NOTE;
        else 
            report INTEGER'image(nbErr) & " erori " severity FAILURE;
        end if;
        
        rst <='1';
        wait;
        
   end process;

end Behavioral;
