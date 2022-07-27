----------------------------------------------------------------------------------
-- Birlutiu Claudiu-Andrei
-- UTCN CTI -ro 
-- Multi 8 with sst
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity multi_sst is
    generic (  nbBits : INTEGER:=8);  
    Port ( x : in  STD_LOGIC_VECTOR(nbBits-1 downto 0);
           y : in  STD_LOGIC_VECTOR(nbBits-1 downto 0);
           p : out STD_LOGIC_VECTOR (2*nbBits-1 downto 0));
end multi_sst;
    
architecture Behavioral of multi_sst is
     
     --pp matrix ; produsele partiale; sunt 8 * 8
     type matrix_pp is array (0 to nbBits-1) of std_logic_vector(nbBits-1 downto 0);
     signal pp : matrix_pp:=(others=>(others=>'0'));
     
     --intrari pentru sst-urri; le declar de tipul matrice pentru a face calculele mai usor
     type matrix_sst is array (0 to nbBits-2) of std_logic_vector(2*nbBits-1 downto 0);
     signal en1 :    matrix_sst:=(others=>(others=>'0'));
     signal en2 :    matrix_sst:=(others=>(others=>'0'));
     signal t_aux :  matrix_sst:=(others=>(others=>'0'));
     signal en3 :    matrix_sst:=(others=>(others=>'0'));
     signal aux  :    std_logic_vector(15 downto 0):=x"0000";
      
     --semnale pentru sumatorul SPT
     signal op1  :    std_logic_vector(15 downto 0):=x"0000";
     signal op2  :    std_logic_vector(15 downto 0):=x"0000";
     signal result  : std_logic_vector(16 downto 0):=(others=>'0');
     
begin
    --generarea produselor partiale
    gen_pp:
        for i in 0 to nbBits-1 generate 
            intern: for j in 0 to nbBits-1 generate
                pp(i)(j) <= x(j) and y(i);
            end generate intern;
    end generate gen_pp;
    
    --crearea logicii pentru sst-uri 
    --       en3  en2 en1
    --      __|___|_ |___
    --     |     SST    |
    --     |____________|
    ---------
    --initializare pentru primul SST
    en1(0)(nbBits-1 downto 0) <= pp(0);
    en2(0)(nbBits downto 1) <= pp(1);
    en3(0)(nbBits+1 downto 2) <= pp(2);
    --crearea celor 6 SST-uri
    SST: 
        for i in 0 to nbBits-3 generate
            SSTX: entity work.sumator_sst 
                    generic map ( nbSE => 15)
                    port map (
                    x => en1(i)(2*nbBits-2 downto 0),   --deaorece sst-urile sunt formate din 15 SE-uri
                    y => en2(i)(2*nbBits-2 downto 0),
                    z => en3(i)(2*nbBits-2 downto 0),
                    s => en1(i+1)(2*nbBits-2 downto 0),
                    t => t_aux(i+1)(2*nbBits-2 downto 0)
                    );
             --shiftarea transportului
             en2(i+1)(2*nbBits-2 downto 0) <= t_aux(i+1)(2*nbBits-3 downto 0) & '0';
             --adaugarea urmatroului produs partial adunat
             en3(i+1)(nbBits+2+i downto i+3) <= pp(i+3) when i<5;
    end generate SST;
    
    --ma folosesc de sumatorul SPT pe 16 biti; era de ajuns unul pe  15 biti , dar am avut unul implementat pe 16 bitit cu generarea transportului 
    op1 <= en1(6);
    op2 <= en2(6);
    SPT : entity work.sumator_16 PORT MAP (
        x => op1, 
        y => op2, 
        tin => '0',
        s => result(15 downto 0),
        tout => result(16)
    ); 
    p <= result(15 downto 0);
    
end Behavioral;
