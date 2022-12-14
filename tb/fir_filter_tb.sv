`timescale 1ns/1ps

module fir_filter_tb;
  localparam WIDTH_X = 8,
             WIDTH_B = 8,
             N = 4,
             TYPE = "OPT",
             WIDTH_Y = 18,
             NUM_DATA = 500;
  localparam logic [WIDTH_B-1:0] B [N] = {1, 2, 3, 4};


  // Clock generation
  logic clk=0, rstn=0;
  localparam CLK_PERIOD = 10;
  initial forever #(CLK_PERIOD/2) clk <= ~clk;

  logic signed [WIDTH_X-1:0] x=0;
  logic signed [WIDTH_Y-1:0] y, y_exp, y_exp_d;

  fir_filter #(
    .N (N),
    .TYPE(TYPE),
    .WIDTH_X (WIDTH_X),
    .WIDTH_B (WIDTH_B),
    .WIDTH_Y (WIDTH_Y),
    .B (B)
  ) dut (.*);


  logic signed [WIDTH_X-1:0] zi [N+1] = '{default:0};
  logic signed [WIDTH_X-1:0] zq [$] = zi;

  // Drive signals
  initial begin

    #10 rstn <= 1;

    for (int i=0; i<NUM_DATA; i++)
      @(posedge clk) #1 std::randomize(x);

    repeat (N+1) @(posedge clk);
    $finish();
  end

  always_ff @(posedge clk or negedge rstn) 
    y_exp_d <= (~rstn) ? '0 : y_exp;  

  // Monitor signals
  initial forever begin
      @(posedge clk) #2
      zq = {x,zq}; zq = zq[0:$-1];

      y_exp = 0;
      for (int i=1; i<=N; i=i+1)
        y_exp += zq[i]*B[i-1];
      
      assert (y==y_exp_d) $display("OK: y:%d", y);
      else $display("Error: y:%d != y_exp:%d", y, y_exp_d);
    end
endmodule