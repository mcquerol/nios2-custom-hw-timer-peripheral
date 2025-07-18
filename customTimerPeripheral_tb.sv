`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD 10
`define RESET_PERIOD      200
`define SIM_DURATION      1000000

module customTimerPeripheral_tb;

    logic tb_clk = 0;
    logic tb_reset = 0;
    logic tb_address = 0;
    logic tb_read = 0;
    logic tb_write = 0;
    logic [31:0] tb_writedata = 0;
    logic [31:0] tb_readdata;

    // Instantiate DUT
    customTimerPeripheral dut (
        .clk(tb_clk),
        .reset(tb_reset),
        .address(tb_address),
        .read(tb_read),
        .write(tb_write),
        .writedata(tb_writedata),
        .readdata(tb_readdata)
    );

    // Clock generation
    always #`HALF_CLOCK_PERIOD tb_clk = ~tb_clk;

    // Test sequence
    initial begin
        $display("Simulation starting...");
        
        // Initial reset
        #`RESET_PERIOD tb_reset = 1;

        // Start counter: Write 1 to CTRL
        #100 tb_address = 1'b0;
        tb_writedata = 32'd1;
        tb_write = 1;
        #20 tb_write = 0;

        // Let it count for some time
        #2000;

        // Read COUNTER value
        tb_address = 1'b1;
        tb_read = 1;
        #20;
        $display("Counter value before reset: %d", tb_readdata);
        tb_read = 0;

        // Disable and reset counter
        #100 tb_address = 1'b0;
        tb_writedata = 32'd0;
        tb_write = 1;
        #20 tb_write = 0;

        // Wait to verify no counting
        #1000;

        // Read COUNTER again
        tb_address = 1'b1;
        tb_read = 1;
        #20;
        $display("Counter value after CTRL reset: %d", tb_readdata);
        tb_read = 0;

        // End of sim
		  // Re-enable and confirm it starts counting again
			#100 tb_address = 1'b0;
			tb_writedata = 32'd1;
			tb_write = 1;
			#20 tb_write = 0;

			#5000;

			tb_address = 1'b1;
			tb_read = 1;
			#20;
		  $display("Counter value after re-enable: %d", tb_readdata);

		  
		  #`SIM_DURATION
		  #20
		  
		  $display("Time: %0t ns — Final counter value: %d", $time, tb_readdata);
        $stop;
    end

endmodule
