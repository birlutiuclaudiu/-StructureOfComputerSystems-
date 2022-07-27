----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei 
--Accelerometru

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Main_ADXL362 is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           read : in STD_LOGIC;
           MISO : in STD_LOGIC;
           sel  : in STD_LOGIC;
           MOSI : out STD_LOGIC;
           SCLK : out STD_LOGIC;
           SS : out STD_LOGIC;
           an   :  out STD_LOGIC_VECTOR (7 downto 0);
           seg  :  out STD_LOGIC_VECTOR (7 downto 0);
           TxRdy_out : out STD_LOGIC;
           RxRdy_out : out STD_LOGIC
           
           --Data1 : out STD_LOGIC_VECTOR (31 downto 0);
          -- Data2 : out STD_LOGIC_VECTOR (31 downto 0)
          );
end Main_ADXL362;

architecture Behavioral of Main_ADXL362 is

    signal byteCounter :INTEGER:=0;
    signal TxData : STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');
    
    signal TxRdy : STD_LOGIC:='1';
    signal RxRdy : STD_LOGIC:='0';
    signal RxData: STD_LOGIC_VECTOR(7 downto 0):=(others=>'0');
    signal Start : STD_LOGIC:='1';
    
    type STATE_ADXL is  (idle, loadTxData, activeStart, 
         w8TxRdy,writeAddress,activeStart2, w8Rxdy, activeData1,checkCounter);
    signal state :STATE_ADXL:=idle;
    
    signal saveSig: STD_LOGIC:='0';
    type REG_VECT is array(0 to 7) of STD_LOGIC_VECTOR(7 downto 0);
    signal registers : REG_VECT:=(others=>(others=>'0'));
    
    signal  Data1 :  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');
    signal  Data2 :  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');
    signal  DataToDisplay:  STD_LOGIC_VECTOR (31 downto 0):=(others=>'0');
    
    --debounce pentru read
    signal readD : STD_LOGIC:='1';
begin
    
    SPI: entity work.SPI_Interface
     generic map (
              freqClkOut  => 5_000_000,
              freqClkIn  => 100_000_000,
              wordDim   => 8)
     port map(
        clk => clk, 
        rst =>rst, 
        start =>Start, 
        MISO => MISO, 
        MOSI => MOSI, 
        SCK => SCLK, 
        CS => SS,
        TxData=> TxData, 
        RxRdy => RxRdy, 
        TxRdy => TxRdy,
        RxData => RxData
    );
    
    UC: process(clk)
    begin 
        if rising_edge(clk) then 
                case state is
                
                    when idle => 
                        byteCounter <= 0;
                        if readD ='1' then 
                             state <= loadTxData; 
                        else 
                            state <= idle;
                        end if;
                    
                    when loadTxData => 
                        state <= activeStart;
                    
                    when activeStart => 
                        state <= w8TxRdy;
                    
                    when w8TxRdy => 
                        if TxRdy = '1' then 
                            state <= writeAddress; 
                        else 
                            state <= w8TxRdy;
                        end if;
                   
                   when writeAddress => 
                        state <= activeStart2;
                   
                   when activeStart2 =>   
                        state <=  w8Rxdy;
                   
                   when w8Rxdy => 
                        if RxRdy ='1' then 
                            state <= activeData1; 
                        else
                            state <= w8Rxdy;
                        end if;                
                   when activeData1 => 
                        byteCounter<=byteCounter+1;
                        state<= checkCounter;
                   when checkCounter => 
                        if byteCounter = 8 then 
                            state <= idle;
                        else 
                            state <= w8TxRdy;
                        end if;         
                end case;
            end if;      
       
    end process;
    
 Start <= '1' when state=activeStart or state = activeStart2 else '0';
 saveSig <= '1' when state= activeData1 else '0';
 TxData <= x"0B" when state=loadTxData or state =activeStart or state=w8TxRdy 
            else x"00" when state =writeAddress or state=activeStart2
            else x"00";
  
  process(clk)
  begin 
    if rising_edge(clk) then     
        if saveSig ='1' then 
            registers(bytecounter) <= RxData;
        end if;
    end if;
  end process;
  
  --asignare semnale de iesire pentru data
  Data1 <= registers(3) & registers(2) &registers(1) &registers(0) ;
  Data2 <= registers(7) & registers(6) &registers(5) &registers(4) ;
  DataToDisplay <= data1 when sel='0' else data2;
  
   ssd_mux: entity work.displ7seg 
      PORT MAP(clk=>clk, rst=>rst, data => DataToDisplay, an=>an, seg=>seg);
      
  deb: entity work.debounce port map (
           Clk => clk,
           Rst => rst, 
           Din => read,
           QOut => readD
  );
  --asignare semnale de control
  TxRdy_out <= TxRdy;
  RxRdy_out <= RxRdy;
end Behavioral;
