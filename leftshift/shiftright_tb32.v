`include "left_barrel.v"

module top();

reg [31:0]a;
reg s0,s1,s2,s3,s4;
wire [31:0]out;

leftbarrelshift32 abc(a,s0,s1,s2,s3,s4,out);

initial
begin

a=32'd255;
s4=1'b1;
s3=1'b1;
s2=1b'0;
s1=1'b1;
s0=1'b1;


$monitor ($time,"a=%d,s4=%b,s3=%b,s2=%b,s1=%b,s0=%b,out=%d",a,s4,s3,s2,s1,s0,out);

end
endmodule


