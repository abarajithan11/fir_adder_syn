`timescale 1ns/1ps

module fir_filter #(
  parameter  TYPE = "NORMAL",
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

  generate
    if (TYPE == "NORMAL") begin:GN
      logic [WIDTH_X-1:0] z [N];
      logic [WIDTH_M-1:0] m [N];
      logic [WIDTH_Y-1:0] a [N];

      always_ff @(posedge clk or negedge rstn)
        for (int n=0; n < N; n=n+1)
          if (~rstn) z[n] <= 0;
          else       z[n] <= n==0 ? x : z[n-1];

      always_comb
        for (int n=0; n < N; n=n+1)
          m[n] = B[n] * z[n];

      assign a[0] = m[0];
      
      always_comb
        for (int n=1; n < N; n=n+1)
          a[n] = a[n-1] + m[n];

      assign y = a[N-1];
    end

  endgenerate

endmodule