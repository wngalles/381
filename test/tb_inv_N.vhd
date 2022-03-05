-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_or_N.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;



entity tb_inv_N is
  generic(gCLK_HPER   : time := 50 ns);
end tb_inv_N;

architecture behavior of tb_inv_N is
  
  -- Calculate the clock period as twice the half-period
  constant cCLK_PER  : time := gCLK_HPER * 2;
  --constant n : integer :=16;

  component inv_N is
    generic(N : integer := 32); 
    port(i_In1         : in std_logic_vector(N-1 downto 0);
         o_Out          : out std_logic_vector(N-1 downto 0));
  
  end component;
  

  signal s_CLK : std_logic;
  signal s_In1          : std_logic_vector(31 downto 0) := 32x"0";
  signal s_Out         : std_logic_vector(31 downto 0);

begin

  DUT: inv_N 
  port map(i_In1        => s_In1,
           o_Out        => s_Out);

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

    
    s_In1       <= 32x"00000000";

    wait for cCLK_PER;

    s_In1       <= 32x"CCCCCCCC";

    wait for cCLK_PER;

    s_In1       <= 32x"11111111";

    wait for cCLK_PER;

    s_In1       <= 32x"55555555";

    wait for cCLK_PER;

         

    wait;
  end process;
  
end behavior;
