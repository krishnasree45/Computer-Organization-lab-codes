`include"comparator.v"
module comparator_tb();
reg [7:0]a,b;
wire eql,noteql;

comparator c3(a,b,eql,noteql);
initial
begin
a=8'd0;
b=8'd2;
$monitor("a equal b=%b,a not equal to b=%b",eql,noteql);
end 
endmodule
