`include "pri_enc32.v"
module pri32tb();

reg [31:0]d;
wire [4:0]out;
wire A;

pri_enc32 p0(d,out,A);

initial 
begin 
 assign d=32'b00000000000000000000000000000100;
$monitor ("d=%b,out=%b,A=%b",d,out,A);
end

endmodule
