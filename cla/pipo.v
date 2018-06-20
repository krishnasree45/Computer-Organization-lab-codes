`include "dflipfloprst.v"
module pipo(qa,qb,qc,qd,da,db,dc,dd,clk,rst);
output qa,qb,qc,qd;
input da,db,dc,dd,rst,clk;
dflipfloprst d1(qa,da,clk,rst);
dflipfloprst d2(qb,db,clk,rst);
dflipfloprst d3(qc,dc,clk,rst);
dflipfloprst d4(qd,dd,clk,rst);
endmodule
