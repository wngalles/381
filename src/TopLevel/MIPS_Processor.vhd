-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
  generic(N : integer := DATA_WIDTH);
  port(iCLK            : in std_logic;
       iRST            : in std_logic;
       iInstLd         : in std_logic;
       iInstAddr       : in std_logic_vector(N-1 downto 0);
       iInstExt        : in std_logic_vector(N-1 downto 0);
       oALUOut         : out std_logic_vector(N-1 downto 0)); -- TODO: Hook this up to the output of the ALU. It is important for synthesis that you have this output that can effectively be impacted by all other components so they are not optimized away.

end  MIPS_Processor;


architecture structure of MIPS_Processor is

  -- Required data memory signals
  signal s_DMemWr       : std_logic; -- TODO: use this signal as the final active high data memory write enable signal
  signal s_DMemAddr     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
  signal s_DMemData     : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
  signal s_DMemOut      : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
  -- Required register file signals 
  signal s_RegWr        : std_logic; -- TODO: use this signal as the final active high write enable input to the register file
  signal s_RegWrAddr    : std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
  signal s_RegWrData    : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final register data input

  -- Required instruction memory signals
  signal s_IMemAddr     : std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
  signal s_NextInstAddr : std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
  signal s_Inst         : std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

  -- Required halt signal -- for simulation
  signal s_Halt         : std_logic;  -- TODO: this signal indicates to the simulation that intended program execution has completed. (Opcode: 01 0100)

  -- Required overflow signal -- for overflow exception detection
  signal s_Ovfl         : std_logic;  -- TODO: this signal indicates an overflow exception would have been initiated

  component mem is
    generic(ADDR_WIDTH : integer;
            DATA_WIDTH : integer);
    port(
          clk          : in std_logic;
          addr         : in std_logic_vector((ADDR_WIDTH-1) downto 0);
          data         : in std_logic_vector((DATA_WIDTH-1) downto 0);
          we           : in std_logic := '1';
          q            : out std_logic_vector((DATA_WIDTH -1) downto 0));
    end component;

    component control is
      port(
        instruction : in std_logic_vector(32-1 downto 0);
    
        alusrc : out std_logic;
        aluOp : out std_logic_vector(7-1 downto 0);
        memToReg : out std_logic;
        memWrite : out std_logic;
        regWrite : out std_logic;
        regDst : out std_logic;
        jal : out std_logic;
        jr : out std_logic;
        beq : out std_logic;
        bne : out std_logic;
        movn : out std_logic;
        j : out std_logic;
        halt : out std_logic;
        signExt : out std_logic;
        control_vector : out std_logic_vector(20-1 downto 0)
      );
      end component;

    component regFile is
      port(i_CLK         : in std_logic;
            i_S          : in std_logic_vector(4 downto 0);
            i_R1         : in std_logic_vector(4 downto 0);
            i_R2         : in std_logic_vector(4 downto 0);
            i_WE         : in std_logic;
            i_RST        : in std_logic;
            i_D          : in std_logic_vector(31 downto 0);
            o_Q1         : out std_logic_vector(31 downto 0);
            o_Q2         : out std_logic_vector(31 downto 0));
    
    end component;

    component ALU is
      port( i_In1             : in std_logic_vector(31 downto 0);
            i_In2             : in std_logic_vector(31 downto 0);
            i_ALUop           : in std_logic_vector(6 downto 0);
            i_Movn            : in std_logic;
            i_SHAMT           : in std_logic_vector(4 downto 0);
            o_Equal           : out std_logic;
            o_OverFlow        : out std_logic;
            o_Out1            : out std_logic_vector(31 downto 0));
    
    end component;

    component fetch is
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
    
    end component;

    component pc is
      port(i_CLK              : in std_logic;
           i_RST              : in std_logic;
           i_WE               : in std_logic;
           i_PCin             : in std_logic_vector(31 downto 0);
           o_PCout            : out std_logic_vector(31 downto 0);
           o_PC4out            : out std_logic_vector(31 downto 0));
    
    end component;

    component Bit16_32 is
      port( i_A          : in std_logic_vector(15 downto 0);
            i_S          : in std_logic;
            o_O          : out  std_logic_vector(31 downto 0));
    
    end component;

    component mux2t1_N is
      generic(N : integer);
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

    component invg is

      port(i_A          : in std_logic;
           o_F          : out std_logic);
    
    end component;



  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  signal s_Ro1ToALU             : std_logic_vector(31 downto 0);            -- signal from reg out 1 of regfile to ALU
  signal s_MuxToALU             : std_logic_vector(31 downto 0);            -- signal from Ro1 / Immediate Mux to ALU
  signal s_ALUop                : std_logic_vector(6 downto 0);             -- signal ALU op from control to ALU
        
  signal s_Movn                 : std_logic;                                -- signal Movn Signal
  signal s_Equal                : std_logic;                                -- signal Equal Signals
  signal s_NotEqual             : std_logic;                                -- signal Equal Signals
  signal s_ALUSrc               : std_logic;                                -- signal ALU Source Signal
  signal s_MemToReg             : std_logic;                                -- signal ALU output vs Data mem output
  signal s_RegWrite             : std_logic;                                -- signal Register Write control Signal
  signal s_RegDestRI            : std_logic;                                -- signal Register destingation or R / I type instruction
  signal s_Jal                  : std_logic;                                -- signal Jump and Link
  signal s_Jr                   : std_logic;                                -- signal Jump Register
  signal s_Beq                  : std_logic;                                -- signal Branch Equals
  signal s_Bne                  : std_logic;                                -- signal Branch Not Equals
  signal s_J                    : std_logic;                                -- signal Jump
        
        
  signal s_NoConnect            : std_logic_vector(19 downto 0);            -- signal no connnect for control vector
        
  signal s_PC4                  : std_logic_vector(31 downto 0);            -- signal PC + 4
  signal s_PCReturn             : std_logic_vector(31 downto 0);            -- signal PC Return
  signal s_ImmExt               : std_logic_vector(31 downto 0);            -- signal Extended Immediate
  signal s_31                   : std_logic_vector(4 downto 0) := 5x"1F";   -- signal ALU op from control to ALU
        
  signal s_PCEN                 : std_logic := '1';                         -- signal Jump
  signal s_Signed               : std_logic;                                -- signal Signed Signal for the Immediate extender
        
  signal s_MuxRItoJAL           : std_logic_vector(4 downto 0);             -- signal R / I reg control signal to Jal control mux
        
  signal s_MuxMovnToJal         : std_logic_vector(31 downto 0);            -- signal Movn Mux to Jal data mux
  signal s_MuxALUvsMemToMovn    : std_logic_vector(31 downto 0);            -- signal ALU vs Mem mux to Movn Mux 

  


