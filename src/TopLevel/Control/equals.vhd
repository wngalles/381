-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- equals.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity equals is

  port(i_In1        : in std_logic_vector(32-1 downto 0);
       i_In2        : in std_logic_vector(32-1 downto 0);
       o_Equal      : out std_logic);

end equals;

architecture dataflow of equals is

    signal sig_XOR : std_logic_vector(32-1 downto 0);    

begin

  sig_XOR <= i_In1 xor i_In2;

  with sig_XOR select o_Equal <=
    '1' when x"00000000",
    '0' when others;
  
end dataflow;
