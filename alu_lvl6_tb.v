`timescale 1ns/1ps

module alu_level6_tb;


    // =====================================================
    // ALU INPUTS
    // =====================================================

    reg [7:0] A;
    reg [7:0] B;
    reg [3:0] opcode;


    // =====================================================
    // ALU OUTPUTS
    // =====================================================

    wire [7:0] result;
    wire       carry;
    wire       zero;
    wire       negative;
    wire       overflow;


    // =====================================================
    // EXPECTED VALUES
    // =====================================================

    reg [7:0] expected_result;
    reg       expected_carry;
    reg       expected_zero;
    reg       expected_negative;
    reg       expected_overflow;


    // =====================================================
    // COUNTERS
    // =====================================================

    integer pass_count;
    integer fail_count;

    integer directed_count;
    integer random_count;


    // =====================================================
    // RANDOM VARIABLES
    // =====================================================

    integer i;
    integer random_value;


    // =====================================================
    // TEMPORARY CALCULATION
    // =====================================================

    reg [8:0] temp;


    // =====================================================
    // INSTANTIATE ALU
    // =====================================================

    alu_level6 DUT (

        .A(A),
        .B(B),
        .opcode(opcode),

        .result(result),
        .carry(carry),
        .zero(zero),
        .negative(negative),
        .overflow(overflow)

    );


    // =====================================================
    // REFERENCE MODEL
    // =====================================================

    task calculate_expected;

        begin

            expected_result   = 8'b00000000;
            expected_carry    = 1'b0;
            expected_zero     = 1'b0;
            expected_negative = 1'b0;
            expected_overflow = 1'b0;

            temp = 9'b000000000;


            case (opcode)


                // =========================================
                // ADD
                // =========================================

                4'b0000: begin

                    temp = {1'b0, A} + {1'b0, B};

                    expected_result = temp[7:0];

                    expected_carry = temp[8];

                    expected_overflow =
                        (~(A[7] ^ B[7])) &
                        (expected_result[7] ^ A[7]);

                end


                // =========================================
                // SUB
                // =========================================

                4'b0001: begin

                    expected_result = A - B;

                    expected_carry = (A >= B);

                    expected_overflow =
                        (A[7] ^ B[7]) &
                        (expected_result[7] ^ A[7]);

                end


                // =========================================
                // AND
                // =========================================

                4'b0010: begin

                    expected_result = A & B;

                end


                // =========================================
                // OR
                // =========================================

                4'b0011: begin

                    expected_result = A | B;

                end


                // =========================================
                // XOR
                // =========================================

                4'b0100: begin

                    expected_result = A ^ B;

                end


                // =========================================
                // NOT
                // =========================================

                4'b0101: begin

                    expected_result = ~A;

                end


                // =========================================
                // NAND
                // =========================================

                4'b0110: begin

                    expected_result = ~(A & B);

                end


                // =========================================
                // NOR
                // =========================================

                4'b0111: begin

                    expected_result = ~(A | B);

                end


                // =========================================
                // XNOR
                // =========================================

                4'b1000: begin

                    expected_result = ~(A ^ B);

                end


                // =========================================
                // INC
                // =========================================

                4'b1001: begin

                    temp = {1'b0, A} + 9'b000000001;

                    expected_result = temp[7:0];

                    expected_carry = temp[8];

                    expected_overflow =
                        (~A[7]) & expected_result[7];

                end


                // =========================================
                // DEC
                // =========================================

                4'b1010: begin

                    expected_result = A - 8'b00000001;

                    expected_carry = (A != 8'h00);

                    expected_overflow =
                        A[7] & (~expected_result[7]);

                end


                // =========================================
                // INVALID
                // =========================================

                default: begin

                    expected_result = 8'b00000000;
                    expected_carry = 1'b0;
                    expected_overflow = 1'b0;

                end

            endcase


            // =============================================
            // ZERO FLAG
            // =============================================

            if (expected_result == 8'b00000000)
                expected_zero = 1'b1;
            else
                expected_zero = 1'b0;


            // =============================================
            // NEGATIVE FLAG
            // =============================================

            expected_negative = expected_result[7];

        end

    endtask



    // =====================================================
    // CHECK RESULT
    // =====================================================

    task check_result;

        begin

            #1;

            calculate_expected;


            if ((result === expected_result) &&
                (carry === expected_carry) &&
                (zero === expected_zero) &&
                (negative === expected_negative) &&
                (overflow === expected_overflow)) begin


                $display(
                    "PASS | Time=%0t | A=%02h(%0d) B=%02h(%0d) Opcode=%04b | Result=%02h(%0d) | C=%b Z=%b N=%b V=%b",
                    $time,
                    A,
                    $signed(A),
                    B,
                    $signed(B),
                    opcode,
                    result,
                    $signed(result),
                    carry,
                    zero,
                    negative,
                    overflow
                );


                pass_count = pass_count + 1;

            end

            else begin


                $display(
                    "FAIL | Time=%0t | A=%02h(%0d) B=%02h(%0d) Opcode=%04b | Expected=%02h(%0d) | Got=%02h(%0d) | Expected Flags=%b%b%b%b | Got=%b%b%b%b",
                    $time,
                    A,
                    $signed(A),
                    B,
                    $signed(B),
                    opcode,
                    expected_result,
                    $signed(expected_result),
                    result,
                    $signed(result),
                    expected_carry,
                    expected_zero,
                    expected_negative,
                    expected_overflow,
                    carry,
                    zero,
                    negative,
                    overflow
                );


                fail_count = fail_count + 1;

            end

        end

    endtask



    // =====================================================
    // DIRECTED TEST TASK
    // =====================================================

    task directed_test;

        input [7:0] test_A;
        input [7:0] test_B;
        input [3:0] test_opcode;

        begin

            A = test_A;
            B = test_B;
            opcode = test_opcode;

            #9;

            check_result;

            directed_count = directed_count + 1;

        end

    endtask



    // =====================================================
    // RANDOM TEST TASK
    // =====================================================

    task random_test;

        begin

            // Random A
            random_value = $random;

            A = random_value & 8'hFF;


            // Random B
            random_value = $random;

            B = random_value & 8'hFF;


            // Random opcode
            random_value = $random;

            opcode = random_value & 4'h0F;


            // Only valid opcodes 0000 to 1010
            while (opcode > 4'b1010) begin

                random_value = $random;

                opcode = random_value & 4'h0F;

            end


            #9;

            check_result;

            random_count = random_count + 1;

        end

    endtask



    // =====================================================
    // MAIN TEST PROGRAM
    // =====================================================

    initial begin


        // =================================================
        // INITIALIZE
        // =================================================

        pass_count = 0;
        fail_count = 0;

        directed_count = 0;
        random_count = 0;

        A = 8'h00;
        B = 8'h00;
        opcode = 4'b0000;


        // =================================================
        // HEADER
        // =================================================

        $display("");
        $display("================================================");
        $display("          8-BIT SIGNED ALU LEVEL 6");
        $display("          SIGNED ARITHMETIC TESTING");
        $display("================================================");
        $display("");

        $display("Signed range: -128 to +127");
        $display("");


        // =================================================
        // DIRECTED TESTING
        // =================================================

        $display("--------------- DIRECTED TESTING ---------------");


        // -------------------------------------------------
        // BASIC SIGNED ADDITION
        // -------------------------------------------------

        // +10 + +5 = +15
        directed_test(8'h0A, 8'h05, 4'b0000);


        // -10 + +5 = -5
        directed_test(8'hF6, 8'h05, 4'b0000);


        // -10 + -5 = -15
        directed_test(8'hF6, 8'hFB, 4'b0000);


        // +10 + -5 = +5
        directed_test(8'h0A, 8'hFB, 4'b0000);


        // -------------------------------------------------
        // SIGNED ADDITION OVERFLOW
        // -------------------------------------------------

        // +127 + +1 = -128
        directed_test(8'h7F, 8'h01, 4'b0000);


        // -128 + -1 = +127
        directed_test(8'h80, 8'hFF, 4'b0000);


        // -------------------------------------------------
        // BASIC SIGNED SUBTRACTION
        // -------------------------------------------------

        // +10 - +5 = +5
        directed_test(8'h0A, 8'h05, 4'b0001);


        // -10 - +5 = -15
        directed_test(8'hF6, 8'h05, 4'b0001);


        // +10 - (-5) = +15
        directed_test(8'h0A, 8'hFB, 4'b0001);


        // -10 - (-5) = -5
        directed_test(8'hF6, 8'hFB, 4'b0001);


        // -------------------------------------------------
        // SIGNED SUBTRACTION OVERFLOW
        // -------------------------------------------------

        // +127 - (-1) = -128
        directed_test(8'h7F, 8'hFF, 4'b0001);


        // -128 - (+1) = +127
        directed_test(8'h80, 8'h01, 4'b0001);


        // -------------------------------------------------
        // LOGICAL OPERATIONS
        // -------------------------------------------------

        // AND
        directed_test(8'hF0, 8'h0F, 4'b0010);


        // OR
        directed_test(8'hF0, 8'h0F, 4'b0011);


        // XOR
        directed_test(8'hAA, 8'h0F, 4'b0100);


        // NOT
        directed_test(8'h55, 8'h00, 4'b0101);


        // NAND
        directed_test(8'hFF, 8'h0F, 4'b0110);


        // NOR
        directed_test(8'hF0, 8'h0F, 4'b0111);


        // XNOR
        directed_test(8'hAA, 8'hAA, 4'b1000);


        // -------------------------------------------------
        // INC / DEC
        // -------------------------------------------------

        // +126 + 1 = +127
        directed_test(8'h7E, 8'h00, 4'b1001);


        // +127 + 1 = -128 OVERFLOW
        directed_test(8'h7F, 8'h00, 4'b1001);


        // -127 - 1 = -128
        directed_test(8'h81, 8'h00, 4'b1010);


        // -128 - 1 = +127 OVERFLOW
        directed_test(8'h80, 8'h00, 4'b1010);


        // -------------------------------------------------
        // ZERO TEST
        // -------------------------------------------------

        // +5 - +5 = 0
        directed_test(8'h05, 8'h05, 4'b0001);


        // -1 + +1 = 0
        directed_test(8'hFF, 8'h01, 4'b0000);


        $display("");
        $display("Directed tests completed.");
        $display("Directed tests executed = %0d", directed_count);
        $display("");


        // =================================================
        // RANDOM TESTING
        // =================================================

        $display("--------------- RANDOM TESTING -----------------");


        // 500 random tests

        for (i = 0; i < 500; i = i + 1) begin

            random_test;

        end


        $display("");
        $display("Random tests completed.");
        $display("Random tests executed = %0d", random_count);
        $display("");


        // =================================================
        // FINAL REPORT
        // =================================================

        $display("");
        $display("================================================");
        $display("                FINAL TEST REPORT");
        $display("================================================");

        $display("DIRECTED TESTS : %0d", directed_count);

        $display("RANDOM TESTS   : %0d", random_count);

        $display("TOTAL TESTS    : %0d",
                 directed_count + random_count);

        $display("PASSED         : %0d", pass_count);

        $display("FAILED         : %0d", fail_count);

        $display("================================================");


        if (fail_count == 0) begin

            $display("");
            $display("       ******** ALL TESTS PASSED ********");
            $display("");

        end

        else begin

            $display("");
            $display("       ******** TESTS FAILED ********");
            $display("");

        end


        $display("================================================");


        // End simulation
        $finish;

    end

endmodule
