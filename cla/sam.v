//`include "carry.v"
module cla16(cout,s,a,b,cin,clk);
output [15:0]s;
output cout;
input [15:0]a,b;
input clk;
input cin;
reg [15:0]g,p,c,s;
reg [15:0]reg0,reg1,reg2;
reg cout;
assign g=a&b;
assign p=a^b;

//initial
//begin
	//assign reg0=16'b0000000000000000;
	////assign reg1=16'b0000000000000000;
	//assign reg2=16'b0000000000000000;
//end

always @  (posedge clk)
begin
assign c[0]=g[0]|(p[0]&cin);
assign c[1]=g[1]|(p[1]&(g[0]|(p[0]&cin)));
assign c[2]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))));
assign c[3]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))));
assign c[4]=g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))));

assign c[5]=g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))));

assign c[6]=g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))));

assign c[7]=g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))));

assign c[8]=g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))));

assign c[9]=g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))));

assign c[10]=g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))));

assign c[11]=g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))));

assign c[12]=g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))));

assign c[13]=g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))));

assign c[14]=g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))));

assign c[15]=g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))));





assign reg0=c;
end

always@ (posedge clk)
begin

if(reg2!=0)
begin

assign s[0]=p[0]^cin;
assign s[1]=p[1]^reg2[0];
assign s[2]=p[2]^reg2[1];
assign s[3]=p[3]^reg2[2];
assign s[4]=p[4]^reg2[3];
assign s[5]=p[5]^reg2[4];
assign s[6]=p[6]^reg2[5];
assign s[7]=p[7]^reg2[6];
assign s[8]=p[8]^reg2[7];
assign s[9]=p[9]^reg2[8];
assign s[10]=p[10]^reg2[9];
assign s[11]=p[11]^reg2[10]; 
assign s[12]=p[12]^reg2[11];
assign s[13]=p[13]^reg2[12];
assign s[14]=p[14]^reg2[13];
assign s[15]=p[15]^reg2[14];

assign cout=reg2[15];
end
assign reg2=reg0;
end
endmodule

