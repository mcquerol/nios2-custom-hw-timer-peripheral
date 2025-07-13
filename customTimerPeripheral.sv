module customTimerPeripheral (
	
	input logic clk, reset,
	input logic address, // 0 for CTRL reg or 1 for COUNTER REG
	input logic read,
	input logic write,
	input logic [31:0] writedata,
	output logic [31:0] readdata

);

	logic [31:0] CTRL;
	logic [31:0] COUNTER;
	
	always_ff @(posedge clk) begin
	
		if(reset == 1'b0) begin
			COUNTER <= 32'b0;
		end else if(CTRL[0] == 1'b0) begin //if 0th bit of control register is 0 then reset counter else keep counting
			COUNTER <= 32'b0;
		end else begin
			COUNTER <= COUNTER + 1;
		end
		
		if(write == 1'b1 && address == 1'b0) begin
			CTRL = writedata;
		end
	
	end
	
	always_comb begin
		
		
		case (address)
        0: readdata = CTRL;
        1: readdata = COUNTER;
        default: readdata = 32'hDEADDEAD; // cover all cases
    endcase
	
	end
	

endmodule