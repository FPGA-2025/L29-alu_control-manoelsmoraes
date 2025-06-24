module ALU_Control (
    input wire is_immediate_i,
    input wire [1:0] ALU_CO_i,
    input wire [6:0] FUNC7_i,
    input wire [2:0] FUNC3_i,
    output reg [3:0] ALU_OP_o
);

    // Definição dos códigos de operação da ALU
    localparam AND_OP   = 4'b0000;
    localparam OR_OP    = 4'b0001;
    localparam SUM_OP   = 4'b0010;
    localparam EQUAL_OP = 4'b0011;
    localparam SL_OP    = 4'b0100; // SHIFT LEFT
    localparam SR_OP    = 4'b0101; // SHIFT RIGHT
    localparam SRA_OP   = 4'b0111; // SHIFT RIGHT ARITHMETIC
    localparam XOR_OP   = 4'b1000;
    localparam NOR_OP   = 4'b1001;
    localparam SUB_OP   = 4'b1010;
    localparam GE_OP    = 4'b1100; // Greater or Equal (signed)
    localparam GEU_OP   = 4'b1101; // Greater or Equal (unsigned)
    localparam SLT_OP   = 4'b1110; // Set Less Than (signed)
    localparam SLTU_OP  = 4'b1111; // Set Less Than (unsigned)

    always @(*) begin
        case (ALU_CO_i)
            2'b00: begin
                // LOAD/STORE: endereço = base + offset
                ALU_OP_o = SUM_OP;
            end

            2'b01: begin
                // BRANCH: todas as comparações são feitas com SUB
                ALU_OP_o = SUB_OP;
            end

            2'b10: begin
                // ALU operations (lógicas e aritméticas)
                case (FUNC3_i)
                    3'b000: begin
                        if (is_immediate_i || FUNC7_i == 7'b0000000)
                            ALU_OP_o = SUM_OP; // ADD, ADDI
                        else
                            ALU_OP_o = SUB_OP; // SUB
                    end
                    3'b111: ALU_OP_o = AND_OP;
                    3'b110: ALU_OP_o = OR_OP;
                    3'b100: ALU_OP_o = XOR_OP;
                    3'b001: ALU_OP_o = SL_OP;  // SLL
                    3'b101: begin
                        if (FUNC7_i == 7'b0100000)
                            ALU_OP_o = SRA_OP; // SRA
                        else
                            ALU_OP_o = SR_OP;  // SRL
                    end
                    3'b010: ALU_OP_o = SLT_OP;  // SLT
                    3'b011: ALU_OP_o = SLTU_OP; // SLTU
                    default: ALU_OP_o = SUM_OP;
                endcase
            end

            default: begin
                // Grupo inválido, define operação padrão (safe fallback)
                ALU_OP_o = SUM_OP;
            end
        endcase
    end

endmodule
