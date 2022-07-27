library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_signed.all;
use ieee.std_logic_arith.all;

entity mul_booth_tb is
end;

architecture bench of mul_booth_tb is

  component mul_booth
    generic (
      n : INTEGER
    );
      port (
      clk : in STD_LOGIC;
      rst : in STD_LOGIC;
      start : in STD_LOGIC;
      x : in STD_LOGIC_VECTOR(n-1 downto 0);
      y : in STD_LOGIC_VECTOR(n-1 downto 0);
      a : out STD_LOGIC_VECTOR(n-1 downto 0);
      q : out STD_LOGIC_VECTOR(n-1 downto 0);
      term : out STD_LOGIC
    );
  end component;

  -- Clock period
  constant clk_period : time := 10 ns;
  -- Generics
  constant n : INTEGER := 8;

  -- Ports
  signal clk :   STD_LOGIC:='0';
  signal rst :   STD_LOGIC:='0';
  signal start : STD_LOGIC:='0';
  signal x :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal y :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal a :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal q :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal term :  STD_LOGIC:='0';

begin

  mul_booth_inst : mul_booth
    generic map (
      n => n
    )
    port map (
      clk => clk,
      rst => rst,
      start => start,
      x => x,
      y => y,
      a => a,
      q => q,
      term => term
    );

   clk_process : process
   begin
      clk <= '1';
      wait for clk_period/2;
      clk <= '0';
      wait for clk_period/2;
   end process clk_process;
   
   gen_signals: process
        variable result: INTEGER:=0;
        variable nbErr: INTEGER:=0;
   begin 
        for i in -4 to 2 loop
            for j in -2 to 3 loop
                x <= conv_std_logic_vector(i, n);
                y <= conv_std_logic_vector(j, n); 
                start <= '1';
                wait for clk_period;
                start <='0';
                wait for 300 ns;
                result := i*j;
                if conv_std_logic_vector(result,2*n) /= (a & q) then 
                    report "ERROR for " & INTEGER'IMAGE(i) & "*" & INTEGER'IMAGE(j) severity ERROR;
                    nbErr := nbErr+1;
                end if;
            end loop;
        end loop;
        wait for clk_period;
        for i in 125 to 127 loop
            for j in -127 to -125 loop
                x <= conv_std_logic_vector(i, n);
                y <= conv_std_logic_vector(j, n); 
                start <= '1';
                wait for clk_period;
                start <='0';
                wait for 300 ns;
                result := i*j;
                if conv_std_logic_vector(result,2*n) /= (a & q) then 
                    report "ERROR for " & INTEGER'IMAGE(i) & "*" & INTEGER'IMAGE(j) severity ERROR;
                    nbErr := nbErr+1;
                end if;
            end loop;
        end loop;
        
        wait for clk_period;
        for i in 125 to 127 loop
            for j in 125 to 127 loop
                x <= conv_std_logic_vector(i, n);
                y <= conv_std_logic_vector(j, n); 
                start <= '1';
                wait for clk_period;
                start <='0';
                wait for 300 ns;
                result := i*j;
                if conv_std_logic_vector(result,2*n) /= (a & q) then 
                    report "ERROR for " & INTEGER'IMAGE(i) & "*" & INTEGER'IMAGE(j) severity ERROR;
                    nbErr := nbErr+1;
                end if;
            end loop;
        end loop;
        wait for clk_period;
        for i in -127 to -125 loop
            for j in -127 to -125 loop
                x <= conv_std_logic_vector(i, n);
                y <= conv_std_logic_vector(j, n); 
                start <= '1';
                wait for clk_period;
                start <='0';
                wait for 300 ns;
                result := i*j;
                if conv_std_logic_vector(result,2*n) /= (a & q) then 
                    report "ERROR for " & INTEGER'IMAGE(i) & "*" & INTEGER'IMAGE(j) severity ERROR;
                    nbErr := nbErr+1;
                end if;
            end loop;
        end loop;
                
            
        if nbErr = 0 then 
            report "NO ERRORS";
        else 
            report INTEGER'IMAGE(nbErr) & " ERRORS" severity FAILURE;
        end if;
        wait;
   end process gen_signals;
   
   
end;
