`include "cla8.v"
module comparator8(a,b,e,l,g);

input [7:0]a,b;
output e,l,g;
wire [7:0]temp,sum;
wire cout;
wire [7:0]x;

assign temp=(a&b) | (~a & ~b);
assign e=&temp;
// cla8(cout,s,a,b,cin);
assign x=~b;
cla_8 c1(cout,sum,a,x,1);

assign l=(~cout)&1;
assign g=(~l) & (~e);

endmodule
