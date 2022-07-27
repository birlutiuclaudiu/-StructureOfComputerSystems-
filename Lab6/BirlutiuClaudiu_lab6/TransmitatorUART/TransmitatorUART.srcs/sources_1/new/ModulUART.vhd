----------------------------------------------------------------------------------
-- Bilrutiu Claudiu-Andrei
-- UTCN CTI- ro

----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ModulUART is
  generic( bitRate: INTEGER:=115_200);
  Port ( 
    Clk:    in STD_LOGIC;
    Rst:    in STD_LOGIC;
    Start:  in STD_LOGIC;
    TxData: in STD_LOGIC_VECTOR(7 downto 0);
    Tx    :  out STD_LOGIC;
    TxRdy  : out STD_LOGIC
    );
end ModulUART;

architecture Behavioral of ModulUART is
    type STATE is (ready, load, send, waitbit, shift);
    signal St : STATE:=ready;
    
    signal CntRate: INTEGER:=0;
    signal CntBit : INTEGER:=0;
    
    --semnale pentru registru
    signal   TxEn:  STD_LOGIC:='0';
    signal LDData:  STD_LOGIC:='0';
    signal SHData:  STD_LOGIC:='0';
    
    --valoara din registru
    signal TSR: STD_LOGIC_VECTOR(9 downto 0):=(others=>'0');
    
    --declararea frecventa ceas
    constant frecventa : INTEGER:=100_000_000;  --100MHz
    --declararea constant T_BIT 
    constant T_BIT : INTEGER:=frecventa/bitrate;  
    
    attribute keep :STRING; 
    attribute keep of St:      signal is "TRUE";
    attribute keep of CntRate: signal is "TRUE";
    attribute keep of CntBit:  signal is "TRUE";
    attribute keep of TSR:  signal is "TRUE";
    
begin
    
    -- Automat de stare pentru unitatea de control a transmitatorului serial
proc_control: process (Clk)
begin
    if RISING_EDGE (Clk) then
        if (Rst = '1') then
          St <= ready;
        else
            case St is
                when ready =>
                    CntRate <= 0;
                    CntBit <= 0;
                    if (Start = '1') then
                        St <= load;
                    end if;
                    
                when load =>
                    St <= send;
                    
                when send =>
                    CntBit <= CntBit + 1;
                    St <= waitbit;
                    
                when waitbit =>
                     CntRate <= CntRate + 1;
                     if (CntRate = T_BIT-3) then
                         CntRate <= 0;
                         St <= shift;
                     end if;
               
                when shift =>    
                     if (CntBit = 10) then
                         St <= ready;
                     else
                         St <= send;
                     end if;
                when others =>
                        St <= ready;
             end case;
         end if;
    end if;
   end process proc_control;
            -- Setarea semnalelorde comanda
    LdData <= '1' when  St= load else '0';
    ShData <= '1' when St = shift else '0';
    TxEn<= '0' when St= ready or St = load else '1';
    -- Setarea semnalelor de iesire
    Tx  <= TSR(0) when TxEn = '1' else '1';
    TxRdy <= '1' when St = ready else '0';

    ------------------------------REGISTRU TSR----------------------------------------
    n_register: process( Clk )
    begin
        if rising_edge(clk) then 
            if Rst = '1' then 
                TSR <= (others => '0');
            elsif LdData = '1' then 
                TSR <= '1' & TxData & '0';    --stop & data & start
            elsif ShData = '1' then 
                TSR <= '1' & TSR(9 downto 1);
            end if;
        end if;
    end process n_register;
    ----------------------------------------------------------------------------------
    

end Behavioral;
