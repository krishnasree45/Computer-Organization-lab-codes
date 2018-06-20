`include "pipo.v"

module pipo_tb;
reg da,db,dc,dd,clk,rst;
wire qa,qb,qc,qd;

pipo p1(qa,qb,qc,qd,da,db,dc,dd,clk,rst);

initial
begin

clk=1'b0;
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
rst=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;
#2
da=1'b1;
db=1'b1;
dc=1'b1;
dd=1'b1;
#2
da=1'b0;
db=1'b0;
dc=1'b0;
dd=1'b0;

#20
$finish;
end
initial
begin
	$dumpfile("pipo.vcd");
	$dumpvars;
end

always
#1 clk=~clk;

initial
$monitor($time, "clk=%d da=%b,db=%b,dc=%b,dd=%b qa=%b,qb=%b,qc=%b,qd=%b",clk,da,db,dc,dd,qa,qb,qc,qd);

endmodule

