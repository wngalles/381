-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a basic 2-1 mux
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;



entity fullAdder is
    port(
        i_X     : in std_logic;
        i_Y     : in std_logic;
        i_C     : in std_logic;
        o_S     : out std_logic;
        o_C     : out std_logic);
end fullAdder;

architecture structure of fullAdder is
  
  -- Describe the component entities as defined in andg2.vhd org2.vhd and invg.vhd.

  component halfAdder is
    port(
        i_X    : in std_logic;
        i_Y    : in std_logic;
        o_S     : out std_logic;
        o_C     : out std_logic);
    end component;

  component org2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  
  end component;


  -- Signal to carry first sum
  signal s_S         : std_logic;
  -- Signals to carry carry bits
  signal s_C1, s_C2   : std_logic;
  

begin

  ---------------------------------------------------------------------------
  -- Level 0: First Half Adder
  ---------------------------------------------------------------------------
 
  g_HfA1: halfAdder
    port MAP(i_X               => i_X,
             i_Y               => i_Y,
             o_S               => s_S,
             o_C               => s_C1);


  ---------------------------------------------------------------------------
  -- Level 1: Second Half Adder
  ---------------------------------------------------------------------------
  g_HfA2: halfAdder
    port MAP(i_X               => i_C,
             i_Y               => s_S,
             o_S               => o_S,
             o_C               => s_C2);

    
  ---------------------------------------------------------------------------
  -- Level 2: Final Or gate
  ---------------------------------------------------------------------------
  g_Or: org2
    port MAP(i_A               => s_C1,
             i_B               => s_C2,
             o_F               => o_C);

  
    

  end structure;
