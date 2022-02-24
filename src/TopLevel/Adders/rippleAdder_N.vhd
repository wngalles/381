-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- rippleAdder_N.vhd
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

entity rippleAdder_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_C          : in std_logic;
       i_X         : in std_logic_vector(N-1 downto 0);
       i_Y         : in std_logic_vector(N-1 downto 0);
       o_S          : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);

end rippleAdder_N;

architecture structural of rippleAdder_N is

    component fullAdder is
        port(
            i_X     : in std_logic;
            i_Y     : in std_logic;
            i_C     : in std_logic;
            o_S     : out std_logic;
            o_C     : out std_logic);
    end component;

      signal s_C : std_logic_vector(N downto 0);

begin

  s_C(0) <= i_C; 
 
  G_NBit_Ripple: for i in 0 to N-1 generate
    RIPPI: fullAdder port map(
              i_C      => s_C(i),      
              i_X     => i_X(i),  
              i_Y     => i_Y(i),
              o_S      => o_S(i),  
              o_C      => s_C(i+1));  
  end generate G_NBit_Ripple;

  o_C <= s_C(N);
  
end structural;
