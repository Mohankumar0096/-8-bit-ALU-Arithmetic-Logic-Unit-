8-bit ALU (Arithmetic Logic Unit)

Verilog HDL – ModelSim Project

Project Overview

An 8-bit Arithmetic Logic Unit (ALU) is a combinational digital circuit that performs arithmetic and logical operations on two 8-bit input operands. This project develops the ALU progressively from basic operations to status flags, self-checking verification, directed and random testing, and signed arithmetic with proper overflow handling. The design is implemented in Verilog HDL and functionally verified using ModelSim.

Objectives

1. Design and implement an 8-bit ALU using Verilog HDL.

2. Implement arithmetic and logical operations using opcode-based control.

3. Add Carry, Zero, Negative, and Overflow status flags.

4. Develop self-checking verification using expected-versus-actual comparison.

5. Apply directed and random testing to improve functional coverage.

6. Implement signed arithmetic using 8-bit two's-complement representation and verify signed overflow conditions.

Architecture

Inputs:

A[7:0] – first 8-bit operand

B[7:0] – second 8-bit operand

opcode[3:0] – operation select

Outputs:

result[7:0] – 8-bit ALU result

carry – carry/no-borrow status

zero – zero-result indicator

negative – negative-result indicator

overflow – signed overflow indicator

Data Flow:

A[7:0] ──┐

         ├──> 8-bit ALU ───> result[7:0]

B[7:0] ──┘          │

opcode[3:0] ────────┤

                    └──> C, Z, N, V

Development Methodology

Requirements → RTL Design → Functional Expansion → Status Flags → Self-Checking Verification → Directed & Random Testing → Signed Arithmetic & Overflow Verification.

Each level extends the previous design and is simulated and verified in ModelSim before progressing.

Development Levels

Level 1 — Basic 4-Operation ALU

Objective: Implement fundamental ALU operations.

Implementation: ADD, SUB, AND, OR with 8-bit result generation.

Level 2 — 11-Operation ALU

Objective: Expand ALU functionality.

Implementation: ADD, SUB, AND, OR, XOR, NOT, NAND, NOR, XNOR, INC, and DEC using a 4-bit opcode.

Level 3 — Status Flags

Objective: Provide operation-status information.

Implementation: Carry, Zero, Negative, and Overflow flag generation.

Level 4 — Self-Checking Testbench

Objective: Automate functional verification.

Implementation: Expected values, automatic comparison, PASS/FAIL reporting, counters, and final verification summary.

Level 5 — Directed Testing and Random Testing

Objective: Increase functional coverage.

Implementation: Directed tests for known cases, boundary cases, random 8-bit operands, valid random opcodes, and automated PASS/FAIL checking.

Level 6 — Signed Arithmetic and Proper Overflow Handling

Objective: Verify signed two's-complement arithmetic.

Implementation: Signed range −128 to +127, proper ADD/SUB/INC/DEC overflow detection, boundary tests, and combined directed/random self-checking verification.

Operation Table

0000 – ADD

0001 – SUB

0010 – AND

0011 – OR

0100 – XOR

0101 – NOT

0110 – NAND

0111 – NOR

1000 – XNOR

1001 – INC

1010 – DEC

Other opcodes – Default/zero result

Status Flags

Carry (C): Indicates carry for arithmetic operations. For subtraction, Carry = 1 represents no borrow.

Zero (Z): Set when result = 00000000.

Negative (N): Equals result[7] for signed two's-complement interpretation.

Overflow (V): Indicates a signed result outside the 8-bit range −128 to +127.

Signed Overflow Examples

7F + 01 = 80 → Overflow = 1

80 + FF = 7F → Overflow = 1

7F − FF = 80 → Overflow = 1

80 − 01 = 7F → Overflow = 1

7F INC = 80 → Overflow = 1

80 DEC = 7F → Overflow = 1

Verification Approach

RTL functional simulation in ModelSim

Directed testing of predefined input/output combinations

Boundary-condition testing

Self-checking expected-versus-actual comparison

Randomized 8-bit operands and valid opcodes

PASS/FAIL counters

Final total-test summary

Waveform inspection for debugging

Tools and Technologies

HDL: Verilog HDL

Simulation / Verification: ModelSim

Design concepts: RTL design, combinational logic, arithmetic and logical operations, two's-complement arithmetic, overflow detection, directed testing, random testing, and waveform analysis.

Repository Structure

8-bit-ALU/

├── README.docx

├── Level_1/

│   ├── alu_level1.v

│   └── alu_level1_tb.v

├── Level_2/

│   ├── alu_level2.v

│   └── alu_level2_tb.v

├── Level_3/

│   ├── alu_level3.v

│   └── alu_lvl3_tb.v

├── Level_4/

│   ├── alu_level4.v

│   └── alu_level4_tb.v

├── Level_5/

│   ├── alu_level5.v

│   └── alu_level5_tb.v

└── Level_6/

    ├── lvl6_rtl.v

    └── lvl6_tb.v

Key Learning Outcomes

RTL design methodology

Verilog HDL coding

Combinational ALU design

Opcode-based operation selection

Status-flag generation

Two's-complement signed arithmetic

Signed overflow detection

Testbench development

Self-checking verification

Directed and random testing

ModelSim simulation and waveform debugging

Result and Conclusion

The 8-bit ALU was developed progressively through six implementation levels. The final design supports 11 arithmetic and logical operations, generates Carry, Zero, Negative, and Overflow flags, and uses self-checking, directed, and random verification. Level 6 extends the design to signed two's-complement arithmetic with proper overflow handling. The project demonstrates an RTL design and functional-verification workflow using Verilog HDL and ModelSim.

Project Status

Completed through Level 6 functional design and verification study.

Author

Name: Mohankumar R

Department: Electrical and Electronics Engineering

Institution: Aenexz Private Limited
