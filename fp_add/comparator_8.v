`include "cla8.v"
module comparator8(a,b,e,l,g);

input [7:0]a,b;
output e,l,g;
wire [7:0]temp,sum;
wire cout;

assign temp=(a&b) | (~a & ~b);
assign e=&temp;

cla_8 c1(a,~b,1,sum,cout);

assign l=(~cout)&1;
assign g=(~l) & (~e);

endmodule
