`include "cla8.v"
module comp8(a,b,e,l,g);
input [7:0]a,b;
output e,l,g;
wire [7:0]temp,sum;
wire cout;

assign temp=(a&b)|(~a&~b);
assign e=&temp;
//cla8(cout,s,a,b,cin);
cla8 c0(cout,sum,a,~b,1);

assign g=cout&1;

assign l=(~e)&(~g);

endmodule



