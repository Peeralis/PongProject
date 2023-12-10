module text(
    input clk,
//    input [1:0] ball,
    input [3:0] digl0, digl1, digr0, digr1,
    input [9:0] x, y,
//    output [3:0] text_on,
    output text_on,//score,game over
    output reg [11:0] text_rgb
    );
    
    // signal declaration
    wire [10:0] rom_addr;
    reg [6:0] char_addr, char_addr_s;
    reg [3:0] row_addr;
    wire [3:0] row_addr_s, row_addr_l;
    reg [2:0] bit_addr;
    wire [2:0] bit_addr_s, bit_addr_l;
    wire [7:0] ascii_word;
    wire ascii_bit, score_on;
    
   // instantiate ascii rom
   rom ascii_unit(.clk(clk), .addr(rom_addr), .data(ascii_word));
   
   // ---------------------------------------------------------------------------
   // score region
   // - display two-digit score and ball # on top left
   // - scale to 16 by 32 text size
   // - line 1, 16 chars: "Score: dd Ball: d"
   // ---------------------------------------------------------------------------
   assign score_on = (y >= 32) && (y < 64) && (x[9:4] < 64);
   //assign score_on = (y[9:5] == 0) && (x[9:4] < 16);
   assign row_addr_s = y[4:1];
   assign bit_addr_s = x[3:1];
   always @*
    case(x[9:4])
        6'h1 : char_addr_s = 7'h50;     // P
        6'h2 : char_addr_s = 7'h31;     // 1
        6'h3 : char_addr_s = 7'h3A;     // :
        6'h4 : char_addr_s = {3'b011, digl1};    // tens digit
        6'h5 : char_addr_s = {3'b011, digl0};    // ones digit
        6'h12: char_addr_s = 7'h53;      // S
        6'h13 : char_addr_s = 7'h43;     // C
        6'h14 : char_addr_s = 7'h4F;     // O
        6'h15 : char_addr_s = 7'h52;     // R
        6'h16 : char_addr_s = 7'h45;     // E
        6'h22 : char_addr_s = 7'h50;     // P
        6'h23: char_addr_s = 7'h32;     // 2
        6'h24 : char_addr_s = 7'h3A;     // :
        6'h25 : char_addr_s = {3'b011, digr1};    // tens digit
        6'h26 : char_addr_s = {3'b011, digr0};    // ones digit
        default: char_addr_s = 7'h00;
    endcase
    
    
    // mux for ascii ROM addresses and rgb
    always @* begin
        text_rgb = 12'hFFF;     // white background
        
        if(score_on) begin
            char_addr = char_addr_s;
            row_addr = row_addr_s;
            bit_addr = bit_addr_s;
            if(ascii_bit)
                text_rgb = 12'h000; // black text
        end
              
    end
    
//    assign text_on = {score_on, over_on};
    assign text_on = {score_on};
    
    // ascii ROM interface
    assign rom_addr = {char_addr, row_addr};
    assign ascii_bit = ascii_word[~bit_addr];
      
endmodule