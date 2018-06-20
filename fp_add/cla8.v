module cla8(cout,s,a,b,cin);

input [7:0]a,b;
input cin;

output [7:0]s;
output cout;
wire [7:0]g,p,c;
assign g=a&b;
assign p=a^b;
assign c[0]=g[0]|(p[0]&cin);
assign c[1]=g[1]|(p[1]&(g[0]|(p[0]&cin)));
assign c[2]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))));
assign c[3]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))));
assign c[4]=g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))));

assign c[5]=g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))));

assign c[6]=g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))));

assign c[7]=g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))));


assign cout=c[7];
assign s[0]=p[0]^cin;
assign s[1]=p[1]^c[0];
assign s[2]=p[2]^c[1];
assign s[3]=p[3]^c[2];
assign s[4]=p[4]^c[3];
assign s[5]=p[5]^c[4];
assign s[6]=p[6]^c[5];
assign s[7]=p[7]^c[6];


endmodule



