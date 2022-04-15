-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- equalsHaz.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity equalsHaz is

  port(i_In1        : in std_logic_vector(4 downto 0);
       i_In2        : in std_logic_vector(4 downto 0);
       i_We         : in std_logic;
       o_Equal      : out std_logic);

end equalsHaz;

architecture dataflow of equalsHaz is

    signal sig_XOR : std_logic_vector(4 downto 0);  
    signal sig_tem : std_logic;   

begin

  sig_XOR <= i_In1 xor i_In2;

  with sig_XOR select sig_tem <=
    i_We when "00000",
    '0' when others;

  with i_In1 select o_Equal <=
    '0' when "00000",
    sig_tem when others;

  
  
end dataflow;
