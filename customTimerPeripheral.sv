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
	 
	 nios2_qsys_0 u0 (
    .clk_clk        (clk),         // Connect to your system clock
    .reset_reset    (reset),       // Connect to system reset
    .custom_timer_0_clock (clk),        // if your timer has a separate clock
    .custom_timer_0_reset (reset),    // and a reset
    .custom_timer_0_timer_mm_slave_address    (address),
    .custom_timer_0_timer_mm_slave_read       (read),
    .custom_timer_0_timer_mm_slave_readdata   (readdata),
    .custom_timer_0_timer_mm_slave_write      (write),
    .custom_timer_0_timer_mm_slave_writedata  (writedata)
    // other signals like JTAG UART, instruction/data masters, etc.
	);


endmodule

