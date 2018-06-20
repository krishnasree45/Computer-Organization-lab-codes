module pri_enc(d,z,y,x,a);
input [7:0]d;
output x,y,z,a;
wire [5:0]k;

assign k[0]=(~d[7]&d[6]);//a
assign k[1]=(~d[7]&~d[6]&d[5]);//b
assign k[2]=(~d[7]&~d[6]&~d[5]&d[4]);//c
assign k[3]=(~d[7]&~d[6]&~d[5]&~d[4]&d[3]);//d
assign k[4]=(~d[7]&~d[6]&~d[5]&~d[4]&~d[3]&d[2]);//e
assign k[5]=(~d[7]&~d[6]&~d[5]&~d[4]&~d[3]&~d[2]&d[1]);//f

assign z=d[7]|k[0]|k[1]|k[2];
assign y=d[7]|k[0]|k[4]|k[3];
assign x=d[7]|k[1]|k[3]|k[5];
assign a=(~d[7]&~d[6]&~d[5]&~d[4]&~d[3]&~d[2]&~d[1]&~d[0]);


endmodule
