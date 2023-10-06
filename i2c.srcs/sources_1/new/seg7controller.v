module seg7c(
    input clk_100mhz,
    input [7:0] c_data,
    input [7:0] c_data_precision,
    output reg [7:0] SEG,
    output reg [7:0] AN
);
    wire [3:0] c_tens, c_ones;
    assign c_tens = c_data / 10;
    assign c_ones = c_data % 10;
    
    wire [3:0] c_prec_tens, c_prec_ones;
    assign c_prec_tens = c_data_precision / 10;
    assign c_prec_ones = c_data_precision % 10;

    parameter ZERO  = 7'b100_0000;  
    parameter ONE   = 7'b111_1001;  
    parameter TWO   = 7'b010_0100;  
    parameter THREE = 7'b011_0000;  
    parameter FOUR  = 7'b001_1001;  
    parameter FIVE  = 7'b001_0010;
    parameter SIX   = 7'b000_0010;
    parameter SEVEN = 7'b111_1000;
    parameter EIGHT = 7'b000_0000;
    parameter NINE  = 7'b001_0000;
    parameter DEG   = 7'b001_1100;
    parameter C     = 7'b100_0110;
    
    reg [2:0] anode_select;
    reg [16:0] anode_timer;
    
    always @(posedge clk_100mhz) begin
        if(anode_timer == 99_999) begin
            anode_timer <= 0;
            anode_select <=  anode_select + 1;
        end
        else
            anode_timer <=  anode_timer + 1;
    end
    
    always @(anode_select) begin
        case(anode_select) 
            3'o0 : AN = 8'b1111_1110;
            3'o1 : AN = 8'b1111_1101;
            3'o2 : AN = 8'b1111_1011;
            3'o3 : AN = 8'b1111_0111;
            3'o4 : AN = 8'b1110_1111;
            3'o5 : AN = 8'b1101_1111;
            3'o6 : AN = 8'b1011_1111;
            3'o7 : AN = 8'b0111_1111;
        endcase
    end
    
    always @*
        case(anode_select)
            3'o0: SEG = {1'b1, C};
            3'o1: SEG = {1'b1, DEG};
            3'o6: SEG = 8'b1111_1111;
            3'o7: SEG = 8'b1111_1111;
            3'o2: begin
                case (c_prec_ones)
                    4'b0000 : SEG = {1'b1, ZERO};
                                    4'b0001 : SEG = {1'b1, ONE};
                                    4'b0010 : SEG = {1'b1, TWO};
                                    4'b0011 : SEG = {1'b1, THREE};
                                    4'b0100 : SEG = {1'b1, FOUR};
                                    4'b0101 : SEG = {1'b1, FIVE};
                                    4'b0110 : SEG = {1'b1, SIX};
                                    4'b0111 : SEG = {1'b1, SEVEN};
                                    4'b1000 : SEG = {1'b1, EIGHT};
                                    4'b1001 : SEG = {1'b1, NINE};
                endcase
            end
            3'o3: begin
                case (c_prec_tens)
                    4'b0000 : SEG = {1'b1, ZERO};
                                    4'b0001 : SEG = {1'b1, ONE};
                                    4'b0010 : SEG = {1'b1, TWO};
                                    4'b0011 : SEG = {1'b1, THREE};
                                    4'b0100 : SEG = {1'b1, FOUR};
                                    4'b0101 : SEG = {1'b1, FIVE};
                                    4'b0110 : SEG = {1'b1, SIX};
                                    4'b0111 : SEG = {1'b1, SEVEN};
                                    4'b1000 : SEG = {1'b1, EIGHT};
                                    4'b1001 : SEG = {1'b1, NINE};
                endcase
            end
            3'o4: begin
                case(c_ones)
                    4'b0000 : SEG = {1'b0, ZERO};
                    4'b0001 : SEG = {1'b0, ONE};
                    4'b0010 : SEG = {1'b0, TWO};
                    4'b0011 : SEG = {1'b0, THREE};
                    4'b0100 : SEG = {1'b0, FOUR};
                    4'b0101 : SEG = {1'b0, FIVE};
                    4'b0110 : SEG = {1'b0, SIX};
                    4'b0111 : SEG = {1'b0, SEVEN};
                    4'b1000 : SEG = {1'b0, EIGHT};
                    4'b1001 : SEG = {1'b0, NINE};
                endcase
            end
            3'o5: begin
                case(c_tens)
                    4'b0000 : SEG = {1'b1, ZERO};
                    4'b0001 : SEG = {1'b1, ONE};
                    4'b0010 : SEG = {1'b1, TWO};
                    4'b0011 : SEG = {1'b1, THREE};
                    4'b0100 : SEG = {1'b1, FOUR};
                    4'b0101 : SEG = {1'b1, FIVE};
                    4'b0110 : SEG = {1'b1, SIX};
                    4'b0111 : SEG = {1'b1, SEVEN};
                    4'b1000 : SEG = {1'b1, EIGHT};
                    4'b1001 : SEG = {1'b1, NINE};
                endcase
            end
        endcase
endmodule