library IEEE;
use IEEE.std_logic_1164.all;

package my_array is
    type inputArray is array(0 to 31) of std_logic_vector(31 downto 0);
end my_array;