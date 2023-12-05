`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 09:11:24 PM
// Design Name: 
// Module Name: right_counter
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


module right_counter(
    input clk,
    input reset,
    input d_incr, d_clr,
    output [3:0] digr0, digr1
    );
    
    // signal declaration
    reg [3:0] r_digr0, r_digr1, digr0_next, digr1_next;
    
    // register control
    always @(posedge clk or posedge reset)
        if(reset) begin
            r_digr1 <= 0;
            r_digr0 <= 0;
        end
        
        else begin
            r_digr1 <= digr1_next;
            r_digr0 <= digr0_next;
        end
    
    // next state logic
    always @* begin
        digr0_next = r_digr0;
        digr1_next = r_digr1;
        
        if(d_clr) begin
            digr0_next <= 0;
            digr1_next <= 0;
        end
        
        else if(d_incr)
            if(r_digr0 == 9) begin
                digr0_next = 0;
                
                if(r_digr1 == 9)
                    digr1_next = 0;
                else
                    digr1_next = r_digr1 + 1;
            end
        
            else    // dig0 != 9
                digr0_next = r_digr0 + 1;
    end
    
    // output
    assign digr0 = r_digr0;
    assign digr1 = r_digr1;
    
endmodule
