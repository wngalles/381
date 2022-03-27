-------------------------------------------------------------------------
-- Will Galles
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------
-- ALU.vhd
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity ALU is
  port( i_In1             : in std_logic_vector(31 downto 0);
        i_In2             : in std_logic_vector(31 downto 0);
        i_ALUop           : in std_logic_vector(6 downto 0);
        i_Movn            : in std_logic;
        i_SHAMT           : in std_logic_vector(4 downto 0);
        o_Equal           : out std_logic;
        o_OverFlow        : out std_logic;
        o_Out1            : out std_logic_vector(31 downto 0));

end ALU;

architecture structural of ALU is

    component mux32t1_8 is
      port(i_S          : in std_logic_vector(2 downto 0);
           i_D          : in ALUArray;
           o_Q          : out std_logic_vector(31 downto 0));
    end component;

    component AddSub_N is
        generic(N : integer := 16); -- Generic of type integer for input/output data width. Default value is 32.
        port(nAdd_Sub     : in std_logic;
             i_X         : in std_logic_vector(N-1 downto 0);
             i_Y         : in std_logic_vector(N-1 downto 0);
             o_S          : out std_logic_vector(N-1 downto 0);
             o_F          : out std_logic;
             o_C          : out std_logic);
      
    end component;

    component and_N is
        generic(N : integer := 32); 
        port(i_In1         : in std_logic_vector(N-1 downto 0);
             i_In2         : in std_logic_vector(N-1 downto 0);
             o_Out          : out std_logic_vector(N-1 downto 0));
      
    end component;

    component or_N is
        generic(N : integer := 32); 
        port(i_In1         : in std_logic_vector(N-1 downto 0);
             i_In2         : in std_logic_vector(N-1 downto 0);
             o_Out          : out std_logic_vector(N-1 downto 0));
      
    end component;

    component xor_N is
        generic(N : integer := 32); 
        port(i_In1         : in std_logic_vector(N-1 downto 0);
             i_In2         : in std_logic_vector(N-1 downto 0);
             o_Out          : out std_logic_vector(N-1 downto 0));
      
    end component;

    component inv_N is
        generic(N : integer := 32); 
        port(i_In1         : in std_logic_vector(N-1 downto 0);
             o_Out          : out std_logic_vector(N-1 downto 0));
      
    end component;

    component mux2t1_N is
        generic(N : integer := 32); 
        port(i_S          : in std_logic;
             i_D0         : in std_logic_vector(N-1 downto 0);
             i_D1         : in std_logic_vector(N-1 downto 0);
             o_O          : out std_logic_vector(N-1 downto 0));
      
    end component;

    component equalZero is

        port(i_In         : in std_logic_vector(32-1 downto 0);
             o_EqualZero  : out std_logic);
      
    end component;
      

    component barrelshifter is
        port(A : in std_logic_vector(32-1 downto 0);
             O : out std_logic_vector(32-1 downto 0);
             offset : in std_logic_vector(5-1 downto 0);
             left : in std_logic;
             arith : in std_logic);
    end component;


    

    signal s_S                     : std_logic_vector(31 downto 0);
    signal s_OpSelect              : ALUArray;
    signal s_OrSplit               : std_logic_vector(31 downto 0);

    signal s_MovnHold              : std_logic_vector(31 downto 0);
    signal s_Zero                  : std_logic_vector(31 downto 0) := x"00000000";

    signal s_AdderSubO             : std_logic_vector(31 downto 0);

    signal s_TEMP_OVERFLOW         : std_logic;
    signal s_NC                    : std_logic;

    signal temp : std_logic_vector(31 downto 0);

begin



  MUX_MOVN: mux2t1_N 
  port map(i_S          => i_Movn,
           i_D0         => i_In1,
           i_D1         => s_Zero,
           o_O          => s_MovnHold);

  MUX_COMPARE: mux2t1_N 
  port map(i_S          => i_ALUop(3),
           i_D0         => s_AdderSubO,
           i_D1         => "0000000000000000000000000000000" & s_AdderSubO(31), --31x"0"
           o_O          => s_OpSelect(0)); --Check THIS


  ADDnSUB: AddSub_N
  generic map(32)
  port MAP(nAdd_Sub     => i_ALUop(2), --CHECK THIS
           i_X          => s_MovnHold,
           i_Y          => i_In2,
           o_S          => s_AdderSubO, 
           o_F          => s_TEMP_OVERFLOW,
           o_C          => s_NC);

  GAND: and_N 
  port map(i_In1        => i_In1,
           i_In2        => i_In2,
           o_Out        => s_OpSelect(1)); --Check THIS

  GOR: or_N 
  port map(i_In1        => i_In1,
           i_In2        => i_In2,
           o_Out        => s_OrSplit);

  s_OpSelect(2) <=  s_OrSplit; --Check THIS

  GNOR: inv_N 
  port map(i_In1        => s_OrSplit,
           o_Out        => s_OpSelect(3)); --Check THIS

  GXOR: xor_N 
  port map(i_In1        => i_In1,
           i_In2        => i_In2,
           o_Out        => s_OpSelect(4));


  GZERO: equalZero 
  port map(i_In         => s_AdderSubO,
           o_EqualZero  => o_Equal); --Check THIS 


  SHIFTER: barrelshifter 
  port map(
           A         => i_In2,          
           O         => s_OpSelect(5),  
           Offset    => i_SHAMT,
           left      => i_ALUop(1),
           arith     => i_ALUop(0));  


  s_OpSelect(6) <=  i_In2(15 downto 0) & x"0000"; --Lui
  s_OpSelect(7) <=  s_OpSelect(0); --Unsigned       

  MUX_Op: mux32t1_8 
  port map(
           i_S       => i_ALUop(6 downto 4),          
           i_D       => s_OpSelect,  
           o_Q       => o_Out1);  


    with i_ALUop(6 downto 4) select o_OverFlow <=
        s_TEMP_OVERFLOW when "111",
        '0' when others;

  
  
end structural;
