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
           o_Change           : out std_logic;
           o_PCout            : out std_logic_vector(31 downto 0));
    
    end component;

    component pc is
      port(i_CLK              : in std_logic;
           i_RST              : in std_logic;
           i_WE               : in std_logic;
           i_Change           : in std_logic;
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

    component IF_ID is
      port(i_CLK              : in std_logic;
            i_Stall           : in std_logic;
            i_Flush           : in std_logic;
            i_PC4             : in std_logic_vector(31 downto 0);
            i_Instruction     : in std_logic_vector(31 downto 0);
            o_PC4             : out std_logic_vector(31 downto 0);
            o_Instruction     : out std_logic_vector(31 downto 0));
    
    end component;

    component ID_EX is
      port(i_CLK              : in std_logic;
            i_Stall           : in std_logic;
            i_Flush           : in std_logic;
    
            i_Jal             : in std_logic;
            i_ALU_Src         : in std_logic;
            i_Mem_Reg         : in std_logic;
            i_Mem_Wr          : in std_logic;
            i_Movn            : in std_logic;
            i_Reg_Wr          : in std_logic;
            i_Halt            : in std_logic;
    
            o_Jal             : out std_logic;
            o_ALU_Src         : out std_logic;
            o_Mem_Reg         : out std_logic;
            o_Mem_Wr          : out std_logic;
            o_Movn            : out std_logic;
            o_Reg_Wr          : out std_logic;
            o_Halt            : out std_logic;
    
            i_ALUop           : in std_logic_vector(6 downto 0);
            o_ALUop           : out std_logic_vector(6 downto 0);

            i_RegDest         : in std_logic_vector(4 downto 0);
            o_RegDest         : out std_logic_vector(4 downto 0);
    
            i_PC4             : in std_logic_vector(31 downto 0);
            i_Immediate       : in std_logic_vector(31 downto 0);
            i_Reg1            : in std_logic_vector(31 downto 0);
            i_Reg2            : in std_logic_vector(31 downto 0);
            i_Instruction     : in std_logic_vector(31 downto 0);
            o_PC4             : out std_logic_vector(31 downto 0);
            o_Immediate       : out std_logic_vector(31 downto 0);
            o_Reg1            : out std_logic_vector(31 downto 0);
            o_Reg2            : out std_logic_vector(31 downto 0);
            o_Instruction     : out std_logic_vector(31 downto 0));
    
    end component;

    component EX_MEM is
      port(i_CLK              : in std_logic;
            i_Stall           : in std_logic;
            i_Flush           : in std_logic;
    
            i_Jal             : in std_logic;
            i_Equal           : in std_logic;
            i_Mem_Reg         : in std_logic;
            i_Mem_Wr          : in std_logic;
            i_Movn            : in std_logic;
            i_Reg_Wr          : in std_logic;
            i_Halt            : in std_logic;
            i_Ovf             : in std_logic;
            
    
            o_Jal             : out std_logic;
            o_Equal           : out std_logic;
            o_Mem_Reg         : out std_logic;
            o_Mem_Wr          : out std_logic;
            o_Movn            : out std_logic;
            o_Reg_Wr          : out std_logic;
            o_Halt            : out std_logic;
            o_Ovf             : out std_logic;

            i_RegDest         : in std_logic_vector(4 downto 0);
            o_RegDest         : out std_logic_vector(4 downto 0);
    
            i_PC4             : in std_logic_vector(31 downto 0);
            i_ALUout          : in std_logic_vector(31 downto 0);
            i_Reg2            : in std_logic_vector(31 downto 0);
            o_PC4             : out std_logic_vector(31 downto 0);
            o_ALUout          : out std_logic_vector(31 downto 0);
            o_Reg2            : out std_logic_vector(31 downto 0));
    
    end component;

    component MEM_WB is
      port(i_CLK              : in std_logic;
            i_Stall           : in std_logic;
            i_Flush           : in std_logic;
    
            i_Jal             : in std_logic;
            i_Equal           : in std_logic;
            i_Mem_Reg         : in std_logic;
            i_Movn            : in std_logic;
            i_Reg_Wr          : in std_logic;
            i_Halt            : in std_logic;
            i_Ovf             : in std_logic;
    
            o_Jal             : out std_logic;
            o_Equal           : out std_logic;
            o_Mem_Reg         : out std_logic;
            o_Movn            : out std_logic;
            o_Reg_Wr          : out std_logic;
            o_Halt            : out std_logic;
            o_Ovf             : out std_logic;

            i_RegDest         : in std_logic_vector(4 downto 0);
            o_RegDest         : out std_logic_vector(4 downto 0);
    
            i_PC4             : in std_logic_vector(31 downto 0);
            i_ALUout          : in std_logic_vector(31 downto 0);
            i_Reg2            : in std_logic_vector(31 downto 0);
            i_MEMout          : in std_logic_vector(31 downto 0);
            o_PC4             : out std_logic_vector(31 downto 0);
            o_ALUout          : out std_logic_vector(31 downto 0);
            o_Reg2            : out std_logic_vector(31 downto 0);
            o_MEMout          : out std_logic_vector(31 downto 0));
    
    end component;

    component equals is

      port(i_In1        : in std_logic_vector(32-1 downto 0);
           i_In2        : in std_logic_vector(32-1 downto 0);
           o_Equal      : out std_logic);
    
    end component;



  -- TODO: You may add any additional signals or components your implementation 
  --       requires below this comment

  signal s_NoConnect               : std_logic_vector(19 downto 0);            -- signal no connnect for control vector

  --IF
  signal s_IF_PC4                  : std_logic_vector(31 downto 0);            -- signal PC + 4
  signal s_IF_PCEN                 : std_logic := '1';                         -- signal PC Enable
  signal s_IF_Stall                : std_logic := '1';                         -- signal PC-IF Stall
  signal s_IF_Flush                : std_logic := '0';                         -- signal PC-IF Flush
  
  --ID
  signal s_ID_PC4                  : std_logic_vector(31 downto 0);            -- signal PC + 4
  signal s_ID_PCReturn             : std_logic_vector(31 downto 0); -- signal PC Return

  signal s_ID_Stall                : std_logic := '1';                         -- signal IF-ID Stall
  signal s_ID_Flush                : std_logic := '0';                         -- signal IF-ID Flush

  signal s_ID_31                   : std_logic_vector(4 downto 0) := "11111";  -- signal ALU op from control to ALU

  signal s_ID_Inst                 : std_logic_vector(N-1 downto 0);           -- signal Instruction

  signal s_ID_R1out                : std_logic_vector(31 downto 0);            -- signal Register 1 out
  signal s_ID_R2out                : std_logic_vector(31 downto 0);            -- signal Register 2 out

  signal s_ID_RI                   : std_logic;                                -- signal Register destingation or R / I type instruction

  signal s_ID_Signed               : std_logic;                                -- signal Signed Signal for the Immediate extender
  signal s_ID_ImmExt               : std_logic_vector(31 downto 0);            -- signal Extended Immediate

  signal s_ID_ALUSrc               : std_logic;                                -- signal ALU Source Signal
  signal s_ID_ALUop                : std_logic_vector(6 downto 0);             -- signal ALU op from control to ALU

  signal s_ID_MemReg               : std_logic;                                -- signal ALU output vs Data mem output

  signal s_ID_MemWr                : std_logic;                                -- signal Memory Write
  signal s_ID_RegWr                : std_logic;                                -- signal Reg Write
  signal s_ID_Movn                 : std_logic;                                -- signal Movn Signal

  signal s_ID_Jal                  : std_logic;                                -- signal Jump and Link
  signal s_ID_Jr                   : std_logic;                                -- signal Jump Register
  signal s_ID_J                    : std_logic;                                -- signal Jump
  signal s_ID_Beq                  : std_logic;                                -- signal Branch Equals
  signal s_ID_Bne                  : std_logic;                                -- signal Branch Not Equals
  signal s_ID_Change               : std_logic := '0';                         -- signal For pc if we jump or branch

  signal s_ID_Equal                : std_logic;                                -- signal R1 R2 equal
  
  signal s_ID_Halt                 : std_logic;                                -- signal Halt

  signal s_ID_RegDst               : std_logic_vector(4 downto 0);             -- signal Register Destination

  --EX
  signal s_EX_Stall                : std_logic := '1';                         -- signal ID-EX Stall
  signal s_EX_Flush                : std_logic := '0';                         -- signal ID-EX Flush

  signal s_EX_R1out                : std_logic_vector(31 downto 0);            -- signal Register 1 out
  signal s_EX_R2out                : std_logic_vector(31 downto 0);            -- signal Register 2 out

  signal s_EX_PC4                  : std_logic_vector(31 downto 0);            -- signal PC + 4

  signal s_EX_ImmExt               : std_logic_vector(31 downto 0);            -- signal Extended Immediate
  signal s_EX_ALUSrc               : std_logic;                                -- signal ALU Source Signal
  signal s_EX_MuxToALU             : std_logic_vector(31 downto 0);            -- signal From R2 out / Immediate Mux to ALU

  signal s_EX_Inst                 : std_logic_vector(N-1 downto 0);           -- signal Instruction

  signal s_EX_ALUop                : std_logic_vector(6 downto 0);             -- signal ALU op from control to ALU

  signal s_EX_MemReg               : std_logic;                                -- signal ALU output vs Data mem output

  signal s_EX_MemWr                : std_logic;                                -- signal Memory Write
  signal s_EX_RegWr                : std_logic;                                -- signal Reg Write

  signal s_EX_Movn                 : std_logic;                                -- signal Movn Signal

  signal s_EX_Jal                  : std_logic;                                -- signal Jump and Link

  signal s_EX_Equal                : std_logic;                                -- signal ALU Equal
  signal s_EX_Halt                 : std_logic;                                -- signal Halt
  signal s_EX_Ovf                  : std_logic;                                -- signal Overflow

  signal s_EX_ALUout               : std_logic_vector(31 downto 0);            -- signal ALU out

  signal s_EX_RegDst               : std_logic_vector(4 downto 0);             -- signal Register Destination

  --MEM

  signal s_MEM_Stall               : std_logic := '1';                         -- signal ID-EX Stall
  signal s_MEM_Flush               : std_logic := '0';                         -- signal ID-EX Flush

  signal s_MEM_PC4                 : std_logic_vector(31 downto 0);            -- signal PC + 4

  signal s_MEM_MemReg              : std_logic;                                -- signal ALU output vs Data mem output

  signal s_MEM_RegWr               : std_logic;                                -- signal Reg Write

  signal s_MEM_Movn                : std_logic;                                -- signal Movn Signal

  signal s_MEM_Jal                 : std_logic;                                -- signal Jump and Link

  signal s_MEM_Equal               : std_logic;                                -- signal ALU Equal
  signal s_MEM_Halt                : std_logic;                                -- signal Halt
  signal s_MEM_Ovf                 : std_logic;                                -- signal Overflow

  signal s_MEM_RegDst              : std_logic_vector(4 downto 0);             -- signal Register Destination

  --WB
  
  signal s_WB_MemReg               : std_logic;                                -- signal ALU output vs Data mem output

  signal s_WB_RegWr                : std_logic;                                -- signal Reg Write

  signal s_WB_Movn                 : std_logic;                                -- signal Movn Signal

  signal s_WB_Jal                  : std_logic;                                -- signal Jump and Link

  signal s_WB_Equal                : std_logic;                                -- signal ALU Equal
  signal s_WB_NotEqual             : std_logic;                                -- signal ALU Not Equal

  signal s_WB_ALUout               : std_logic_vector(31 downto 0);            -- signal ALU out
  signal s_WB_MEMout               : std_logic_vector(31 downto 0);            -- signal Mem out
  signal s_WB_R2out                : std_logic_vector(31 downto 0);            -- signal Register 2 out
  signal s_WB_PC4                  : std_logic_vector(31 downto 0);            -- signal PC + 4

  signal s_WB_MuxALUvsMemToMovn    : std_logic_vector(31 downto 0);            -- signal ALU vs Mem mux to Movn Mux 
  signal s_WB_MuxMovnToJal         : std_logic_vector(31 downto 0);            -- signal Movn Mux to Jal data mux

  signal s_WB_RegDst               : std_logic_vector(4 downto 0);             -- signal Register Destination
  


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


  X_PC: pc      
    port map(i_CLK            => iCLK,
             i_RST            => iRST,
             i_WE             => s_IF_PCEN,
             i_Change         => s_ID_Change,
             i_PCin           => s_ID_PCReturn,
             o_PCout          => s_NextInstAddr,
             o_PC4out         => s_IF_PC4);   


  R_IF_ID: IF_ID
    port map(i_CLK            => iCLK,
             i_Stall          => s_IF_Stall,
             i_Flush          => iRST,
             i_PC4            => s_IF_PC4,
             i_Instruction    => s_Inst,
             o_PC4            => s_ID_PC4,
             o_Instruction    => s_ID_Inst); 

  X_RegFile: regFile
    port map(i_CLK            => iCLK,
             i_S              => s_RegWrAddr,
             i_R1             => s_ID_Inst(25 downto 21),
             i_R2             => s_ID_Inst(20 downto 16),
             i_WE             => s_RegWr,
             i_RST            => iRST,
             i_D              => s_RegWrData,
             o_Q1             => s_ID_R1out,
             o_Q2             => s_ID_R2out);

  X_MUX_RegDest_RI: mux2t1_N
    generic map(5)      
    port map(i_S              => s_ID_RI,
             i_D0             => s_ID_Inst(20 downto 16),
             i_D1             => s_ID_Inst(15 downto 11),
             o_O              => s_ID_RegDst); 

  X_MUX_RegDest_JAL: mux2t1_N
    generic map(5) 
    port map(i_S              => s_WB_Jal,
             i_D0             => s_WB_RegDst,
             i_D1             => s_ID_31,
             o_O              => s_RegWrAddr); 


  X_Control: control      
    port map(instruction      => s_ID_Inst,
             alusrc           => s_ID_ALUSrc,
             aluOp            => s_ID_ALUop,
             memToReg         => s_ID_MemReg,
             memWrite         => s_ID_MemWr,
             regWrite         => s_ID_RegWr,
             regDst           => s_ID_RI,
             jal              => s_ID_Jal,
             jr               => s_ID_Jr,
             beq              => s_ID_Beq,
             bne              => s_ID_Bne,
             movn             => s_ID_Movn,
             j                => s_ID_J,
             halt             => s_ID_Halt,
             signExt          => s_ID_Signed,
             control_vector   => s_NoConnect);   
             
  X_Fetch: fetch      
    port map(i_PCin           => s_ID_PC4,
             i_Instruction    => s_ID_Inst,
             i_Immediate      => s_ID_ImmExt,
             i_Register       => s_ID_R1out,
             i_Jump           => s_ID_J,
             i_JumpRegister   => s_ID_Jr,
             i_BEQ            => s_ID_Beq,
             i_BNE            => s_ID_Bne,
             i_Equal          => s_ID_Equal,
             o_Change         => s_ID_Change,
             o_PCout          => s_ID_PCReturn);   

  X_SignExtend: Bit16_32      
    port map(i_A              => s_ID_Inst(15 downto 0),
             i_S              => s_ID_Signed,
             o_O              => s_ID_ImmExt); 

  X_EQUAL: equals      
    port map(i_In1            => s_ID_R1out,
             i_In2            => s_ID_R2out,
             o_Equal          => s_ID_Equal);  

  R_ID_EX: ID_EX
    port map(i_CLK            => iCLK,
             i_Stall          => s_ID_Stall,
             i_Flush          => iRST,

             i_Jal            => s_ID_Jal,
             i_ALU_Src        => s_ID_ALUSrc,
             i_Mem_Reg        => s_ID_MemReg,
             i_Mem_Wr         => s_ID_MemWr,
             i_Movn           => s_ID_Movn,
             i_Reg_Wr         => s_ID_RegWr,
             i_Halt           => s_ID_Halt,
 
             o_Jal            => s_EX_Jal,
             o_ALU_Src        => s_EX_ALUSrc,
             o_Mem_Reg        => s_EX_MemReg,
             o_Mem_Wr         => s_EX_MemWr,
             o_Movn           => s_EX_Movn,
             o_Reg_Wr         => s_EX_RegWr,
             o_Halt           => s_EX_Halt,
 
             i_ALUop          => s_ID_ALUop,
             o_ALUop          => s_EX_ALUop,

             i_RegDest        => s_ID_RegDst,
             o_RegDest        => s_EX_RegDst,
 
             i_PC4            => s_ID_PC4,
             i_Immediate      => s_ID_ImmExt,
             i_Reg1           => s_ID_R1out,
             i_Reg2           => s_ID_R2out,
             i_Instruction    => s_ID_Inst,
             o_PC4            => s_EX_PC4,
             o_Immediate      => s_EX_ImmExt,
             o_Reg1           => s_EX_R1out,
             o_Reg2           => s_EX_R2out,
             o_Instruction    => s_EX_Inst); 

  X_ALU: ALU      
    port map(i_In1            => s_EX_R1out,
             i_In2            => s_EX_MuxToALU,
             i_ALUop          => s_EX_ALUop,
             i_Movn           => s_EX_Movn,
             i_SHAMT          => s_EX_Inst(10 downto 6),
             o_Equal          => s_EX_Equal,
             o_OverFlow       => s_EX_Ovf,
             o_Out1           => s_EX_ALUout);

  X_MUX_ImmediateVsRo2: mux2t1_N
    generic map(32)      
    port map(i_S              => s_EX_ALUSrc,
             i_D0             => s_EX_R2out,
             i_D1             => s_EX_ImmExt,
             o_O              => s_EX_MuxToALU); 


  R_EX_MEM: EX_MEM
    port map(i_CLK            => iCLK,
             i_Stall          => s_EX_Stall,
             i_Flush          => iRST,

             i_Jal            => s_EX_Jal,
             i_Equal          => s_EX_Equal,
             i_Mem_Reg        => s_EX_MemReg,
             i_Mem_Wr         => s_EX_MemWr,
             i_Movn           => s_EX_Movn,
             i_Reg_Wr         => s_EX_RegWr,
             i_Halt           => s_EX_Halt,
             i_Ovf            => s_EX_Ovf,
 
             o_Jal            => s_MEM_Jal,
             o_Equal          => s_MEM_Equal,
             o_Mem_Reg        => s_MEM_MemReg,
             o_Mem_Wr         => s_DMemWr,
             o_Movn           => s_MEM_Movn,
             o_Reg_Wr         => s_MEM_RegWr,
             o_Halt           => s_MEM_Halt,
             o_Ovf            => s_MEM_Ovf,

             i_RegDest        => s_EX_RegDst,
             o_RegDest        => s_MEM_RegDst,
 
             i_PC4            => s_EX_PC4,
             i_ALUout         => s_EX_ALUout,
             i_Reg2           => s_EX_R2out,
             o_PC4            => s_MEM_PC4,
             o_ALUout         => s_DMemAddr,
             o_Reg2           => s_DMemData); 

          
  R_MEM_WB: MEM_WB
    port map(i_CLK            => iCLK,
             i_Stall          => s_MEM_Stall,
             i_Flush          => iRST,

             i_Jal            => s_MEM_Jal,
             i_Equal          => s_MEM_Equal,
             i_Mem_Reg        => s_MEM_MemReg,
             i_Movn           => s_MEM_Movn,
             i_Reg_Wr         => s_MEM_RegWr,
             i_Halt           => s_MEM_Halt,
             i_Ovf            => s_MEM_Ovf,
 
             o_Jal            => s_WB_Jal,
             o_Equal          => s_WB_Equal,
             o_Mem_Reg        => s_WB_MemReg,
             o_Movn           => s_WB_Movn,
             o_Reg_Wr         => s_WB_RegWr,
             o_Halt           => s_Halt,
             o_Ovf            => s_Ovfl,

             i_RegDest        => s_MEM_RegDst,
             o_RegDest        => s_WB_RegDst,
 
             i_PC4            => s_MEM_PC4,
             i_ALUout         => s_DMemAddr,
             i_Reg2           => s_DMemData,
             i_MEMout         => s_DMemOut,
             o_PC4            => s_WB_PC4,
             o_ALUout         => s_WB_ALUout,
             o_Reg2           => s_WB_R2out,
             o_MEMout         => s_WB_MEMout); 
  

  X_MUX_WriteData_AluVsMem: mux2t1_N
    generic map(32)      
    port map(i_S              => s_WB_MemReg,
             i_D0             => s_WB_ALUout,
             i_D1             => s_WB_MEMout,
             o_O              => s_WB_MuxALUvsMemToMovn); 
  
  X_MUX_WriteData_Movn: mux2t1_N
    generic map(32)      
    port map(i_S              => s_WB_Movn,
             i_D0             => s_WB_MuxALUvsMemToMovn,
             i_D1             => s_WB_R2out,
             o_O              => s_WB_MuxMovnToJal);        
             
  X_MUX_WriteData_PcPlusFour: mux2t1_N
    generic map(32)      
    port map(i_S              => s_WB_Jal,
             i_D0             => s_WB_MuxMovnToJal,
             i_D1             => s_WB_PC4,        
             o_O              => s_RegWrData); 

  X_MUX_WriteReg_Movn: mux2t1    
    port map(i_S              => s_WB_Movn,
             i_D0             => s_WB_RegWr,
             i_D1             => s_WB_NotEqual,
             o_O              => s_RegWr); 

  
  X_MUX_InvEq_Movn: invg    
    port map(i_A              => s_WB_Equal,
             o_F              => s_WB_NotEqual); 


  oALUOut <= s_EX_ALUout;  --Important

end structure;

