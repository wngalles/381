-------------------------------------------------------------------------
-- Austin Beinder
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- barrelshifter.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelshifter is
  port(
    A : std_logic_vector(32-1 downto 0);
    offset : std_logic_vector(5-1 downto 0);
    left : std_logic
  );
  end barrelshifter;

architecture structural of control is

    component mux2t1_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
      
    end component;
      

    signal layer1 : std_logic_vector(32-1 downto 0);
    signal layer2 : std_logic_vector(32-1 downto 0);
    signal layer3 : std_logic_vector(32-1 downto 0);

    signal use_fucnt : std_logic;

    begin

    


    end structural;
