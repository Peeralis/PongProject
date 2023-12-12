`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2023 09:07:28 PM
// Design Name: 
// Module Name: system
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


module system(
    input clk,              // 100MHz
    input reset,            // btnC
    output hsync,           // to VGA Connector
    output vsync,           // to VGA Connector
    output [11:0] rgb,       // to DAC, to VGA Connector
    
    output [6:0] seg,
    output dp,
    output [3:0] an,
    
    output wire RsTx, //uart
    input wire RsRx //uart
    );
    
    // state declarations for 4 states
    parameter newgame = 2'b00;
    parameter play    = 2'b01;
    parameter newball = 2'b10;
    parameter over    = 2'b11;
           
        
    // signal declaration
    reg [1:0] state_reg, state_next;
    wire [9:0] w_x, w_y;
    wire w_vid_on, w_p_tick, graph_on, hit, missl, missr;
    wire text_on;
    wire [11:0] graph_rgb, text_rgb;
    reg [11:0] rgb_reg, rgb_next;
    wire [3:0] digl0, digl1, digr0, digr1;
    reg gra_still, d_incl, d_incr, d_clr, timer_start;
    wire timer_tick, timer_up;
    wire [1:0] received_char_player1, received_char_player2;
    wire [3:0] player_received = {received_char_player2,received_char_player1};
    
    // Module Instantiations
    vga vga_unit(
        .clk_100MHz(clk),
        .reset(reset),
        .video_on(w_vid_on),
        .hsync(hsync),
        .vsync(vsync),
        .p_tick(w_p_tick),
        .x(w_x),
        .y(w_y));
    
    text text_unit(
        .clk(clk),
        .x(w_x),
        .y(w_y),
        .digl0(digl0),
        .digl1(digl1),
        .digr0(digr0),
        .digr1(digr1),
        .text_on(text_on),
        .text_rgb(text_rgb));
        
    graphic graph_unit(
        .clk(clk),
        .reset(reset),
        .player_received(player_received),
        .gra_still(gra_still),
        .video_on(w_vid_on),
        .x(w_x),
        .y(w_y),
        .hit(hit),
        .missl(missl),
        .missr(missr),
        .graph_on(graph_on),
        .graph_rgb(graph_rgb));
    
    uart uart(clk,RsRx,RsTx,received_char_player1,received_char_player2);
    // 60 Hz tick when screen is refreshed
    assign timer_tick = (w_x == 0) && (w_y == 0);
    timer timer_unit(
        .clk(clk),
        .reset(reset),
        .timer_tick(timer_tick),
        .timer_start(timer_start),
        .timer_up(timer_up));
        
    left_counter lcounter_unit(
        .clk(clk),
        .reset(reset),
        .d_incl(d_incl),
        .d_clr(d_clr),
        .digl0(digl0),
        .digl1(digl1));
        
    right_counter rcounter_unit(
        .clk(clk),
        .reset(reset),
        .d_incr(d_incr),
        .d_clr(d_clr),
        .digr0(digr0),
        .digr1(digr1));
          
    // FSMD state and registers
    always @(posedge clk or posedge reset)
        if(reset) begin
            state_reg <= newgame;
            rgb_reg <= 0;
        end
    
        else begin
            state_reg <= state_next;
            if(w_p_tick)
                rgb_reg <= rgb_next;
        end
    
    // FSMD next state logic
    always @* begin
        gra_still = 1'b1;
        timer_start = 1'b0;
        d_incl = 1'b0;
        d_incr = 1'b0;
        d_clr = 1'b0;
        state_next = state_reg;
        
        case(state_reg)
            newgame: begin
                d_clr = 1'b1;               // clear score
                
                if(player_received != 4'b0000) begin      // button pressed
                    state_next = play;
                end
            end
            
            play: begin
                gra_still = 1'b0;   // animated screen
                
                if(missr) begin
                    if(digl1==9 && digl0==9)
                        state_next = over;
                    
                    else
                        d_incl = 1'b1;
                        state_next = newball;
                    
                    timer_start = 1'b1;     // 2 sec timer
                end
                
                else if(missl) begin
                    if(digr1==9 && digr0==9)
                        state_next = over;
                    
                    else
                        d_incr = 1'b1;
                        state_next = newball;
                    
                    timer_start = 1'b1;     // 2 sec timer
                end
            end
            
            newball: // wait for 2 sec and until button pressed
            if(timer_up && (player_received != 4'b0000))
                state_next = play;
                
            over:   // wait 2 sec to display game over
                if(timer_up)
                    state_next = newgame;
        endcase           
    end
    
    // rgb multiplexing
    always @*
        if(~w_vid_on)
            rgb_next = 12'h000; // blank
        
        else
            if(text_on || (state_reg == newgame))
                rgb_next = text_rgb;    // colors in pong_text
            
            else if(graph_on)
                rgb_next = graph_rgb;   // colors in graph_text
                
            else
                rgb_next = 12'hFFF;     // white background
    
    // output
    assign rgb = rgb_reg;
    
    
    ////////////////////////////////////////
    // Assign number
    reg [3:0] num3,num2,num1,num0; // From left to right
    
    always @(posedge clk) begin
       {num3,num2,num1,num0} = {digl1,digl0,digr1,player_received};
    end

    wire an0,an1,an2,an3;
    assign an={an3,an2,an1,an0};
    
    ////////////////////////////////////////
    // Clock
    wire targetClk;
    wire [18:0] tclk;
    assign tclk[0]=clk;
    genvar c;
    generate for(c=0;c<18;c=c+1) begin
        clockDiv fDiv(tclk[c+1],tclk[c]);
    end endgenerate
    
    clockDiv fdivTarget(targetClk,tclk[18]);
    
    ////////////////////////////////////////
    // Display
    quadSevenSeg q7seg(seg,dp,an0,an1,an2,an3,num0,num1,num2,num3,targetClk);

    
endmodule