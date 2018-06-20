`include "barrelshift32.v"

module top();

reg [31:0]a;
reg s0,s1,s2,s3,s4;
wire [31:0]out;

barrelshift32 abc(a,s0,s1,s2,s3,s4,out);

initial
begin

a=32'd8;
s4=1'b0;
s3=1'b0;
s2=1'b0;
s1=1'b1;
s0=1'b1;

//initial
$monitor ($time,"a=%b,s4=%b,s3=%b,s2=%b,s1=%b,s0=%b,out=%d",a,s4,s3,s2,s1,s0,out);
end
endmodule


