`include "pri_enc.v"
module pritb();

reg [7:0]d;
wire x,y,z,a;

pri_enc p0(d,z,y,x,a);

initial 
begin 
 assign d=8'b010000000000000000000000;
$monitor ("d=%b,z=%b,y=%b,x=%b,a=%b",d,z,y,x,a);
end

endmodule
