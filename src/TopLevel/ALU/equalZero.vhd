-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- equalZero.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

entity equalZero is

  port(i_In         : in std_logic_vector(32-1 downto 0);
       o_EqualZero  : out std_logic);

end equalZero;

architecture dataflow of equalZero is
begin

  with i_In select o_EqualZero <=
    '1' when 32x"0",
    '0' when others;
  
end dataflow;
