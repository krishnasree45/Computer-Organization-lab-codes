`include "left_barrel.v"
module shifterright32tb();
reg [31:0]a;
reg [4:0]s;
wire [31:0]b;
leftbarrelshift32 f1(a,s[0],s[1],s[2],s[3],s[4],b);
initial
begin
a=32'b00000000010000000000000000000000;
s=5'b00001;
$monitor("a=%b,s=%b,\nb=%b",a,s,b);
end
endmodule


/*`include "left_barrel.v"

module top();

reg [3:0]a;
reg s0,s1;
wire [3:0]out;

leftbarrelshift4 abc(a,s0,s1,out);

initial
begin

a=4'b0111;
s1=1'b1;
s0=1'b0;


$monitor ($time,"a=%b,s1=%b,s0=%b,out=%b",a,s1,s0,out);

end
endmodule*/


