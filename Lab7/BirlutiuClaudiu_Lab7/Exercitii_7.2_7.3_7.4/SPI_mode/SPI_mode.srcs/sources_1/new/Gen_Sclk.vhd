----------------------------------------------------------------------------------
-- Birutiu Claudiu-Andrei
-- UTCN - cti 
-- Divizor frecventa
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_unsigned.all;

entity Gen_Sclk is
    generic( freqClkOut : INTEGER :=5_000_000;
             freqClkIn  : INTEGER :=100_000_000);
    Port ( clk : in STD_LOGIC;
           SCK : out STD_LOGIC;
           CE_n : out STD_LOGIC;
           CE_p : out STD_LOGIC);
end Gen_Sclk;

architecture Behavioral of Gen_Sclk is
    
    signal SCK_reg : STD_LOGIC:='0';
    signal counter : INTEGER:= 1;
    signal CE_n_reg : STD_LOGIC:='0';
    signal CE_p_reg : STD_LOGIC:='0';
    constant MAX_COUNTER : INTEGER:=freqClkIn/freqClkOut;
begin
    
    process(clk)
      
    begin 
        if rising_edge(clk) then 
            if counter = 250 then 
                SCK_reg <= not SCK_reg; 
                if SCK_reg = '1' then      --front descrescator SCK
                    CE_n_reg <= '1'; 
                else 
                    CE_p_reg <='1';        --front crescator SCK
                end if;
                counter <= 1;
            else 
                counter <= counter + 1;
                CE_n_reg <= '0'; 
                CE_p_reg <='0';
            end if;
        end if;
    end process;
    
    CE_n <= CE_n_reg;
    CE_P <= CE_P_reg;
    SCK <= SCK_reg;
end Behavioral;
