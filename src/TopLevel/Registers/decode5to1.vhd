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

architecture dataflow of decode5to1 is
    begin
    
      o_O <= 31x"00000000" & i_E sll to_integer(unsigned(i_S));
      
    end dataflow;
    