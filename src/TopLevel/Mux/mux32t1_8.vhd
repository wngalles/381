-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux32t1_32.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 2:1
-- mux using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


library work;
use work.MIPS_types.all;



entity mux32t1_8 is
  port(i_S          : in std_logic_vector(2 downto 0);
       i_D          : in ALUArray;
       o_Q          : out std_logic_vector(31 downto 0));
end mux32t1_8;

architecture dataflow of mux32t1_8 is
    begin
    
        o_Q <= i_D(to_integer(unsigned(i_S))); 
      
    end dataflow;