`include "carryadder.v"
module cladder();

reg [31:0]a,b;
reg cin;
wire [31:0]sum;
wire cout;

cla_32 p0(a,~b,cin,sum,cout);

initial 
begin 

a=32'b00000000111000000000000000000000;
b=32'b00000000010000000000000000000000;
cin=1'b1;
$monitor ("a=%b,b=%b,cin%b,sum=%b,cout=%b",a,b,cin,sum,cout);
end

endmodule
