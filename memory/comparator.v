//`include"cla8.v"
module comparator(a,b,eql,noteql);

input [7:0]a,b;
output eql,noteql;
wire [7:0]exnor,s,bnot,b1,s1;
wire cout1,cout;

assign bnot=~b;
assign exnor=(a&b)|(~a)&(~b);
//exnor[0]&exnor[1]&exnor[2]&exnor[3]&exnor[4]&exnor[5]&exnor[6]&exnor[7]&exnor[8]&exnor[9]&exnor[10]&exnor[11]&exnor[12]&exnor[13]&exnor[14]&exnor[15];
assign eql=&exnor;
assign noteql=~(eql&1);

endmodule	
