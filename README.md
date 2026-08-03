# 32-bit 5-Stage Pipelined RISC-V CPU

A SystemVerilog implementation of a RISC-V processor supporting a subset of RV32I.
The processor was initially implemented as a single-cycle CPU and later extended into a 5-stage pipelined architecture with forwarding, load-use hazard detection, stalling, and control-hazard flushing. The design is based on the processor architecture presented in *Digital Design and Computer Architecture: RISC-V Edition* by Harris and Harris. Verification is performed using SystemVerilog self-checking testbenches. The completed processor was also synthesized, implemented, and tested on a Digilent Basys 3 FPGA. The pipelined implementation includes the original instruction set while allowing multiple instructions to execute concurrently across the five stages.

## Supported Instructions

| Category | Instructions |
|---|---|
| Arithmetic | `add`, `sub`, `addi` |
| Logical | `and`, `or`, `andi`, `ori` |
| Comparison | `slt`, `slti` |
| Memory | `lw`, `sw` |
| Control Flow | `beq`, `jal` |

## Architecture

The final processor uses a 5-stage pipeline:

1. **IF - Instruction Fetch**
2. **ID - Instruction Decode / Register Read**
3. **EX - Execute / Address Calculation / Branch Resolution**
4. **MEM - Data Memory Access**
5. **WB - Register Writeback**

Pipeline registers separate each stage:

- IF/ID
- ID/EX
- EX/MEM
- MEM/WB

The design is divided into three main sections:

- **Controller:** Decodes the instruction in the ID stage and generates the required control signals.
- **Datapath:** Contains the program counter, register file, ALU, immediate extender, adders, multiplexers, forwarding paths, and pipeline registers.
- **Memory system:** Contains separate instruction and data memories.

The controller is further divided into:

- `mainDecoder`: Generates the main control signals from the opcode.
- `aluDecoder`: Selects the ALU operation using `aluOperation`, `funct3`, the opcode, and the relevant `funct7` bit.

## Pipeline Operation

Multiple instructions are executed concurrently, with each instruction occupying a different pipeline stage.

For example:

```text
Cycle          1    2    3    4    5    6    7
------------------------------------------------
Instruction 1  IF   ID   EX   MEM  WB
Instruction 2       IF   ID   EX   MEM  WB
Instruction 3            IF   ID   EX   MEM  WB
```
Under normal operation, a new instruction enters the pipeline every clock cycle.

## Hazard Handling

The processor contains a hazard unit that handles data and control hazards.

### Forwarding

ALU operands can be forwarded from later pipeline stages when the required value has not been written back to the register file.

Forwarding sources include:

- EX/MEM stage
- MEM/WB stage

The forwarding unit compares the source registers of the instruction in Execute with destination registers of instructions later in the pipeline.

### Load-Use Hazards

A load-use hazard occurs when an instruction immediately following an `lw` requires the value being loaded.

Because the loaded value is not available early enough for normal forwarding, the processor:

- stalls the IF stage
- stalls the ID stage
- inserts a bubble into the EX stage

The bubble is created by clearing the Execute-stage control signals.

### Control Hazards

Branches and jumps are resolved in the Execute stage.

When a branch is taken or a jump occurs:

- the program counter is redirected to the target address
- the wrong-path instruction in the IF/ID register is flushed
- the wrong-path instruction entering the EX stage is converted into a bubble

The control-transfer decision is generated using:

```text
PCSrcE = (BranchE AND ZeroE) OR JumpE
```

## Design Behavior

- The program counter and pipeline registers update on the rising edge of the clock.
- The register file writes on the falling edge of the clock.
- Instruction-memory reads are asynchronous.
- Data-memory reads are asynchronous.
- Data-memory writes occur on the rising edge of the clock.
- Register `x0` always reads as zero and cannot be modified.
- The program counter normally advances by four.
- Taken branches and jumps replace PC + 4 with the calculated target address.
- Branch decisions are made using the ALU zero flag.
- Forwarding is used to resolve supported data hazards without stalling.
- Load-use dependencies cause a one-cycle pipeline stall.
- Instructions and data are accessed using word-aligned addresses.
- The FPGA implementation operates the processor at 50 MHz using a generated clock derived from the Basys 3's 100 MHz oscillator.

## Simulation Verification

The project contains three self-checking testbenches.

| Testbench | Purpose |
|---|---|
| `controller_tb.sv` | Verifies instruction decoding and generated control signals |
| `datapath_tb.sv` | Verifies pipeline registers, forwarding paths, stalls, flushes, ALU behavior, and writeback selection |
| `top_tb.sv` | Runs a complete program through the processor, instruction memory, and data memory |

The testbenches use `$fatal` to stop the simulation when an incorrect result is detected.

## Integration Test

The integration test loads a program from `program.hex`. The program performs operations including:

- Register-immediate arithmetic
- Register-register arithmetic
- Loads and stores
- Data dependencies requiring forwarding
- A load-use dependency requiring a pipeline stall
- A loop using `beq` and `jal`
- Signed comparison using `slt`
- Taken and not-taken branches

The program reads the values `7` and `-3` from data memory, processes them, and stores the expected result `5` at byte address `0x48`.

The integration test also verifies that an earlier dependent store correctly writes `5` to byte address `0x04`.

The final expected results are:

```text
dataMemory.memory[1]  = 5
dataMemory.memory[18] = 5
x2                    = 1
x3                    = 13
x4                    = 5
```
## FPGA Implementation

The processor was synthesized and implemented in Vivado for a Digilent Basys 3 FPGA using the Artix-7 XC7A35T device.

The Basys 3 provides a 100 MHz input clock. Initial timing analysis at 100 MHz produced errors related to toming so a 50 MHz processor clock was therefore generated from the board's 100 MHz clock using the Vivado Clocking Wizard.

For hardware testing, data memory is initialized with:

```text
memory[16] = 7
memory[17] = -3
memory[18] = 0
```

## Running the Integration Test

The project can be compiled from the repository root using Icarus Verilog:

```bash
iverilog -g2012 -Wall -s top_tb -o top_tb.vvp $sourceFiles Processor/processor.sv top.sv Processor/Testbenches/top_tb.sv
```

Run the compiled simulation with: 

```bash
vvp top_tb.vvp
```