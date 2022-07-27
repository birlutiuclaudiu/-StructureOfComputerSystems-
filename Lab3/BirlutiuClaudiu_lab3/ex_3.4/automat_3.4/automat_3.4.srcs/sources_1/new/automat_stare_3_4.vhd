---------------------------------------------------------------------------------
--Name: Birlutiu Claudiu-Andrei
--UTCN CTI-ro
--Cerinta:codificarea starilor astfel incat iesirile sa fie codificate prin bitii de stare
-----------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity automat_stare_3_4 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           frame: in STD_LOGIC;
           hit  : in STD_LOGIC;
           oe  : out STD_LOGIC;
           go  : out STD_LOGIC;
           act : out STD_LOGIC);
end automat_stare_3_4;

architecture Behavioral of automat_stare_3_4 is
    --codificarea starilor astfel incat iesirile sa fie codificate prin bitii de stare
    -- Stare  | oe | go | act |  st0
    -- -------|----|----|-----|------
    -- idle   | 0  | 0  |  0  |  0
    -- decode | 0  | 0  |  0  |  1
    -- busy   | 0  | 0  |  1  |  0
    -- xfer1  | 1  | 1  |  1  |  0
    -- xfer2  | 1  | 0  |  1  |  0
    --deoarece avem iesiri comune pentru starea idle si decode se va introduce o nou bit de stare care sa faca distinctia dintre cele 
    --doua stari (0 -pentru idle; 1- pentru decode); pentru celelalte stari, bitul suplimentar o sa fie 0
    --declararea constantelor pentru stari
    constant idle   : STD_LOGIC_VECTOR(3 downto 0):="0000";
    constant decode : STD_LOGIC_VECTOR(3 downto 0):="0001";
    constant busy   : STD_LOGIC_VECTOR(3 downto 0):="0010";
    constant xfer1  : STD_LOGIC_VECTOR(3 downto 0):="1110";
    constant xfer2  : STD_LOGIC_VECTOR(3 downto 0):="1010";
    --declarea registrului de stare; inititializat cu starea idle
    signal stare    : STD_LOGIC_VECTOR(3 downto 0):=idle;
    
begin

    proc1: process(clk)
        begin 
            if rising_edge(clk) then 
                if rst='1' then                  --reset sincron
                    stare <= idle;
                else
                    case stare is
                        when idle => 
                            if frame = '1' then 
                                stare <= decode;
                            else 
                                stare <= idle;    --nu e necesar, dar il pun pentru definirea corecta a mux-ului
                            end if;
                        when decode => 
                            if hit='0' then 
                                stare <= busy;
                            else 
                                stare <= xfer1;
                            end if;
                        when xfer1 => 
                             if frame='1' then 
                                stare <= xfer2;
                             else
                                stare <= xfer1;
                             end if;
                        when xfer2 =>
                            stare <= idle;
                        when busy => 
                            if frame='1' then 
                                stare <= idle;
                            else
                                stare <= busy;
                            end if; 
                        when others => stare <= idle;
                    end case;
                end if;
            end if;
    end process proc1;
    
    
    --iesirile vor fi date de bitii de stare; transmisie mai rapida
    oe  <= stare(3);
    go  <= stare(2);
    act <= stare(1);
    

end Behavioral;