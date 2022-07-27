library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity divider_ref_tb is 
end divider_ref_tb;

architecture Behavioral of divider_ref_tb is
  component divider_ref is
    generic (
        n: INTEGER:=8
    );
    Port ( clk :     in STD_LOGIC;
           rst :     in STD_LOGIC;
           start :   in STD_LOGIC;
           x :       in STD_LOGIC_VECTOR(2*n-1 downto 0);
           y :       in STD_LOGIC_VECTOR(n-1 downto 0);
           a :       out STD_LOGIC_VECTOR(n-1 downto 0);
           q :       out STD_LOGIC_VECTOR(n-1 downto 0);
           term :    out STD_LOGIC);
    end component;

  -- Clock period
  constant clk_period : time := 10 ns;
  -- Generics
  constant n : INTEGER := 8;
  constant waitTime: time:=500 ns;

  -- Ports
  signal clk :   STD_LOGIC:='0';
  signal rst :   STD_LOGIC:='0';
  signal start : STD_LOGIC:='0';
  signal x :     STD_LOGIC_VECTOR(2*n-1 downto 0):=(others=>'0');
  signal y :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal a :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal q :     STD_LOGIC_VECTOR(n-1 downto 0):=(others=>'0');
  signal term :  STD_LOGIC:='0';

begin

  mul_booth_inst : divider_ref
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
        variable rest: INTEGER:=0;
        variable cat:  INTEGER:=0;
        variable nbErr: INTEGER:=0;
   begin 
        for i in 10 to 20 loop
            for j in 5 to 9 loop
                x <= conv_std_logic_vector(i, 2*n);
                y <= conv_std_logic_vector(j, n); 
                start <= '1';
                wait for clk_period;
                start <='0';
                wait for waitTime ;
                rest := i mod j;
                cat := i / j;
                if a/=conv_std_logic_vector(rest, n) or q/=conv_std_logic_vector(cat, n) then 
                    report "ERROR for " & INTEGER'IMAGE(i) & "\\" & INTEGER'IMAGE(j) severity ERROR;
                    nbErr := nbErr+1;
                end if;
               wait for clk_period;
            end loop;
        end loop;
        
        wait for clk_period;
        for i in 290 to 300 loop
            for j in 120 to 127 loop
                x <= conv_std_logic_vector(i, 2*n);
                y <= conv_std_logic_vector(j, n); 
                start <= '1';
                wait for clk_period;
                start <='0';
                wait for waitTime ;
                rest := i mod j;
                cat := i / j;
                if a/=conv_std_logic_vector(rest, n) or q/=conv_std_logic_vector(cat, n) then 
                    report "ERROR for " & INTEGER'IMAGE(i) & "\\" & INTEGER'IMAGE(j) severity ERROR;
                    nbErr := nbErr+1;
                end if;
               wait for clk_period;
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
