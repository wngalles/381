-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_mux2t1.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the 2-1 mux unit.
--              
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

-- Usually name your testbench similar to below for clarity tb_<name>
entity tb_rippleAdder_N is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_rippleAdder_N;

architecture mixed of tb_rippleAdder_N is

-- Define the total clock period time
constant cCLK_PER  : time := gCLK_HPER * 2;
constant n : integer :=32;

-- We will be instantiating our design under test (DUT), so we need to specify its
-- component interface.
component rippleAdder_N is
    generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
    port(i_C          : in std_logic;
         i_X         : in std_logic_vector(N-1 downto 0);
         i_Y         : in std_logic_vector(N-1 downto 0);
         o_S          : out std_logic_vector(N-1 downto 0);
         o_C          : out std_logic);
  
  end component;


-- Create signals for all of the inputs and outputs of the file that you are testing
-- := '0' or := (others => '0') just make all the signals start at an initial value of zero
signal CLK, reset : std_logic := '0';

-- TODO: change input and output signals as needed.
signal s_iC   : std_logic := '0';
signal s_X   : std_logic_vector(n-1 downto 0) := x"00000000";
signal s_Y   : std_logic_vector(n-1 downto 0) := x"00000000";
signal s_S   : std_logic_vector(n-1 downto 0);
signal s_oC   : std_logic;



begin

  DUT0: rippleAdder_N
  generic map(n)
  port map(
            i_C        => s_iC,
            i_X        => s_X,
            i_Y        => s_Y,
            o_S        => s_S,
            o_C        => s_oC);


  
  --This first process is to setup the clock for the test bench
  P_CLK: process
  begin
    CLK <= '1';         -- clock starts at 1
    wait for gCLK_HPER; -- after half a cycle
    CLK <= '0';         -- clock becomes a 0 (negative edge)
    wait for gCLK_HPER; -- after half a cycle, process begins evaluation again
  end process;

  -- This process resets the sequential components of the design.
  -- It is held to be 1 across both the negative and positive edges of the clock
  -- so it works regardless of whether the design uses synchronous (pos or neg edge)
  -- or asynchronous resets.
  P_RST: process
  begin
  	reset <= '0';   
    wait for gCLK_HPER/2;
	reset <= '1';
    wait for gCLK_HPER*2;
	reset <= '0';
	wait;
  end process;  
  
  -- Assign inputs for each test case.
  -- TODO: add test cases as needed.
  P_TEST_CASES: process
  begin
    wait for gCLK_HPER/2; -- for waveform clarity, I prefer not to change inputs on clk edges

    wait for gCLK_HPER*2;

    s_iC   <= '0';
    s_X    <= x"00000000";
    s_Y    <= x"00000000";
    
    wait for gCLK_HPER*2;

    s_iC   <= '1';
    s_X    <= x"00000000";
    s_Y    <= x"00000000";
    
    wait for gCLK_HPER*2;

    s_iC   <= '0';
    s_X    <= x"0F0F0F0F";
    s_Y    <= x"F0F0F0F0";
    
    wait for gCLK_HPER*2;

    s_iC   <= '0';
    s_X    <= x"10203040";
    s_Y    <= x"05060708";

    wait for gCLK_HPER*2;

    s_iC   <= '1';
    s_X    <= x"0F0F0F0F";
    s_Y    <= x"F0F0F0F0";

    wait for gCLK_HPER*2;

    s_iC   <= '1';
    s_X    <= x"FFFFFFFF";
    s_Y    <= x"FFFFFFFF";

    wait for gCLK_HPER*2;

    s_iC   <= '0';
    s_X    <= x"11111111";
    s_Y    <= x"22222222";

    wait for gCLK_HPER*2;

    s_iC   <= '1';
    s_X    <= x"00000016";
    s_Y    <= x"00000025";


    -- TODO: add test cases as needed (at least 3 more for this lab)
  end process;

end mixed;
