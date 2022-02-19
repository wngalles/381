-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- regFile.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an N-bit wide register
-- using structural VHDL, generics, and generate statements.
--
--
-- NOTES:
-- 1/6/20 by H3::Created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.my_array.all;

entity regFile is
  port(i_CLK         : in std_logic;
        i_S          : in std_logic_vector(4 downto 0);
        i_R1         : in std_logic_vector(4 downto 0);
        i_R2         : in std_logic_vector(4 downto 0);
        i_WE         : in std_logic;
        i_RST        : in std_logic;
        i_D          : in std_logic_vector(31 downto 0);
        o_Q1         : out std_logic_vector(31 downto 0);
        o_Q2         : out std_logic_vector(31 downto 0));

end regFile;

architecture structural of regFile is

    component reg_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_CLK         : in std_logic;
              i_RST        : in std_logic;
              i_WE         : in std_logic;
              i_D          : in std_logic_vector(N-1 downto 0);
              o_Q          : out std_logic_vector(N-1 downto 0));
      
      end component;


    component decode5to1 is
        port(
            i_S    : in std_logic_vector(4 downto 0);
            i_E    : in std_logic;
            o_O     : out std_logic_vector(31 downto 0));
    end component;

    component mux32t1_32 is
      port(i_S          : in std_logic_vector(4 downto 0);
           i_D          : in inputArray;
           o_Q          : out std_logic_vector(31 downto 0));
    end component;

    signal s_S : std_logic_vector(31 downto 0);
    signal s_Q : inputArray;

begin

  Decode: decode5to1
    port MAP(i_S               => i_S,
             i_E               => i_WE,
             o_O               => s_S);

  REG0: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => '1',       
    i_WE      => '0',  
    i_D       => i_D,  
    o_Q       => s_Q(0));

  -- Instantiate N mux instances.
  G_NBit_REG: for i in 1 to 31 generate
    REGI: reg_N generic map(32) port map(
              i_CLK     => i_CLK,
              i_RST     => i_RST,       
              i_WE      => s_S(i),  
              i_D       => i_D,  
              o_Q       => s_Q(i));  
  end generate G_NBit_REG;

  MUX1: mux32t1_32 port map(
              i_S       => i_R1,          
              i_D       => s_Q,  
              o_Q       => o_Q1);  
              
  MUX2: mux32t1_32 port map(
              i_S       => i_R2,          
              i_D       => s_Q,  
              o_Q       => o_Q2);   
  
end structural;
