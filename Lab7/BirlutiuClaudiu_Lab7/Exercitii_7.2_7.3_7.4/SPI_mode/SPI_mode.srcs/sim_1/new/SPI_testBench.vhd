library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity SPI_Interface_tb is
end;

architecture bench of SPI_Interface_tb is

  component SPI_Interface
    generic (
      freqClkOut : INTEGER;
      freqClkIn : INTEGER;
      wordDim : INTEGER
    );
      port (
      clk : in STD_LOGIC;
      TxData : in STD_LOGIC_VECTOR (wordDim-1 downto 0);
      Start : in STD_LOGIC;
      Rst : in STD_LOGIC;
      MISO : in STD_LOGIC;
      MOSI : out STD_LOGIC;
      SCK : out STD_LOGIC;
      CS : out STD_LOGIC;
      TxRdy : out STD_LOGIC;
      RxRdy : out STD_LOGIC;
      RxData : out STD_LOGIC_VECTOR(wordDim-1 downto 0)
    );
  end component;

  -- Clock period
  constant clk_period : time := 10 ns;
  -- Generics
  constant freqClkOut : INTEGER := 5_000_000;
  constant freqClkIn : INTEGER := 100_000_000;
  constant wordDim : INTEGER := 8;

  -- Ports
  signal clk : STD_LOGIC;
  signal TxData : STD_LOGIC_VECTOR (wordDim-1 downto 0);
  signal Start : STD_LOGIC;
  signal Rst : STD_LOGIC;
  signal MISO : STD_LOGIC;
  signal MOSI : STD_LOGIC;
  signal SCK : STD_LOGIC;
  signal CS : STD_LOGIC;
  signal TxRdy : STD_LOGIC;
  signal RxRdy : STD_LOGIC;
  signal RxData : STD_LOGIC_VECTOR(wordDim-1 downto 0);

begin

  SPI_Interface_inst : SPI_Interface
    generic map (
      freqClkOut => freqClkOut,
      freqClkIn => freqClkIn,
      wordDim => wordDim
    )
    port map (
      clk => clk,
      TxData => TxData,
      Start => Start,
      Rst => Rst,
      MISO => MISO,
      MOSI => MOSI,
      SCK => SCK,
      CS => CS,
      TxRdy => TxRdy,
      RxRdy => RxRdy,
      RxData => RxData
    );

   clk_process : process
   begin
    clk <= '1';
    wait for clk_period/2;
    clk <= '0';
    wait for clk_period/2;
     end process clk_process;

end;
