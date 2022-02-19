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



entity mux2t1 is
    port(
        i_D0    : in std_logic;
        i_D1    : in std_logic;
        i_S     : in std_logic;
        o_O     : out std_logic);
end mux2t1;

architecture structure of mux2t1 is
  
  -- Describe the component entities as defined in andg2.vhd org2.vhd and invg.vhd.

  component andg2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  
  end component;

  component org2 is

    port(i_A          : in std_logic;
         i_B          : in std_logic;
         o_F          : out std_logic);
  
  end component;

  component invg is

    port(i_A          : in std_logic;
         o_F          : out std_logic);
  
  end component;



  -- Signal to carry inverted Select
  signal s_IS         : std_logic;
  -- Signals to carry And outputs
  signal s_A1, s_A2   : std_logic;
  

begin

  ---------------------------------------------------------------------------
  -- Level 0: Inverting Select 
  ---------------------------------------------------------------------------
 
  g_Not: invg
    port MAP(i_A              => i_S,
             o_F              => s_IS);


  ---------------------------------------------------------------------------
  -- Level 1: And gates
  ---------------------------------------------------------------------------
  g_And1: andg2
    port MAP(i_A               => i_D0,
             i_B               => s_IS,
             o_F               => s_A1);
  
  g_And2: andg2
    port MAP(i_A               => i_D1,
             i_B               => i_S,
             o_F               => s_A2);

    
  ---------------------------------------------------------------------------
  -- Level 2: Final Or gate
  ---------------------------------------------------------------------------
  g_Or: org2
    port MAP(i_A               => s_A1,
             i_B               => s_A2,
             o_F               => o_O);

  
    

  end structure;
