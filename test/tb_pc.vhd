-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_pc.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;



entity tb_pc is
  generic(gCLK_HPER   : time := 50 ns);
end tb_pc;

architecture behavior of tb_pc is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  --constant n : integer :=16;

  component pc is
    port(i_CLK              : in std_logic;
         i_RST              : in std_logic;
         i_WE               : in std_logic;
         i_PCin             : in std_logic_vector(31 downto 0);
         o_PCout            : out std_logic_vector(31 downto 0));
  
  end component;
  

  -- Temporary signals to connect to the dff component.
  signal s_CLK : std_logic;
  signal s_WE : std_logic := '1';
  signal s_RST : std_logic := '1';
  signal s_PCin : std_logic_vector(31 downto 0) := 32x"0";
  signal s_PCout : std_logic_vector(31 downto 0);

begin

  DUT: pc 
  port map(i_CLK => s_CLK,
           i_WE => s_WE,
           i_RST => s_RST,
           i_PCin => s_PCin,
           o_PCout => s_PCout);

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

    -- Set to 0

    s_RST <= '0';

    wait for cCLK_PER;

    s_PCin <= 32x"0";

    wait for cCLK_PER;

    s_PCin <= 32x"4";

    wait for cCLK_PER;

    s_PCin <= 32x"4000";

    wait for cCLK_PER;

    s_PCin <= 32x"222222";

    wait for cCLK_PER;

    s_PCin <= 32x"AAAAAAA";
         

    wait;
  end process;
  
end behavior;
