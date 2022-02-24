-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- AddSub_N.vhd
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

entity AddSub_N is
  generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
  port(nAdd_Sub     : in std_logic;
       i_X         : in std_logic_vector(N-1 downto 0);
       i_Y         : in std_logic_vector(N-1 downto 0);
       o_S          : out std_logic_vector(N-1 downto 0);
       o_C          : out std_logic);

end AddSub_N;

architecture structural of AddSub_N is

    component rippleAdder_N is
        generic(N : integer := 16); 
        port(i_C          : in std_logic;
             i_X         : in std_logic_vector(N-1 downto 0);
             i_Y         : in std_logic_vector(N-1 downto 0);
             o_S          : out std_logic_vector(N-1 downto 0);
             o_C          : out std_logic);
      
      end component;

      component mux2t1_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
      
      end component;   

      component onesComp_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. 
        port(i_A          : in std_logic_vector(N-1 downto 0);
             o_F          : out std_logic_vector(N-1 downto 0));
      
      end component;
    
      signal s_I : std_logic_vector(N-1 downto 0);
      signal s_M : std_logic_vector(N-1 downto 0);

begin

    g_RipAdd: rippleAdder_N
    generic map(N)
    port MAP(i_C             => nAdd_Sub,
             i_X               => i_X,
             i_Y              => s_M,
             o_S               => o_S,
             o_C               => o_C);

    g_Mux: mux2t1_N
    generic map(N)
    port MAP(i_S             => nAdd_Sub,
             i_D0               => i_Y,
             i_D1              => s_I,
             o_O               => s_M);

    g_Inv: onesComp_N
    generic map(N)
    port MAP(i_A             => I_Y,
             o_F               => s_I);
  
end structural;
