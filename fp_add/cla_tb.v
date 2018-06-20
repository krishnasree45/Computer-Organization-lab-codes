`include "cla8.v"
module cla8tb();
reg [7:0]a,b;
reg cin;
wire [7:0]s;
wire cout;
reg [7:0]temp;
cla8 f0(cout,s,a,~b,1);
initial
begin
a=8'b11100000;
b=8'b01000000;
cin=1'b1;
temp=~b;
$monitor("sum=   %b\ncout=\t\t%b,~b=%b",s,cout,temp);
end
endmodule
