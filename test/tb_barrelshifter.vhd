-------------------------------------------------------------------------
-- Austin Beinder
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- tb_barrelshifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a testbench for the barrelshifter
--              
-- 3/3/2022 by Austin Beinder::Design created.
-------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_textio.all;  -- For logic types I/O
library std;
use std.env.all;                -- For hierarchical/external signals
use std.textio.all;             -- For basic I/O

entity tb_barrelshifter is
  generic(gCLK_HPER   : time := 10 ns);   -- Generic for half of the clock cycle period
end tb_barrelshifter;

architecture mixed of tb_barrelshifter is

    -- Define the total clock period time
    constant cCLK_PER  : time := gCLK_HPER * 2;

    component barrelshifter is
        port(
          A : in std_logic_vector(32-1 downto 0);
          O : out std_logic_vector(32-1 downto 0);
          offset : in std_logic_vector(5-1 downto 0);
          left : in std_logic;
          arith : in std_logic
        );
    end component;

    signal A : std_logic_vector(32-1 downto 0);
    signal O : std_logic_vector(32-1 downto 0);
    signal offset : std_logic_vector(5-1 downto 0);
    signal left : std_logic;
    signal arith : std_logic := '0';

    signal test_case_number : integer;
    signal is_left : integer;

    signal expected : std_logic_vector(32-1 downto 0);
    signal passed : boolean;

    begin

    DUT0: barrelshifter
        port map(
            A => A,
            O => O,
            offset => offset,
            left => left,
            arith => arith
        );

    -- Assign inputs for each test case.
    P_TEST_CASES: process
    begin
        wait for gCLK_HPER;
        ----------------------------------------------
        -- all ones shift left 2
        A <= 32x"FFFFFFFF";
        offset <= "00010";
        left <= '0';

        expected <= 28x"FFFFFFF" & "1100";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 1;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- all ones shift left 3
        A <= 32x"FFFFFFFF";
        offset <= "00011";
        left <= '0';

        expected <= 28x"FFFFFFF" & "1000";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 2;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- all ones shift left 7
        A <= 32x"FFFFFFFF";
        offset <= "00111";
        left <= '0';

        expected <= 24x"FFFFFF" & "10000000";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 3;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- all ones shift right 7
        A <= 32x"FFFFFFFF";
        offset <= "00111";
        left <= '1';

        expected <= 32x"01FFFFFF";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 4;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- all ones shift right 25
        A <= 32x"FFFFFFFF";
        offset <= "11001";
        left <= '1';

        expected <= "00000000000000000000000001111111";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 5;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- all ones shift left 30
        A <= 32x"FFFFFFFF";
        offset <= "11110";
        left <= '0';

        expected <= "11000000000000000000000000000000";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 6;
        wait for gCLK_HPER*2;

        ----------------------------------------------
        -- all ones shift left 16
        A <= 32x"FFFFFFFF";
        offset <= "10000";
        left <= '0';

        expected <= 32x"FFFF0000";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 7;
        wait for gCLK_HPER*2;


        ----------------------------------------------
        -- all ones shift arith right 16
        A <= 32x"FFFFFFFF";
        offset <= "10000";
        left <= '1';
        arith <= '1';

        expected <= 32x"FFFFFFFF";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 8;
        wait for gCLK_HPER*2;


        ----------------------------------------------
        -- all ones shift arith right 16
        A <= 32x"80000000";
        offset <= "10000";
        left <= '1';
        arith <= '1';

        expected <= 32x"FFFF8000";
        wait for gCLK_HPER;
        passed <= expected = O;
        test_case_number <= 9;
        wait for gCLK_HPER*2;


    end process;

end mixed;