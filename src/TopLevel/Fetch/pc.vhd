-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- pc.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity pc is
  port(i_CLK              : in std_logic;
       i_RST              : in std_logic;
       i_WE               : in std_logic;
       i_PCin             : in std_logic_vector(31 downto 0);
       o_PCout            : out std_logic_vector(31 downto 0);
       o_PC4out            : out std_logic_vector(31 downto 0));

end pc;

architecture structural of pc is

  component AddSub_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(nAdd_Sub     : in std_logic;
         i_X         : in std_logic_vector(N-1 downto 0);
         i_Y         : in std_logic_vector(N-1 downto 0);
         o_S          : out std_logic_vector(N-1 downto 0);
         o_F          : out std_logic;
         o_C          : out std_logic);
  
  end component;

      component reg_N is
        generic(N : integer := 16); 
        port(i_CLK         : in std_logic;
              i_RST        : in std_logic;
              i_WE         : in std_logic;
              i_D          : in std_logic_vector(N-1 downto 0);
              o_Q          : out std_logic_vector(N-1 downto 0));
      
      end component;

      component mux2t1_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
      
      end component;

      signal s_PC_ADD : std_logic_vector(31 downto 0);
      signal s_Four : std_logic_vector(31 downto 0) := x"00000004";
      signal s_DC1 : std_logic := '0';
      signal s_DC2 : std_logic;
      signal s_DC3 : std_logic;
      signal s_RST : std_logic_vector(31 downto 0) := x"00400000";
      signal s_TRANS : std_logic_vector(31 downto 0);

begin

  g_PCreg: reg_N
  generic map(32)
  port MAP(i_CLK            => i_CLK,
           i_RST            => '0',
           i_WE             => i_WE,
           i_D              => s_TRANS,
           o_Q              => s_PC_ADD);

  g_ADD4: AddSub_N
  generic map(32)
  port MAP(nAdd_Sub         => s_DC1,
           i_X              => s_PC_ADD,
           i_Y              => s_Four,
           o_S              => o_PC4out,
           o_F              => s_DC3,
           o_C              => s_DC2);
          
  g_RST: mux2t1_N
  generic map(32)
  port MAP(i_S              => i_RST,
           i_D0             => i_PCin,
           i_D1             => s_RST,
           o_O              => s_TRANS);

  o_PCout <= s_PC_ADD;
  
end structural;