module customTimerPeripheral (
    input  logic        clk,
    input  logic        reset,
    input  logic        address,      // 0 = CTRL, 1 = COUNTER
    input  logic        read,
    input  logic        write,
    input  logic [31:0] writedata,
    output logic [31:0] readdata
);

    logic [31:0] CTRL;
    logic [31:0] COUNTER;

    always_ff @(posedge clk) begin
        if (!reset) begin
            COUNTER <= 32'd0;
            CTRL    <= 32'd0;
        end else begin
            // Write to CTRL register
            if (write && address == 1'b0) begin
                CTRL <= writedata;
            end

            // Counting logic
            if (CTRL[0]) begin
                COUNTER <= COUNTER + 1;
            end else begin
                COUNTER <= 32'd0;
            end
        end
    end

    always_comb begin
        if (read) begin
            case (address)
                1'b0: readdata = CTRL;
                1'b1: readdata = COUNTER;
                default: readdata = 32'hDEADDEAD;
            endcase
        end else begin
            readdata = 32'd0;  // Default when not reading
        end
    end

endmodule
