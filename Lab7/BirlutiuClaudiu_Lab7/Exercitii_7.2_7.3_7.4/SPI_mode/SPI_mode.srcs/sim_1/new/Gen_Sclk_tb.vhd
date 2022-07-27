----------------------------------------------------------------------------------
-- Birutiu Claudiu-Andrei
-- UTCN - cti 
-- Divizor frecventa
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Gen_Sclk_tb is
end;

architecture bench of Gen_Sclk_tb is

  component Gen_Sclk
      port (
      clk : in STD_LOGIC;
      SCK : out STD_LOGIC;
      CE_n : out STD_LOGIC;
      CE_p : out STD_LOGIC
    );
  end component;

  -- Clock period
  constant clk_period : time := 10 ns;
  -- Generics

  -- Ports
  signal clk : STD_LOGIC:='1';
  signal SCK : STD_LOGIC:='0';
  signal CE_n : STD_LOGIC:='0';
  signal CE_p : STD_LOGIC:='0';

begin

  Gen_Sclk_inst : Gen_Sclk
    port map (
      clk => clk,
      SCK => SCK,
      CE_n => CE_n,
      CE_p => CE_p
    );

   clk_process : process
   begin
         clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
     end process clk_process;

end;
