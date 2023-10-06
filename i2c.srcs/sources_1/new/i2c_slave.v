`timescale 1ns / 1ps

module i2c_slave (
    inout wire SDA,
    input wire SCL
);

  reg [4:0] IDLE = 4'b0000;
  reg [4:0] START = 4'b0001;
  reg [4:0] READ_ADDRESS = 4'b0010;
  reg [4:0] READ_WRITE = 4'b0011;
  reg [4:0] DATA_READ = 4'b0100;
  reg [4:0] DATA_READ_ACK = 4'b0101;
  reg [4:0] STOP = 4'b0110;
  reg [4:0] ADDRESS_ACK = 4'b0111;

  reg [4:0] state = 4'b0010;

  reg [6:0] slaveAddress = 7'b100_1011;
  reg [6:0] addr = 7'b000_0000;
  reg [6:0] addressCounter = 7'b000_0000;

  reg [7:0] data [0:1];
  reg [0:0] data_part;
  reg [2:0] dataCounter = 3'b000;

  reg readWrite = 1'b0;
  reg start = 0;
  reg write_ack = 0;
  reg sda_enable = 0;
  reg sda_reg = 0;

  initial data_part = 0;
  initial data[0] = 8'b00000001;
  initial data[1] = 8'b00000010;

  assign SDA = sda_enable ? sda_reg : 1'bZ;

  always @(negedge SDA) begin
    if ((start == 0) && (SCL == 1)) begin
      start <= 1;
      addressCounter <= 0;
      dataCounter <= 0;
    end
  end
  always @(posedge SDA) begin
    if ((start == 1) && (SCL == 1)) begin
      start <= 0;
      addressCounter <= 0;
      dataCounter <= 0;
      state <= READ_ADDRESS;
    end
  end

  always @(posedge SCL) begin
    if (start == 1) begin
      case (state)
        READ_ADDRESS: begin
          addr[addressCounter] <= SDA;
          addressCounter <= addressCounter + 1;
          if (addressCounter == 6) begin
            state <= READ_WRITE;
          end
        end
        READ_WRITE: begin
          readWrite <= SDA;
          state <= ADDRESS_ACK;
        end
        
        STOP: begin
          start <= 0;     
          state <= READ_ADDRESS;
        end
        ADDRESS_ACK: begin
          sda_enable <= 1;
          sda_reg <= 0;
          state <= DATA_READ;
        end

      endcase
    end
  end

  always @(negedge SCL) 
  begin
    if (start == 1) begin
      case (state)
        DATA_READ_ACK: begin
              data_part <= ~data_part;
              dataCounter <= 0;
              sda_enable <= 0;
              state <= !data_part ? DATA_READ : STOP;
            end
        DATA_READ: begin
          sda_enable <= 1;
          sda_reg <= data[data_part][dataCounter];
          dataCounter <= dataCounter + 1;
          if (dataCounter == 7) begin
            state <= DATA_READ_ACK;
          end
        end
      endcase
    end
  end


endmodule