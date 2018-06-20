module main(x1,x2,r,cout,x11);
input [4:0]r;
input cout;
input [31:0]x1,x2;
output [31:0]x11;

new n00(r,cout,x1,x2,x11);

endmodule

module new(r,cout,x1,x2,x11);

input [4:0]r;
input cout;
input [31:0]x1,x2;
output reg [31:0]x11;
//reg [31:0]ma;

always@(*)
begin
 if(cout==1'b1)
 begin
 x11<=x2;
 //ma<=x11;
 end
 if(cout==1'b0 && r!=7'b0)
 begin
  x11<=x1;
 end
 if(cout==1'b0 && r==7'b0)
 begin
   x11<=32'b0;
 end
end



endmodule
