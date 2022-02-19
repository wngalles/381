-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- pc.vhd
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
       i_RST              : in std_logic;
       i_WE               : in std_logic;
       i_PCin             : in std_logic_vector(31 downto 0);
       o_PCout            : out std_logic_vector(31 downto 0));

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

      component reg_N is
        generic(N); 
        port(i_CLK         : in std_logic;
              i_RST        : in std_logic;
              i_WE         : in std_logic;
              i_D          : in std_logic_vector(N-1 downto 0);
              o_Q          : out std_logic_vector(N-1 downto 0));
      
      end component;

      signal s_PC_ADD : std_logic_vector(31 downto 0);
      signal s_Four : std_logic_vector(31 downto 0) := 32x"4";
      signal s_DC1 : std_logic;
      signal s_DC2 : std_logic;

begin

  g_PCreg: reg_N
  generic map(32)
  port MAP(i_CLK            => i_CLK,
           i_RST            => i_RST,
           i_WE             => i_WE,
           i_D              => i_PCin,
           o_Q              => s_PC_ADD);

  g_ADD4: reg_N
  generic map(32)
  port MAP(i_C              => s_DC1,
           i_X              => s_PC_ADD,
           i_Y              => s_Four,
           o_S              => o_PCout,
           o_C              => s_DC2);
  
end structural;