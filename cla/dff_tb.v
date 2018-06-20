`include "dff.v"

module top;
reg d,clk,reset;
wire q;

dff out(reset,clk,d,q);

initial
clk=1'b0;

initial
begin

reset=1'b1;
clk=1'b0;

#4
d=1'b1;
reset=1'b0;

#4
d=1'b0;

#4
d=1'b1;

#4
d=1'b0;

#8 $finish;
end

always
#2 clk=~clk;

initial
$monitor($time,"clock=%b,d=%b,reset=%b,q=%b",clk,d,reset,q);
endmodule




