-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- decode5to1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a basic 2-1 mux 
--              using a dataflow implementation
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


entity decode5to1 is
    port(
        i_S    : in std_logic_vector(4 downto 0);
        i_E    : in std_logic;
        o_O     : out std_logic_vector(31 downto 0));
end decode5to1;

architecture structure of decode5to1 is 


signal A : std_logic_vector(6-1 downto 0);

begin


  A <= i_E & i_S;

  with A select o_O <=
    x"00000001" when "100000",
    x"00000002" when "100001",
    x"00000004" when "100010",
    x"00000008" when "100011",

    x"00000010" when "100100",
    x"00000020" when "100101",
    x"00000040" when "100110",
    x"00000080" when "100111",


    x"00000100" when "101000",
    x"00000200" when "101001",
    x"00000400" when "101010",
    x"00000800" when "101011",
    x"00001000" when "101100",
    x"00002000" when "101101",
    x"00004000" when "101110",
    x"00008000" when "101111",



    x"00010000" when "110000",
    x"00020000" when "110001",
    x"00040000" when "110010",
    x"00080000" when "110011",
    x"00100000" when "110100",
    x"00200000" when "110101",
    x"00400000" when "110110",
    x"00800000" when "110111",
    x"01000000" when "111000",
    x"02000000" when "111001",
    x"04000000" when "111010",
    x"08000000" when "111011",
    x"10000000" when "111100",
    x"20000000" when "111101",
    x"40000000" when "111110",
    x"80000000" when "111111",
    x"00000000" when others;


  
end structure;

    