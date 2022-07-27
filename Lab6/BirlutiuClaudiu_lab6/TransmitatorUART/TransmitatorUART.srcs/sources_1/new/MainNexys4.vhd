----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Bilrutiu Claudiu-Andrei
-- UTCN CTI- ro
-- Modu principal UART
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity MainNexys4 is
    Port ( Clk : in STD_LOGIC;
           Rst : in STD_LOGIC;
           Start : in STD_LOGIC;
           Tx : out STD_LOGIC;
           TxRdy : out STD_LOGIC);
end MainNexys4;

architecture Behavioral of MainNexys4 is
   
    --semnal de debounce
    signal StartRead: std_logic:='0';
    
    --semnal pentru datele ce vor fi incarcate in registru TSR
    signal TxData: std_logic_vector(7 downto 0):=(others=>'0');
    
    --semnale interne pentru TX si TxRdy
    signal Tx_reg :     STD_LOGIC:='1';
    signal TxRdy_reg :  STD_LOGIC:='0';

begin

    monopulse_generator: entity work.mpg port map (
        clk => clk, 
        btn => Start,
        enable => StartRead
    
    );
    
    modul_uart: entity work.ModulUART port map (
          Clk   => Clk,
          Rst   => Rst,
          Start => StartRead,
          Tx     => Tx_reg, 
          TxData  => TxData,
          TxRdy =>TxRdy_reg
        );
    
    Tx <= Tx_reg;
    TxRdy <= TxRdy_reg;
    
  depanareVIO : entity work.vio_0
  PORT MAP (
    clk => clk,
    probe_in0 => Tx_reg & TxRdy_reg,
    probe_out0 => TxData
  );
    
end Behavioral;
