----------------------------------------------------------------------------------
-- Bitlutiu Clauidiu - Andrei
-- UTCN CTI-ro
-- Interfata SPI
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity SPI_Interface is
    generic ( freqClkOut  : INTEGER :=5_000_000;
              freqClkIn   : INTEGER :=100_000_000;
              wordDim     : INTEGER:=8);
    Port ( clk :    in STD_LOGIC;
           TxData : in STD_LOGIC_VECTOR (wordDim-1 downto 0);
           Start:   in STD_LOGIC;
           Rst :    in STD_LOGIC;
           MISO :   in STD_LOGIC;
           MOSI :  out STD_LOGIC;
           SCK :   out STD_LOGIC;
           CS :    out STD_LOGIC;
           TxRdy : out STD_LOGIC;
           RxRdy : out STD_LOGIC;
           RxData :out STD_LOGIC_VECTOR(wordDim-1 downto 0));
end SPI_Interface;

architecture Behavioral of SPI_Interface is
    
    --semnale pentru generator SCK
    signal SCK_Reg: STD_LOGIC:='0';
    signal CE_n: STD_LOGIC:='0';
    signal CE_p: STD_LOGIC:='0';
    constant MAX_COUNTER : INTEGER:=freqClkIn/freqClkOut;
    signal counter : NATURAL:=1;
    
    --semnale interne venite de unitatea de control
    signal RstStart : std_logic:='0';
    signal LdTxRx   : std_logic:='0';
    signal ShTxRx   : std_logic:='0';
    signal SclkEn   : std_logic:='0';
    
    --registru data
    signal TxData_reg : STD_LOGIC_VECTOR(wordDim-1 downto 0):=(others=>'0');
    
    --registru de deplasare 
    signal TxRx_reg : STD_LOGIC_VECTOR(wordDim-1 downto 0):=(others=>'0');
    
    --bistabile 
    signal Rx_reg : std_logic:='0';
    signal Start_reg : std_logic:='0';
    
    
    
    type STATE_TRANSMISSION is (idle, load, tx_rx, bit0, ready); 
    signal state :STATE_TRANSMISSION:=idle;
    
begin
    -----------------------GENERARE SCK--------------------------------------
    process(clk)  
    begin 
        if rising_edge(clk) then 
            if counter = MAX_COUNTER/2 then 
                SCK_reg <= not SCK_reg; 
                if SCK_reg = '1' then      --front descrescator SCK
                    CE_n <= '1'; 
                else 
                    CE_p <='1';        --front crescator SCK
                end if;
                counter <= 1;
            else 
                counter <= counter + 1;
                CE_n <= '0'; 
                CE_p <='0';
            end if;
        end if;
    end process;
    --------------------------REGISTRU DATE----------------------------------------------
    
    Tx_data_register:process(clk)
    begin 
        if rising_edge(clk) then
            if Rst ='1' then 
                TxData_reg <=(others=>'0');
            elsif Start = '1' then 
                TxData_reg <= TxData;
            end if;
        end if;
    end process Tx_data_register;
    
   ------------------------REGISTRU TRANSFER/PRIMIRE--------------------
   
    TxRx_register: process(clk)
    begin
        if rising_edge(clk) then 
            if CE_n = '1' then 
                if Rst ='1' then 
                    TxRx_reg<=(others=>'0');
                elsif LdTxRx = '1' then 
                    TxRx_reg <= TxData_reg;
                elsif ShTxRx = '1' then 
                    TxRx_reg <= TxRx_reg(wordDim-2 downto 0) & Rx_reg;
                end if;
            end if;
        end if;
    end process;
    
    ----------------------BISTABIL INTRARE MISO-------------------------------
    Rx_rgeister: process(clk) 
    begin 
        if rising_edge(clk) then
            if CE_p = '1' then 
               if rst = '1' then 
                 Rx_reg<='0';
               else 
                 Rx_reg <= MISO;
               end if;
            end if;
        end if;
    end process Rx_rgeister;
    
    --------------------------BISTABIL START-----------------------------
    Start_register: process(clk)
    begin   
        if rising_edge(clk) then 
            if RstStart ='1' then 
                Start_reg <= '0'; 
            elsif Start = '1' then 
                Start_reg <= '1';
            end if;
        end if;
    end process Start_register;

    -------------------UNITATE CONTROL------------------------------------
    UC: process(clk) 
        variable cntBit: INTEGER:=0;
    begin 
        if rising_edge(clk) then 
            if CE_n ='1' then 
                if Rst = '1' then 
                    state <= idle;
                else 
                    case state is 
                    when idle => 
                        if Start_reg = '1' then 
                            state <= load;
                        else 
                            state <= idle;
                        end if;
                    when load => 
                        state <= tx_rx; 
                        cntBit := wordDim - 1; 
                   
                    when tx_rx => 
                        if cntBit > 0 then 
                            state <= tx_rx; 
                        elsif cntBit = 0 then 
                            state <= bit0;
                        end if;
                        cntBit := cntBit-1;
                    
                    when bit0 => 
                        state <= ready; 
                    when ready => 
                       
                        if Start_reg = '1' then 
                            state <= load; 
                        else    
                            state<= idle;
                        end if;
                        cntBit := wordDim -1;
                        
                    when others => 
                        state <= idle;
                   end case;
                end if;
            end if;
        end if;     
    end process UC;
    
    --schema data in laborator mi se pare gresita, deoarece se trece de la ready la tx_rx fara a se incarca noua comanda
    --asignare semnale de control
    TxRdy <= '1' when state = bit0 else '0';
    RxRdy <= '1' when state = ready else '0';
    RstStart <='1'  when state = load else '0';
    LdTxRx <= '1'   when state = load else '0';
    ShTxRx <= '1'   when state=tx_rx or state=bit0 else '0';
    SclkEn <= '1'   when state=tx_rx or state=bit0 else '0';
    
    CS <= '0' when state =tx_rx or state = bit0 else '1';
    --asignare semnale iesire
    SCK <= SCK_reg when SclkEn ='1' else '0';
    RxData <=TxRx_reg;    
    MOSI <= TxRx_reg(wordDim-1);


end Behavioral;
