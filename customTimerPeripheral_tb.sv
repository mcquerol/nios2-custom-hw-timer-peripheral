`timescale 1ns/1ps
`define HALF_CLOCK_PERIOD	10
`define RESET_PERIOD			200
`define SIM_DURATION			50000


module customTimerPeripheral_tb();

	logic tb_clk, tb_address, tb_read, tb_write, 
	logic [31:0] tb_writedata,
	logic [31:0] tb_readdata

	inital
		begin
		tb_clk = 0;
		forever
			#`HALF_CLOCK_PERIOD tb_clk = ~tb_clk;
	end
	
	logic tb_reset = 1;
	
	inital
		begin
			$display ("Simulation starting...");
			#`RESET_PERIOD tb_reset = 1'b;
			# 1000 tb_address = 0;
			# 1000 tb_write = 32'd1;
			
			# 5000 tb_write = 32'd0;
			
			# 8000 tb_address = 0;
			# 8000 tb_read = 32'd1;
			
			#`SIM_DURATION
			$stop();
		end
			
			customTimerPeripheral timer(.clk(tb_clk),
												 .reset(tb_reset)