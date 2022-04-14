-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- IF_ID.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity IF_ID is
  port(i_CLK              : in std_logic;
        i_RST             : in std_logic;
        i_Stall           : in std_logic;
        i_Flush           : in std_logic;
        i_PC4             : in std_logic_vector(31 downto 0);
        i_Instruction     : in std_logic_vector(31 downto 0);
        o_PC4             : out std_logic_vector(31 downto 0);
        o_Instruction     : out std_logic_vector(31 downto 0));

end IF_ID;

architecture structural of IF_ID is

    component reg_N is
        generic(N : integer); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_CLK         : in std_logic;
              i_RST        : in std_logic;
              i_WE         : in std_logic;
              i_D          : in std_logic_vector(N-1 downto 0);
              o_Q          : out std_logic_vector(N-1 downto 0));
      
      end component;

      signal s_reset : std_logic;

begin

  s_reset <= i_RST or i_Flush;

  REG_INS: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => s_reset,       
    i_WE      => i_Stall,  
    i_D       => i_Instruction,  
    o_Q       => o_Instruction);

  REG_PC4: reg_N generic map(32) port map(
    i_CLK     => i_CLK,
    i_RST     => s_reset,       
    i_WE      => i_Stall,  
    i_D       => i_PC4,  
    o_Q       => o_PC4);

  
end structural;