begin

  -- TODO: This is required to be your final input to your instruction memory. This provides a feasible method to externally load the memory module which means that the synthesis tool must assume it knows nothing about the values stored in the instruction memory. If this is not included, much, if not all of the design is optimized out because the synthesis tool will believe the memory to be all zeros.
  with iInstLd select
    s_IMemAddr <= s_NextInstAddr when '0',
      iInstAddr when others;


  IMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_IMemAddr(11 downto 2),
             data => iInstExt,
             we   => iInstLd,
             q    => s_Inst);
  
  DMem: mem
    generic map(ADDR_WIDTH => ADDR_WIDTH,
                DATA_WIDTH => N)
    port map(clk  => iCLK,
             addr => s_DMemAddr(11 downto 2),
             data => s_DMemData,
             we   => s_DMemWr,
             q    => s_DMemOut);

  -- TODO: Ensure that s_Halt is connected to an output control signal produced from decoding the Halt instruction (Opcode: 01 0100)
  -- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

  -- TODO: Implement the rest of your processor below this comment! 



  X_RegFile: regFile
    port map(i_CLK            => iCLK,
             i_S              => s_RegWrAddr,
             i_R1             => s_Inst(25 downto 21),
             i_R2             => s_Inst(20 downto 16),
             i_WE             => s_RegWr,
             i_RST            => iRST,
             i_D              => s_RegWrData,
             o_Q1             => s_Ro1ToALU,
             o_Q2             => s_DMemData);

  X_ALU: ALU      
    port map(i_In1            => s_Ro1ToALU,
             i_In2            => s_MuxToALU,
             i_ALUop          => s_ALUop,
             i_Movn           => s_Movn,
             i_SHAMT          => s_Inst(10 downto 6),
             o_Equal          => s_Equal,
             o_OverFlow       => s_Ovfl,
             o_Out1           => s_DMemAddr);

  X_Control: control      
    port map(instruction      => s_Inst,
             alusrc           => s_ALUSrc,
             aluOp            => s_ALUop,
             memToReg         => s_MemToReg,
             memWrite         => s_DMemWr,
             regWrite         => s_RegWrite,
             regDst           => s_RegDestRI,
             jal              => s_Jal,
             jr               => s_Jr,
             beq              => s_Beq,
             bne              => s_Bne,
             movn             => s_Movn,
             j                => s_J,
             halt             => s_Halt,
             signExt          => s_Signed,
             control_vector   => s_NoConnect);   
             
  X_Fetch: fetch      
    port map(i_PCin           => s_PC4,
             i_Instruction    => s_Inst,
             i_Immediate      => s_ImmExt,
             i_Register       => s_Ro1ToALU,
             i_Jump           => s_J,
             i_JumpRegister   => s_Jr,
             i_BEQ            => s_Beq,
             i_BNE            => s_Bne,
             i_Equal          => s_Equal,
             o_PCout          => s_PCReturn);    
             
  X_PC: pc      
    port map(i_CLK            => iCLK,
             i_RST            => iRST,
             i_WE             => s_PCEN,
             i_PCin           => s_PCReturn,
             o_PCout          => s_NextInstAddr,
             o_PC4out         => s_PC4);   

  X_SignExtend: Bit16_32      
    port map(i_A              => s_Inst(15 downto 0),
             i_S              => s_Signed,
             o_O              => s_ImmExt); 

  X_MUX_RegDest_RI: mux2t1_N
    generic map(5)      
    port map(i_S              => s_RegDestRI,
             i_D0             => s_Inst(20 downto 16),
             i_D1             => s_Inst(15 downto 11),
             o_O              => s_MuxRItoJAL); 

  X_MUX_RegDest_JAL: mux2t1_N
    generic map(5) 
    port map(i_S              => s_Jal,
             i_D0             => s_MuxRItoJAL,
             i_D1             => s_31,
             o_O              => s_RegWrAddr); 
             
  X_MUX_WriteData_PcPlusFour: mux2t1_N
    generic map(32)      
    port map(i_S              => s_Jal,
             i_D0             => s_MuxMovnToJal,
             i_D1             => s_PC4,        
             o_O              => s_RegWrData); 

  X_MUX_WriteData_Movn: mux2t1_N
    generic map(32)      
    port map(i_S              => s_Movn,
             i_D0             => s_MuxALUvsMemToMovn,
             i_D1             => s_Ro1ToALU,
             o_O              => s_MuxMovnToJal); 

  X_MUX_WriteData_AluVsMem: mux2t1_N
    generic map(32)      
    port map(i_S              => s_MemToReg,
             i_D0             => s_DMemAddr,
             i_D1             => s_DMemOut,
             o_O              => s_MuxALUvsMemToMovn); 

  X_MUX_ImmediateVsRo2: mux2t1_N
    generic map(32)      
    port map(i_S              => s_ALUSrc,
             i_D0             => s_DMemData,
             i_D1             => s_ImmExt,
             o_O              => s_MuxToALU); 

  X_MUX_WriteReg_Movn: mux2t1    
    port map(i_S              => s_Movn,
             i_D0             => s_RegWrite,
             i_D1             => s_NotEqual,
             o_O              => s_RegWr); 

  
  X_MUX_InvEq_Movn: invg    
    port map(i_A              => s_Equal,
             o_F              => s_NotEqual); 


  oALUOut <= s_DMemAddr;

end structure;

