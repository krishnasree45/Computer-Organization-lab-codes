`include "cla16.v"
module cla16tb();
reg [15:0]a,b;
reg cin;
wire [15:0]s;
wire cout;
cla16 f0(cout,s,a,b,cin);
initial
begin
a=16'd4;
b=16'd5;
cin=1'd1;
$monitor("sum=   %d\ncout=\t\t%d",s,cout);
end
endmodule
