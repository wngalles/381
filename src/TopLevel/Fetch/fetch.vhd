-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- fetch.vhd
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

entity fetch is
  port(i_CLK              : in std_logic;
       i_Jump             : in std_logic;
       i_Branch           : in std_logic;
       i_Zero             : in std_logic;
       i_Immediate        : in std_logic_vector(31 downto 0);
       o_Instruction      : out std_logic_vector(31 downto 0));

end fetch;

architecture structural of rippleAdder_N is

    component rippleAdder_N is
        generic(N); 
        port(i_C          : in std_logic;
             i_X          : in std_logic_vector(N-1 downto 0);
             i_Y          : in std_logic_vector(N-1 downto 0);
             o_S          : out std_logic_vector(N-1 downto 0);
             o_C          : out std_logic);
      
      end component;

      component mux2t1_N is
        generic(N);
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
      
      end component;

      signal s_PC_ADD : std_logic_vector(31 downto 0);
      signal s_PC_ADD : std_logic_vector(31 downto 0);

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