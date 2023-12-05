`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 09:03:53 PM
// Design Name: 
// Module Name: baudrate_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/31/2021 11:04:18 PM
// Design Name: 
// Module Name: baudrate_gen
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module baudrate_gen(
    input clk,
    output reg baud
    );
    
    integer counter;
    always @(posedge clk) begin
        counter = counter + 1;
        if (counter == 54) begin counter = 0; baud = ~baud; end 
        // Clock = 10ns
        // ClockFreq = 1/10ns = 100 MHz
        // Baudrate = 57600
        // counter = ClockFreq/Baudrate/16/2
        // sampling every 16 ticks
    end
    
endmodule