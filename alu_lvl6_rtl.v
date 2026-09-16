`timescale 1ns/1ps

module alu_level6 (

    input  [7:0] A,
    input  [7:0] B,
    input  [3:0] opcode,

    output reg [7:0] result,
    output reg       carry,
    output reg       zero,
    output reg       negative,
    output reg       overflow

);

    reg [8:0] temp;

    always @(*) begin

        // Default values
        result   = 8'b00000000;
        carry    = 1'b0;
        zero     = 1'b0;
        negative = 1'b0;
        overflow = 1'b0;

        temp = 9'b000000000;


        case (opcode)

            // =================================================
            // ADD
            // =================================================

            4'b0000: begin

                temp = {1'b0, A} + {1'b0, B};

                result = temp[7:0];

                // Unsigned carry
                carry = temp[8];

                // Signed overflow
                // Positive + Positive = Negative
                // Negative + Negative = Positive
                overflow = (~(A[7] ^ B[7])) &
                           (result[7] ^ A[7]);

            end


            // =================================================
            // SUB
            // =================================================

            4'b0001: begin

                result = A - B;

                // Carry = 1 means no borrow
                carry = (A >= B);

                // Signed overflow
                // Different signs + result sign differs from A
                overflow = (A[7] ^ B[7]) &
                           (result[7] ^ A[7]);

            end


            // =================================================
            // AND
            // =================================================

            4'b0010: begin

                result = A & B;

            end


            // =================================================
            // OR
            // =================================================

            4'b0011: begin

                result = A | B;

            end


            // =================================================
            // XOR
            // =================================================

            4'b0100: begin

                result = A ^ B;

            end


            // =================================================
            // NOT
            // =================================================

            4'b0101: begin

                result = ~A;

            end


            // =================================================
            // NAND
            // =================================================

            4'b0110: begin

                result = ~(A & B);

            end


            // =================================================
            // NOR
            // =================================================

            4'b0111: begin

                result = ~(A | B);

            end


            // =================================================
            // XNOR
            // =================================================

            4'b1000: begin

                result = ~(A ^ B);

            end


            // =================================================
            // INC
            // =================================================

            4'b1001: begin

                temp = {1'b0, A} + 9'b000000001;

                result = temp[7:0];

                carry = temp[8];

                // Signed overflow:
                // +127 + 1 = -128
                overflow = (~A[7]) & result[7];

            end


            // =================================================
            // DEC
            // =================================================

            4'b1010: begin

                result = A - 8'b00000001;

                // Carry = 1 means no borrow
                carry = (A != 8'h00);

                // Signed overflow:
                // -128 - 1 = +127
                overflow = A[7] & (~result[7]);

            end


            // =================================================
            // INVALID OPCODE
            // =================================================

            default: begin

                result   = 8'b00000000;
                carry    = 1'b0;
                overflow = 1'b0;

            end

        endcase


        // =====================================================
        // ZERO FLAG
        // =====================================================

        if (result == 8'b00000000)
            zero = 1'b1;
        else
            zero = 1'b0;


        // =====================================================
        // NEGATIVE FLAG
        // =====================================================

        negative = result[7];

    end

endmodule
