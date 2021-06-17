`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:46:44 06/17/2021 
// Design Name:  
// Module Name:    sync_fifo 
// Project Name:   Sequential Circuits 
// Target Devices: ASIC/FPGA
// Tool versions: 
// Description:  Synthesizable
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module sync_fifo
#(
	parameter depth=8  , width= 8
  )

(
    input clk,rst,
    input wr_enable,rd_enable,
    input [width-1:0] data_in,
    inout full,empty,
    output reg [width-1:0] data_out
    );

reg [width-1:0] fifo_array [depth-1 : 0];
reg [($clog2(depth) )-1:0] wr_ptr,rd_ptr;
reg wrote;                                   // 1 = wrote, 0 =read;



always @(posedge clk or posedge rst)
begin

		if(rst)
		begin
				wr_ptr <= 0;
				rd_ptr <= 0;
				wrote <= 1'b0;                   // assume last operation was read
		end
		
		else 
		begin
				if (rd_enable && !empty)               // read operation
				begin
						data_out <= fifo_array[rd_ptr];
						rd_ptr <= rd_ptr + 1'b1;
						wrote <= 1'b0;                   // read status 
				end
				
				if (wr_enable && !full)                // write operation
				begin
						fifo_array[wr_ptr] <= data_in;
						wr_ptr <= wr_ptr + 1'b1;
						wrote <= 1'b1;                   // write status
				end
		end

end

assign empty = (rd_ptr == wr_ptr) && !wrote;
assign full =  (rd_ptr == wr_ptr) &&  wrote;

endmodule
