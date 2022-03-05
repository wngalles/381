-------------------------------------------------------------------------
-- Austin Beinder
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- barrelshifter_layer.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity barrelshift_layer is
  port(
    A1 : in std_logic_vector(32-1 downto 0);
    A2 : in std_logic_vector(32-1 downto 0);
    O : out std_logic_vector(32-1 downto 0);
    shift: in std_logic
  );
  end barrelshift_layer;

architecture structural of barrelshift_layer is

    component mux2t1 is
        port(
            i_D0    : in std_logic;
            i_D1    : in std_logic;
            i_S     : in std_logic;
            o_O     : out std_logic);
    end component;
      
    begin

        -- Instantiate N mux instances.
        G_NBit_MUX: for i in 0 to 32-1 generate
        MUXI: mux2t1 port map(i_D0 => A1(i),
                              i_D1 => A2(i),
                              i_S   => shift,
                              o_O    => O(i));
        end generate G_NBit_MUX;


    end structural;
