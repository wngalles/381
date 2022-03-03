-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- fetch.vhd
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;

entity fetch is
  port(i_PCin             : in std_logic_vector(31 downto 0);
       i_Instruction      : in std_logic_vector(31 downto 0);
       i_Immediate        : in std_logic_vector(31 downto 0);
       i_Register         : in std_logic_vector(31 downto 0);
       i_Jump             : in std_logic;
       i_JumpRegister     : in std_logic;
       i_BEQ              : in std_logic;
       i_BNE              : in std_logic;
       i_Equal            : in std_logic;
       o_PCout            : out std_logic_vector(31 downto 0));

end fetch;

architecture structural of fetch is

  component AddSub_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(nAdd_Sub     : in std_logic;
         i_X         : in std_logic_vector(N-1 downto 0);
         i_Y         : in std_logic_vector(N-1 downto 0);
         o_S          : out std_logic_vector(N-1 downto 0);
         o_F          : out std_logic;
         o_C          : out std_logic);
  
  end component;

  component mux2t1_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_S          : in std_logic;
         i_D0         : in std_logic_vector(N-1 downto 0);
         i_D1         : in std_logic_vector(N-1 downto 0);
         o_O          : out std_logic_vector(N-1 downto 0));
  
  end component;

  component mux2t1 is
    port(
        i_D0    : in std_logic;
        i_D1    : in std_logic;
        i_S     : in std_logic;
        o_O     : out std_logic);
  end component;

      signal s_InsIn        : std_logic_vector(27 downto 0);
      signal s_JumpAddress  : std_logic_vector(31 downto 0);
      signal s_Mux2Mux      : std_logic_vector(31 downto 0);
      signal s_Jump2Jump    : std_logic_vector(31 downto 0);

      signal s_ImmShf       : std_logic_vector(31 downto 0);
      signal s_ADD2Mux      : std_logic_vector(31 downto 0);

      signal s_MuxCtl       : std_logic;

      signal s_DC1          : std_logic := '0';
      signal s_DC2          : std_logic;
      signal s_DC3          : std_logic;

begin

    s_InsIn         <= i_Instruction(25 downto 0) & '0' & '0';
    s_JumpAddress   <= i_PCin(31 downto 28) & s_InsIn;
    s_ImmShf        <= i_Immediate(29 downto 0) & '0' & '0';



  g_MUX0: mux2t1
  port MAP(i_S              => i_Equal,
           i_D0             => i_BNE,
           i_D1             => i_BEQ,
           o_O              => s_MuxCtl);


  g_MUX1: mux2t1_N
  generic map(32)
  port MAP(i_S              => s_MuxCtl,
           i_D0             => i_PCin,
           i_D1             => s_ADD2Mux,
           o_O              => s_Mux2Mux);

  g_MUX2: mux2t1_N
  generic map(32)
  port MAP(i_S              => i_Jump,
           i_D0             => s_Mux2Mux,
           i_D1             => s_JumpAddress,
           o_O              => s_Jump2Jump);

  g_MUX3: mux2t1_N
  generic map(32)
  port MAP(i_S              => i_JumpRegister,
           i_D0             => s_Jump2Jump,
           i_D1             => i_Register,
           o_O              => o_PCout);

  g_ADD4: AddSub_N
  generic map(32)
  port MAP(nAdd_Sub         => s_DC1,
           i_X              => i_PCin,
           i_Y              => s_ImmShf,
           o_S              => s_ADD2Mux,
           o_F              => s_DC3,
           o_C              => s_DC2);
  
end structural;