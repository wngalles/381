-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_fetch.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;



entity tb_fetch is
  generic(gCLK_HPER   : time := 50 ns);
end tb_fetch;

architecture behavior of tb_fetch is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  --constant n : integer :=16;

  component fetch is
    port(i_PCin             : in std_logic_vector(31 downto 0);
         i_Instruction      : in std_logic_vector(31 downto 0);
         i_Immediate        : in std_logic_vector(31 downto 0);
         i_Jump             : in std_logic;
         i_Branch           : in std_logic;
         i_Zero             : in std_logic;
         o_PCout            : out std_logic_vector(31 downto 0));
  
  end component;
  

  signal s_CLK : std_logic;
  signal s_PCin         : std_logic_vector(31 downto 0) := 32x"0";
  signal s_Instruction  : std_logic_vector(31 downto 0) := 32x"0";
  signal s_Immediate    : std_logic_vector(31 downto 0) := 32x"0";
  signal s_Jump         : std_logic;
  signal s_Branch       : std_logic;
  signal s_Zero         : std_logic;
  
  signal s_PCout : std_logic_vector(31 downto 0);

begin

  DUT: fetch 
  port map(i_PCin           => s_PCin,
           i_Instruction    => s_Instruction,
           i_Immediate      => s_Immediate,
           i_Jump           => s_Jump,
           i_Branch         => s_Branch,
           i_Zero           => s_Zero,
           o_PCout          => s_PCout);

  -- This process sets the clock value (low for gCLK_HPER, then high
  -- for gCLK_HPER). Absent a "wait" command, processes restart 
  -- at the beginning once they have reached the final statement.
  P_CLK: process
  begin
    s_CLK <= '0';
    wait for gCLK_HPER;
    s_CLK <= '1';
    wait for gCLK_HPER;
  end process;
  
  -- Testbench process  
  P_TB: process
  begin

    
    s_PCin          <= 32x"000000A";
    s_Instruction   <= 32x"FFFF";
    s_Immediate     <= 32x"4";
    s_Jump          <= '0';
    s_Branch        <= '0';
    s_Zero          <= '0';

    wait for cCLK_PER;

    s_PCin          <= 32x"A";
    s_Instruction   <= 32x"FFFF";
    s_Immediate     <= 32x"4";
    s_Jump          <= '0';
    s_Branch        <= '1';
    s_Zero          <= '0';

    wait for cCLK_PER;

    s_PCin          <= 32x"A";
    s_Instruction   <= 32x"FFFF";
    s_Immediate     <= 32x"4";
    s_Jump          <= '0';
    s_Branch        <= '1';
    s_Zero          <= '1';

    wait for cCLK_PER;

    s_PCin          <= 32x"F000000A";
    s_Instruction   <= 32x"FFFF";
    s_Immediate     <= 32x"4";
    s_Jump          <= '1';
    s_Branch        <= '1';
    s_Zero          <= '1';

    wait for cCLK_PER;

         

    wait;
  end process;
  
end behavior;
