`timescale 1ns / 1ps

module top(
    input         CLK100MHZ,        // nexys clk signal
    inout         TMP_SDA,          // i2c sda on temp sensor - bidirectional
    output        TMP_SCL,          // i2c scl on temp sensor
    output [7:0]  SEG,              // 7 segments of each display
    output [7:0]  AN      // 8 anodes of 8 displays
    );
    
    wire clk_200khz;                  // 200kHz SCL
    wire [15:0] c_data;              // 8 bits of Celsius temperature data

    i2c_master i2c_master(
        .clk_200khz(clk_200khz),
        .temp_data(c_data),
        .sda(TMP_SDA),
        .scl(TMP_SCL)
    );
    
    clkgen_200KHz clk_gen(
        .clk_100mhz(CLK100MHZ),
        .clk_200khz(clk_200khz)
    );
    
    seg7c seg_control(
        .clk_100mhz(CLK100MHZ),
        .c_data(c_data[15:8]),
        .c_data_precision(c_data[7:0]),
        .SEG(SEG),
        .AN(AN)
    );
    
endmodule