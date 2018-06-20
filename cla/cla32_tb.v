`include "cla32.v"

module top;
reg [31:0]a,b;
reg cin,clk;
wire cout;
wire [31:0]s;

cla16 out(cout,s,a,b,cin,clk);

initial
clk=1'b0;

initial
begin


#4
a=32'b00000000000000000000000000000011;
b=16'b00000000000000000000000000001000;
cin=1'b0;




#8 $finish;
end

always
#2 clk=~clk;

initial
$monitor($time,"clock=%b,a=%b,b=%b,s=%b,cout=%b",clk,a,b,s,cout);
endmodule




