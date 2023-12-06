module uart(
    input clk,
    input RsRx,
    output RsTx,
    output reg [1:0] received_char_player1,
    output reg [1:0] received_char_player2
    );
    
    reg en, last_rec;
    reg [7:0] data_in;
    wire [7:0] data_out;
    wire sent, received, baud;
    
    baudrate_gen baudrate_gen(clk, baud);
    uart_rx receiver(baud, RsRx, received, data_out);
    uart_tx transmitter(baud, data_in, en, sent, RsTx);

    always @(posedge baud) begin
        if (en) en = 0;
        if (~last_rec & received) begin
            data_in = data_out;

            // Check for specific characters 'w', 's', 'i', and 'k'
            case (data_in)
                8'h77: received_char_player1 = 2'b01; // 'w' pressed for player 1
                8'h73: received_char_player1 = 2'b10; // 's' pressed for player 1
                8'h69: received_char_player2 = 2'b01; // 'i' pressed for player 2
                8'h6B: received_char_player2 = 2'b10; // 'k' pressed for player 2
                default: {received_char_player1,received_char_player2} = 4'b0;
            endcase

            // Set enable flags for valid characters
            if (received_char_player1 != 2'b0) en = 1;
            if (received_char_player2 != 2'b0) en = 1;
        end
        last_rec = received;
    end
endmodule