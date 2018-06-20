`include "pri_enc.v"
//
module pri_enc32(d,out,A);

input [31:0]d;
output [4:0]out;
output A;

wire [3:0]z,y,x,p,a;

pri_enc p0(d[7:0],z[0],y[0],x[0],a[0]);
pri_enc p1(d[15:8],z[1],y[1],x[1],a[1]);
pri_enc p2(d[23:16],z[2],y[2],x[2],a[2]);
pri_enc p3(d[31:24],z[3],y[3],x[3],a[3]);

assign A=a[3]&a[2]&a[1]&a[0];
assign out[4]=~a[3]|~a[2];
assign out[3]=~a[3]|(a[2]&(~a[1]));

assign p[0]=~(out[4]|out[3]);
assign p[1]=out[3]&(~out[4]);
assign p[2]=(~out[3])&out[4];
assign p[3]=out[3]&out[4];

assign out[2]=(z[0]&p[0] | z[1]&p[1] | z[2]&p[2] | z[3]&p[3]) ;
assign out[1]=(y[0]&p[0] | y[1]&p[1] | y[2]&p[2] | y[3]&p[3] );
assign out[0]=(x[0]&p[0] | x[1]&p[1] | x[2]&p[2] | x[3]&p[3]) ;

endmodule

