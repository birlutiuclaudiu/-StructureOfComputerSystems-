----------------------------------------------------------------------------
-- Nume proiect: clock
-- Nume modul:   clock
-- Descriere:    Modul principal pentru ceasul de timp real
----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clock is
    Port ( Clk  : in  STD_LOGIC;
           Rst  : in  STD_LOGIC;
           Mode : in  STD_LOGIC;
           Up   : in  STD_LOGIC;
           Down : in  STD_LOGIC;
           An   : out STD_LOGIC_VECTOR (7 downto 0);
           Seg  : out STD_LOGIC_VECTOR (7 downto 0));
end clock;

architecture Behavioral of clock is

-- Functie de conversie pentru un afisaj cu sapte segmente cu anod comun
-- Intrare: Cifra hexazecimala
-- Iesire:  Codul pentru segmente
-- Codificarea segmentelor (biti 7..0): HGFE DCBA (H - punct zecimal)
--      A
--     ---  
--  F |   | B
--     ---    <- G
--  E |   | C
--     ---  . <- H
--      D

function HEX2SSEG (Hex : in STD_LOGIC_VECTOR (3 downto 0))
                  return STD_LOGIC_VECTOR is
   variable Sseg : STD_LOGIC_VECTOR (7 downto 0);
begin
   case Hex is
      when "0000" => Sseg := "11000000";  -- 0
      when "0001" => Sseg := "11111001";  -- 1
      when "0010" => Sseg := "10100100";  -- 2
      when "0011" => Sseg := "10110000";  -- 3
      when "0100" => Sseg := "10011001";  -- 4
      when "0101" => Sseg := "10010010";  -- 5
      when "0110" => Sseg := "10000010";  -- 6
      when "0111" => Sseg := "11111000";  -- 7
      when "1000" => Sseg := "10000000";  -- 8
      when "1001" => Sseg := "10010000";  -- 9
      when "1010" => Sseg := "10001000";  -- A
      when "1011" => Sseg := "10000011";  -- b
      when "1100" => Sseg := "11000110";  -- C
      when "1101" => Sseg := "10100001";  -- d
      when "1110" => Sseg := "10000110";  -- E
      when "1111" => Sseg := "10001110";  -- F
      when others => Sseg := "11111111";
   end case;
   return Sseg;
end function HEX2SSEG;

signal Data   : STD_LOGIC_VECTOR (63 downto 0) := (others => '0');
signal Digit1 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit2 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit3 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit4 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit5 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit6 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit7 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0');
signal Digit8 : STD_LOGIC_VECTOR (7 downto 0) := (others => '0'); 

signal IncTime   : STD_LOGIC := '0';
signal IncHour   : STD_LOGIC := '0';
signal DecHour   : STD_LOGIC := '0';
signal BlinkHour : STD_LOGIC := '0';
signal IncMin    : STD_LOGIC := '0';
signal DecMin    : STD_LOGIC := '0';
signal BlinkMin  : STD_LOGIC := '0';
signal IncSec    : STD_LOGIC := '0';
signal DecSec    : STD_LOGIC := '0';
signal BlinkSec  : STD_LOGIC := '0';
signal HourHi    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal HourLo    : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal MinHi     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal MinLo     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal SecHi     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');
signal SecLo     : STD_LOGIC_VECTOR (3 downto 0) := (others => '0');

signal ModeD : STD_LOGIC:= '0';
signal UpD: STD_LOGIC:= '0';
signal DownD: STD_LOGIC:= '0';


begin
-- Setarea configuratiei segmentelor pentru fiecare cifra
-- Cifrele 1-2: ora
   Digit1 <= (HEX2SSEG (HourHi) and x"7F") or (BlinkHour & "0000000");
   Digit2 <= (HEX2SSEG (HourLo) and x"7F") or (BlinkHour & "0000000");
-- Cifra 3: separator; fara palpaire in modul de setare a orei,
--          altfel cu palpaire
   Digit3 <= b"0011_1111" when (BlinkHour or BlinkMin or BlinkSec) = '1'
                          else b"1011_1111";
-- Cifrele 4-5: minutul
   Digit4 <= (HEX2SSEG (MinHi) and x"7F") or (BlinkMin & "0000000");
   Digit5 <= (HEX2SSEG (MinLo) and x"7F") or (BlinkMin & "0000000");
-- Cifra 6: separator; fara palpaire in modul de setare a orei,
--          altfel cu palpaire
   Digit6 <= b"0011_1111" when (BlinkHour or BlinkMin or BlinkSec) = '1'
                          else b"1011_1111";
-- Cifrele 7-8: secunda
   Digit7 <= (HEX2SSEG (SecHi) and x"7F") or (BlinkSec & "0000000");
   Digit8 <= (HEX2SSEG (SecLo) and x"7F") or (BlinkSec & "0000000");

   Data   <= Digit1&Digit2&Digit3&Digit4&Digit5&Digit6&Digit7&Digit8;

   control_i: entity WORK.control port map (
                     Clk => Clk,
                     Rst => Rst,
                     ModeIn => ModeD,
                     UpIn => UpD,
                     DownIn => DownD,
                     IncTime => IncTime,
                     IncHour => IncHour,
                     DecHour => DecHour,
                     BlinkHour => BlinkHour,
                     IncMin => IncMin,
                     DecMin => DecMin,
                     BlinkMin => BlinkMin,
                     IncSec => IncSec,
                     DecSec => DecSec,
                     BlinkSec => BlinkSec);

   time_cnt_i: entity WORK.time_cnt port map (
                     Clk => Clk,
                     Rst => Rst,
                     IncTime => IncTime,
                     IncHour => IncHour,
                     DecHour => DecHour,
                     IncMin => IncMin,
                     DecMin => DecMin,
                     IncSec => IncSec,
                     DecSec => DecSec,
                     HourHi => HourHi,
                     HourLo => HourLo,
                     MinHi  => MinHi,
                     MinLo  => MinLo,
                     SecHi  => SecHi,
                     SecLo  => SecLo);

   displ7seg_blink_i: entity WORK.displ7seg_blink port map (
                     Clk => Clk,
                     Rst => Rst,
                     Data => Data,
                     An => An,
                     Seg => Seg);
   
   debounce1: entity WORK.debounce port map (
                Clk => Clk,
                     Rst => Rst,
                     Din => Mode,
                     QOut => ModeD
                     );
   debounce2: entity WORK.debounce port map (
                Clk => Clk,
                     Rst => Rst,
                     Din => Up,
                     QOut => UpD
                     );
   debounce3: entity WORK.debounce port map (
                Clk => Clk,
                     Rst => Rst,
                     Din => Down,
                     QOut => DownD
                     );

end Behavioral;

