// Code your design here
module synchronous_fifo#(parameter depth=8,parameter data_width=8)(input clk,input rst,input wr_en,input rd_en,reg [data_width-1:0]data_in,output reg [data_width-1:0]data_out,output  full,output empty);

  
  reg [$clog2(depth)-1:0]rptr;
  reg [$clog2(depth)-1:0]wptr;
  reg [data_width-1:0]fifo[0:depth-1];
  
  always @(posedge clk)
    begin
      if(!rst)
        begin
          rptr<=0;wptr<=0;
          data_out<=0;
        end
    end
  
  always @(posedge clk )
    begin
      if(wr_en & !full)
        begin
          fifo[wptr]<=data_in;
          wptr<=wptr+1;
        end
    end
  
  always @(posedge clk)
    begin
      if(rd_en & !empty)
        begin
          data_out<=fifo[rptr];
          rptr<=rptr+1;
        end
    end
  assign empty=(rptr==wptr);
  assign full=(rptr==(wptr+1'b1));
endmodule
