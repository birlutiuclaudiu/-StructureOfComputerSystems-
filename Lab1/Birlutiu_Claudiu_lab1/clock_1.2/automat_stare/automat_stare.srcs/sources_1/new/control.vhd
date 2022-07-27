----------------------------------------------------------------------------
-- Nume proiect: clock
-- Nume modul:   control
-- Descriere:    Modul de comanda pentru ceasul de timp real
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity control is
   Port ( Clk       : in  STD_LOGIC;
          Rst       : in  STD_LOGIC;
          ModeIn    : in  STD_LOGIC;
          UpIn      : in  STD_LOGIC;
          DownIn    : in  STD_LOGIC;
          IncTime   : out STD_LOGIC;
          IncHour   : out STD_LOGIC;
          DecHour   : out STD_LOGIC;
          BlinkHour : out STD_LOGIC;
          IncMin    : out STD_LOGIC;
          DecMin    : out STD_LOGIC;
          BlinkMin  : out STD_LOGIC;
          IncSec    : out STD_LOGIC;
          DecSec    : out STD_LOGIC;
          BlinkSec  : out STD_LOGIC);
end control;

architecture Behavioral of control is

constant CLK_RATE : INTEGER := 100_000_000; -- frecventa semnalului Clk
constant CNT_1HZ  : INTEGER := CLK_RATE;    -- divizor pentru o secunda
type CTRL_TYPE is (run, set_hour, set_hour_inc, set_hour_dec, set_min,
                   set_min_inc, set_min_dec, set_sec, set_sec_inc,
                   set_sec_dec);
signal State : CTRL_TYPE;

begin
ctrl: process (Clk)
variable Count : INTEGER range 0 to CNT_1HZ - 1 := 0;
begin
   if RISING_EDGE (Clk) then
      if (Rst = '1') then
         State <= run;
         Count := 0;
      else
         IncTime <= '0';
         case State is
            when run =>
               if Count = CNT_1HZ - 1 then -- a trecut o secunda
                  IncTime <= '1';     -- semnal pentru incrementarea secundei
                  Count := 0;         -- reseteaza numaratorul
               else
                  Count := Count + 1;
               end if;
               if (ModeIn = '1') then
                  State <= set_hour;  -- altfel ramane in starea run
               end if;
            when set_hour =>
               if (UpIn = '1') then
                  State <= set_hour_inc;
               elsif (DownIn = '1') then
                  State <= set_hour_dec;
               elsif (ModeIn = '1') then
                  State <= set_min;   -- altfel ramane in starea set_hour
               end if;
            when set_hour_inc =>
               State <= set_hour;
            when set_hour_dec =>
               State <= set_hour;
            when set_min =>
               if (UpIn = '1') then
                  State <= set_min_inc;
               elsif (DownIn = '1') then
                  State <= set_min_dec;
               elsif (ModeIn = '1') then
                  State <= set_sec;   -- altfel ramane in starea set_min
               end if;
            when set_min_inc =>
               State <= set_min;
            when set_min_dec =>
               State <= set_min;
            when set_sec =>
               Count := 0;
               if (UpIn = '1') then
                  State <= set_sec_inc;
               elsif (DownIn = '1') then
                  State <= set_sec_dec;
               elsif (ModeIn = '1') then
                  State <= run;       -- altfel ramane in starea set_sec
               end if;
            when set_sec_inc =>
               State <= set_sec;
            when set_sec_dec =>
               State <= set_sec;
         end case;
      end if;
   end if;
end process ctrl;

   -- Asignarea semnalelor de comanda
   IncHour   <= '1' when State = set_hour_inc else '0';
   DecHour   <= '1' when State = set_hour_dec else '0';
   BlinkHour <= '1' when State = set_hour else '0';
   IncMin    <= '1' when State = set_min_inc else '0';
   DecMin    <= '1' when State = set_min_dec else '0';
   BlinkMin  <= '1' when State = set_min else '0';
   IncSec    <= '1' when State = set_sec_inc else '0';
   DecSec    <= '1' when State = set_sec_dec else '0';
   BlinkSec  <= '1' when State = set_sec else '0';

end Behavioral;

