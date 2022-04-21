-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- hazard.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity hazard is
  port( i_RegWrEX         : in std_logic;
        i_RegDestEX       : in std_logic_vector(4 downto 0);
        i_RegWrMEM        : in std_logic;
        i_RegDestMEM      : in std_logic_vector(4 downto 0);
        i_Reg1            : in std_logic_vector(4 downto 0);
        i_Reg2            : in std_logic_vector(4 downto 0);

        i_PCupdate        : in std_logic;

        o_PCstall         : out std_logic;  --Data Hazard
        o_IDstall         : out std_logic;  --Control Hazard
        o_IDflush         : out std_logic;  --Control Hazard
        o_EXstall         : out std_logic;  --Data Hazard
        o_EXflush         : out std_logic); --Data Hazard

end hazard;

architecture structural of hazard is

    component equalsHaz is

        port(i_In1        : in std_logic_vector(4 downto 0);
             i_In2        : in std_logic_vector(4 downto 0);
             i_We         : in std_logic;
             o_Equal      : out std_logic);
      
      end component;

    signal R1_EX          : std_logic;  
    signal R1_MEM         : std_logic; 
    signal R2_EX          : std_logic; 
    signal R2_MEM         : std_logic;
    
    signal DataHaz        : std_logic;
    signal NotDataHaz     : std_logic;

    signal ControlHaz     : std_logic;

    signal NotOr          : std_logic;


begin

    H_EQUAL_R1_EX: equalsHaz      
    port map(i_In1            => i_Reg1,
             i_In2            => i_RegDestEX,
             i_We             => i_RegWrEX,
             o_Equal          => R1_EX);  

    H_EQUAL_R1_MEM: equalsHaz      
    port map(i_In1            => i_Reg1,
             i_In2            => i_RegDestMEM,
             i_We             => i_RegWrMEM,
             o_Equal          => R1_MEM);  

    H_EQUAL_R2_EX: equalsHaz      
    port map(i_In1            => i_Reg2,
             i_In2            => i_RegDestEX,
             i_We             => i_RegWrEX,
             o_Equal          => R2_EX);  

    H_EQUAL_R2_MEM: equalsHaz      
    port map(i_In1            => i_Reg2,
             i_In2            => i_RegDestMEM,
             i_We             => i_RegWrMEM,
             o_Equal          => R2_MEM);  

    DataHaz <= R1_EX or R1_MEM or R2_EX or R2_MEM;

    ControlHaz <= i_PCupdate;
    NotDataHaz <= not DataHaz;
    
    o_EXstall <= not DataHaz;
    o_EXflush <= DataHaz;
    o_PCstall <= not DataHaz;

    NotOr <= DataHaz or ControlHaz;

    o_IDstall <= not NotOr;
    o_IDflush <= ControlHaz and NotDataHaz;
    


  
end structural;
