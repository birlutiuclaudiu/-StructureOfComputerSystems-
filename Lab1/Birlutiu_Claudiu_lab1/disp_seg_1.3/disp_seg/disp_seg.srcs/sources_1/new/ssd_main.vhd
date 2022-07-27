----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/02/2021 04:32:31 PM
-- Design Name: 
-- Module Name: ssd_main - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ssd_main is
    Port ( clk : in STD_LOGIC;
           rst : in STD_LOGIC;
           an   :  out STD_LOGIC_VECTOR (7 downto 0);
           seg  :  out STD_LOGIC_VECTOR (7 downto 0));
end ssd_main;

architecture Behavioral of ssd_main is
    component displ7seg is
         Port ( clk  :   in STD_LOGIC;
           rst  :  in STD_LOGIC;
           data :  in STD_LOGIC_VECTOR (31 downto 0);
           an   :  out STD_LOGIC_VECTOR (7 downto 0);
           seg  :  out STD_LOGIC_VECTOR (7 downto 0));
    end component displ7seg;
    signal ana: CHARACTER;
begin
    
    ssd_mux: displ7seg PORT MAP(clk=>clk, rst=>rst, data => x"ABCDEF78", an=>an, seg=>seg);
    
end Behavioral;
