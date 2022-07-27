----------------------------------------------------------------------------
-- Nume proiect: clock
-- Nume modul:   time_cnt
-- Descriere:    Modul de actualizare a ceasului
----------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity time_cnt is
   Port ( Clk     : in  STD_LOGIC;
          Rst     : in  STD_LOGIC;
          IncTime : in  STD_LOGIC;
          IncHour : in  STD_LOGIC;
          DecHour : in  STD_LOGIC;
          IncMin  : in  STD_LOGIC;
          DecMin  : in  STD_LOGIC;
          IncSec  : in  STD_LOGIC;
          DecSec  : in  STD_LOGIC;
          HourHi  : out STD_LOGIC_VECTOR (3 downto 0);
          HourLo  : out STD_LOGIC_VECTOR (3 downto 0);
          MinHi   : out STD_LOGIC_VECTOR (3 downto 0);
          MinLo   : out STD_LOGIC_VECTOR (3 downto 0);
          SecHi   : out STD_LOGIC_VECTOR (3 downto 0);
          SecLo   : out STD_LOGIC_VECTOR (3 downto 0));
end time_cnt;

architecture Behavioral of time_cnt is

signal SecHi_int  : STD_LOGIC_VECTOR (3 downto 0) := x"0";
signal SecLo_int  : STD_LOGIC_VECTOR (3 downto 0) := x"0";
signal MinHi_int  : STD_LOGIC_VECTOR (3 downto 0) := x"0";
signal MinLo_int  : STD_LOGIC_VECTOR (3 downto 0) := x"0";
signal HourHi_int : STD_LOGIC_VECTOR (3 downto 0) := x"1";
signal HourLo_int : STD_LOGIC_VECTOR (3 downto 0) := x"2";
signal TcSec      : STD_LOGIC := '0';
signal TcMin      : STD_LOGIC := '0';

begin

update_sec: process (Clk)      -- actualizarea secundei
begin
   if RISING_EDGE (Clk) then
      if (Rst = '1') then
         SecLo_int <= x"0";
         SecHi_int <= x"0";
      else
         TcSec <= '0';
         if ((IncTime = '1') or (IncSec = '1')) then
            if (SecLo_int = x"9") then
               SecLo_int <= x"0";
               if (SecHi_int = x"5") then
                  SecHi_int <= x"0";
                  if (IncTime = '1') then
                     TcSec <= '1';
                  end if;
               else
                  SecHi_int <= SecHi_int + 1;
               end if;
            else
               SecLo_int <= SecLo_int + 1;
            end if;
         end if;
         if (DecSec = '1') then
            if (SecLo_int = x"0") then
               SecLo_int <= x"9";
               if (SecHi_int = x"0") then
                  SecHi_int <= x"5";
               else
                  SecHi_int <= SecHi_int - 1;
               end if;
            else
               SecLo_int <= SecLo_int - 1;
            end if;
         end if;
      end if;
   end if;
end process update_sec;

update_min: process (Clk)      -- actualizarea minutului
begin
   if RISING_EDGE (Clk) then
      if (Rst = '1') then
         MinLo_int <= x"0";
         MinHi_int <= x"0";
      else
         TcMin <= '0';
         if ((TcSec = '1') or (IncMin = '1')) then
            if (MinLo_int = x"9") then
               MinLo_int <= x"0";
               if (MinHi_int = x"5") then
                  MinHi_int <= x"0";
                  if (TcSec = '1') then
                     TcMin <= '1';
                  end if;
               else
                  MinHi_int <= MinHi_int + 1;
               end if;
            else
               MinLo_int <= MinLo_int + 1;
            end if;
         end if;
         if (DecMin = '1') then
            if (MinLo_int = x"0") then
               MinLo_int <= x"9";
               if (MinHi_int = x"0") then
                  MinHi_int <= x"5";
               else
                  MinHi_int <= MinHi_int - 1;
               end if;
            else
               MinLo_int <= MinLo_int - 1;
            end if;
         end if;
      end if;
   end if;
end process update_min;

update_hour: process (Clk)     -- actualizarea orei
begin
   if RISING_EDGE (Clk) then
      if (Rst = '1') then
         HourLo_int <= x"2";
         HourHi_int <= x"1";
      else
         if ((TcMin = '1') or (IncHour = '1')) then
            if ((HourHi_int = x"2") and (HourLo_int = x"3")) then
               HourHi_int <= x"0";
               HourLo_int <= x"0";
            elsif (HourLo_int = x"9") then
               HourLo_int <= x"0";
               HourHi_int <= HourHi_int + 1;
            else
               HourLo_int <= HourLo_int + 1;
            end if;
         end if;
         if (DecHour = '1') then
            if ((HourHi_int = x"0") and (HourLo_int = x"0")) then
               HourHi_int <= x"2";
               HourLo_int <= x"3";
            elsif (HourLo_int = x"0") then
               HourLo_int <= x"9";
               HourHi_int <= HourHi_int - 1;
            else
               HourLo_int <= HourLo_int - 1;
            end if;
         end if;
      end if;
   end if;
end process update_hour;

   -- Asignarea semnalelor interne la semnalele de iesire
   HourHi <= HourHi_int;
   HourLo <= HourLo_int;
   MinHi  <= MinHi_int;
   MinLo  <= MinLo_int;
   SecHi  <= SecHi_int;
   SecLo  <= SecLo_int;

end Behavioral;
