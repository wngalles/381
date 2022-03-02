-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- onesComp.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide 
-- ones complimentor
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity onesComp_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. 
  port(i_A          : in std_logic_vector(N-1 downto 0);
       o_F          : out std_logic_vector(N-1 downto 0));

end onesComp_N;

architecture structural of onesComp_N is

  component invg is

    port(i_A          : in std_logic;
         o_F          : out std_logic);
  
  end component;

begin

  -- Instantiate N inv instances.
  G_NBit_INV: for i in 0 to N-1 generate
    INVI: invg port map(
              i_A      => i_A(i),      
              o_F     => o_F(i));  
  end generate G_NBit_INV;
  
end structural;
