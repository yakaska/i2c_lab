`timescale 1ns / 1ps


module testbench();

reg clk = 0;
wire tmp_sda;
wire tmp_scl;
wire [7:0] SEG;
wire [7:0] AN;

always #(10) clk <= ~clk;

top uut (
    .CLK100MHZ(clk),
    .TMP_SDA(tmp_sda),
    .TMP_SCL(tmp_scl),
    .SEG(SEG),
    .AN(AN)
);

i2c_slave slave(
    .SDA(tmp_sda),
    .SCL(tmp_scl)
);

initial begin
    $monitor("At time %t, AN=%b SEG=%b", $time, AN, SEG);
end

endmodule
