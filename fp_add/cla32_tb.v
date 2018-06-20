`include "cla32.v"
module cladder();

reg [31:0]a,b;
reg cin;
wire [31:0]s1,s2;
wire c1,c2;

cla_32 c14(a,~b,1,s1,c1);//5

cla_32 c15(~s1,1,0,s2,c2);//3


initial 
begin 

a=32'b00000000010000000000000000000000;
b=32'b00000000001000000000000000000000;
cin=1'b1;
$monitor ("a=%b,b=%b,s1=%b,s2=%b",a,b,s1,s2);
end

endmodule
