`timescale 1ns/1ps

module fir_filter #(
  parameter  TYPE = "OPT",
             N = 4,
             WIDTH_X = 8,
             WIDTH_B = 8,
             WIDTH_Y = WIDTH_X + WIDTH_B + N,
  parameter logic [WIDTH_B-1:0] B [N] = '{default:0},
  
  localparam WIDTH_M = WIDTH_X + WIDTH_B
)(
  input  clk, rstn,
  input  logic signed [WIDTH_X-1:0] x,
  output logic signed [WIDTH_Y-1:0] y
);

  genvar n;
  generate
    if (TYPE == "NORMAL") begin:GN
      logic signed [WIDTH_X-1:0] z [N];
      logic signed [WIDTH_M-1:0] m [N];
      logic signed [WIDTH_Y-1:0] a [N];

      for (n=0; n < N; n=n+1)
        always_ff @(posedge clk or negedge rstn)
          if (~rstn) z[n] <= 0;
          else       z[n] <= n==0 ? x : z[n-1];

      for (n=0; n < N; n=n+1)
        assign m[n] = B[n] * z[n];

      assign a[0] = m[0];
      
      for (n=1; n < N; n=n+1)
        assign a[n] = a[n-1] + m[n];

      always_ff @(posedge clk or negedge rstn)
        y <= ~rstn ? 0 : a[N-1];

    end

    else if (TYPE == "OPT") begin:GO

      logic signed [WIDTH_X-1:0] x_q;
      logic signed [WIDTH_M-1:0] m [N];
      logic signed [WIDTH_Y-1:0] a [N];

      always_ff @(posedge clk or negedge rstn)
        x_q <= ~rstn ? 0 : x;
      
      for (n=0; n < N; n=n+1)
        assign m[n] = B[N-1-n] * x_q;
      
      always_ff @(posedge clk or negedge rstn)
        a[0] <= ~rstn ? 0 : m[0];

      for (n=1; n < N; n=n+1)
        always_ff @(posedge clk or negedge rstn)
          a[n] <= ~rstn ? 0 : a[n-1] + m[n];

      assign y = a[N-1];

    end
  endgenerate

endmodule