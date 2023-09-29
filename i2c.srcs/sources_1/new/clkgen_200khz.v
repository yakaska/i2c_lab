`timescale 1ns / 1ps

module clkgen_200KHz(
    input clk_100mhz,
    output clk_200khz
);
    
    reg [7:0] counter = 8'h00;
    reg clk_reg = 1'b1;
    
    always @(posedge clk_100mhz) begin
        if(counter == 249) begin
            counter <= 8'h00;
            clk_reg <= ~clk_reg;
        end
        else
            counter <= counter + 1;
    end
    
    assign clk_200khz = clk_reg;
    
endmodule