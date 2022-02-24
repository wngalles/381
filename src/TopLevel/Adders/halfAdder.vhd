-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- halfAdder.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a half adder
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;



entity halfAdder is
    port(
        i_X    : in std_logic;
        i_Y    : in std_logic;
        o_S     : out std_logic;
        o_C     : out std_logic);
end halfAdder;

architecture structure of halfAdder is
  
  -- Describe the component entities as defined in andg2.vhd org2.vhd and invg.vhd.

  component andg2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  
  end component;

  component xorg2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  
  end component;
 

begin

  ---------------------------------------------------------------------------
  -- Level 0: Gates
  ---------------------------------------------------------------------------
  g_Xor: xorg2
    port MAP(i_A               => i_X,
             i_B               => i_Y,
             o_F               => o_S);
  
  g_And2: andg2
    port MAP(i_A               => i_X,
             i_B               => i_Y,
             o_F               => o_C);
 
    

  end structure;
