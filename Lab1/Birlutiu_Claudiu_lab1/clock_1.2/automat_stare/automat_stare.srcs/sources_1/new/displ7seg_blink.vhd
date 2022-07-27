----------------------------------------------------------------------------
-- Nume proiect: clock
-- Nume modul:   displ7seg_blink
-- Descriere:    Multiplexor pentru afisajul cu sapte segmente, cu
--               posibilitatea palpairii cifrelor. Datele de intrare nu
--               sunt decodificate, ci sunt aplicate direct la segmentele
--               afisajului. Pentru afisarea valorilor hexazecimale,
--               codul fiecarei cifre trebuie aplicat la intrarea Data
--               prin intermediul functiei de conversie HEX2SSEG. Pentru
--               afisarea unei cifre cu palpaire, bitul 7 al codului cifrei
--               trebuie setat la 1.
--               Codificarea segmentelor (biti 7..0): 0GFE DCBA
--                   A
--                  ---  
--               F |   | B
--                  ---    <- G
--               E |   | C
--                  --- 
--                   D
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity displ7seg_blink is
   Port ( Clk  : in  STD_LOGIC;
          Rst  : in  STD_LOGIC;
          Data : in  STD_LOGIC_VECTOR (63 downto 0); 
                 -- date de afisat (cifra 1 din stanga: biti 63..56)
          An   : out STD_LOGIC_VECTOR (7 downto 0); 
                 -- semnale pentru anozi (active in 0 logic)
          Seg  : out STD_LOGIC_VECTOR (7 downto 0)); 
                 -- semnale pentru segmentele (catozii) cifrei active
end displ7seg_blink;

architecture Behavioral of displ7seg_blink is

constant CLK_RATE  : INTEGER := 100_000_000;  -- frecventa semnalului Clk
constant CNT_100HZ : INTEGER := 2**20;        -- divizor pentru rata de
                                              -- reimprospatare de ~100 Hz
constant CNT_500MS : INTEGER := CLK_RATE / 2; -- divizor pentru 500 ms
signal Count       : INTEGER range 0 to CNT_100HZ - 1 := 0;
signal CountBlink  : INTEGER range 0 to CNT_500MS - 1 := 0;
signal BlinkOn     : STD_LOGIC := '0';
signal CountVect   : STD_LOGIC_VECTOR (19 downto 0) := (others => '0');
signal LedSel      : STD_LOGIC_VECTOR (2 downto 0) := (others => '0');
signal Digit1      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit2      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit3      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit4      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit5      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit6      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit7      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit8      : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');

begin
   -- Proces pentru divizarea frecventei ceasului
   div_clk: process (Clk)
   begin
      if RISING_EDGE (Clk) then
         if (Rst = '1') then
            Count <= 0;
         elsif (Count = CNT_100HZ - 1) then
            Count <= 0;
         else
            Count <= Count + 1;
         end if;
      end if;
   end process div_clk;

   CountVect <= CONV_STD_LOGIC_VECTOR (Count, 20);
   LedSel <= CountVect (19 downto 17);

   -- Proces pentru functia de palpaire
   blink: process (Clk)
   begin
      if RISING_EDGE (Clk) then
         if (Rst = '1') then
            CountBlink <= 0;
            BlinkOn <= '0';
         elsif (CountBlink = CNT_500MS - 1) then
            CountBlink <= 0;
            BlinkOn <= not BlinkOn;
         else
            CountBlink <= CountBlink + 1;
         end if;
      end if;
   end process blink;

   -- Date pentru segmentele fiecarei cifre
   Digit8 <= x"FF" when (BlinkOn = '1') and (Data(7)  = '1') else
             '1' & Data (6 downto 0);
   Digit7 <= x"FF" when (BlinkOn = '1') and (Data(15) = '1') else
             '1' & Data (14 downto 8);
   Digit6 <= x"FF" when (BlinkOn = '1') and (Data(23) = '1') else
             '1' & Data (22 downto 16);
   Digit5 <= x"FF" when (BlinkOn = '1') and (Data(31) = '1') else
             '1' & Data (30 downto 24);
   Digit4 <= x"FF" when (BlinkOn = '1') and (Data(39) = '1') else
             '1' & Data (38 downto 32);
   Digit3 <= x"FF" when (BlinkOn = '1') and (Data(47) = '1') else
             '1' & Data (46 downto 40);
   Digit2 <= x"FF" when (BlinkOn = '1') and (Data(55) = '1') else
             '1' & Data (54 downto 48);
   Digit1 <= x"FF" when (BlinkOn = '1') and (Data(63) = '1') else
             '1' & Data (62 downto 56);

   -- Semnal pentru selectarea cifrei active (anozi)
   An <= "11111110" when LedSel = "000" else
         "11111101" when LedSel = "001" else
         "11111011" when LedSel = "010" else
         "11110111" when LedSel = "011" else
         "11101111" when LedSel = "100" else
         "11011111" when LedSel = "101" else
         "10111111" when LedSel = "110" else
         "01111111" when LedSel = "111" else
         "11111111";

   -- Semnal pentru segmentele cifrei active (catozi)
   Seg <= Digit8 when LedSel = "000" else
          Digit7 when LedSel = "001" else
          Digit6 when LedSel = "010" else
          Digit5 when LedSel = "011" else
          Digit4 when LedSel = "100" else
          Digit3 when LedSel = "101" else
          Digit2 when LedSel = "110" else
          Digit1 when LedSel = "111" else
          x"FF";

end Behavioral;
