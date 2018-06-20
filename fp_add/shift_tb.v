`include "shiftleft.v"
module shifterright32tb();
reg [31:0]a;
reg [4:0]s;
wire [31:0]b;
barrellft16 f1(a,s[0],s[1],s[2],s[3],s[4],b);
initial
begin
a=32'b00000000010000010000000000000000;
s=5'b00001;
$monitor("a=%b,s=%b,\nb=%b",a,s,b);
end
endmodule
