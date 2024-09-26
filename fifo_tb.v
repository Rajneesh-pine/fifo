// Code your testbench here
// or browse Examples

module tb;
  parameter data_width=8;
  reg clk;
  reg rst;
  reg wr_en;
  reg rd_en;
  reg [data_width-1:0]data_in;
  wire[data_width-1:0]data_out;
  wire full;
  wire empty;
  reg [data_width-1:0]q[$],wdata;
  synchronous_fifo(.clk(clk),.rst(rst),.wr_en(wr_en),.rd_en(rd_en),.data_in(data_in),.data_out(data_out),.full(full),.empty(empty));
  
  always #5 clk=~clk;
  
  initial begin
    clk=0;rst=0;
    wr_en=0;data_in=0;
    
    repeat(10)@(posedge clk);
    rst=1;
    
    repeat(2)
      begin
        for(int i=0;i<30;i++)
          begin
            @(posedge clk);
            wr_en=(i%2==0)?1:0;
            if(wr_en & !full)
              begin
                data_in=$random;
                q.push_back(data_in);
            end
          end
        #50;
      end
  end
  
  initial begin
    clk=0;rst=0;
    rd_en=0;
    
    repeat(20)@(posedge clk);
    rst=1;
    
    repeat(2)
      begin
        for(int i=0;i<30;i++)
          begin
            @(posedge clk);
            rd_en=(i%2==0)?1:0;
            if(rd_en & !empty)
              begin
                 #1;
                wdata=q.pop_front();
                if(wdata==data_out)
                  begin
                   $display($time,"    comparison passed wr_data=%0d and rd_data=%0d",wdata,data_out);
                  end
                else
                  $display($time,"comparison failed");
            end
          end
        #50;
      end
    $finish;
  end
endmodule
