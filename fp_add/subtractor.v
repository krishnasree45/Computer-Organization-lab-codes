//`include "comp8.v"
module main(sa,sb,opcode,ma,mb,ea,eb,sign,mant,exp);
input sa,sb,opcode;
input [22:0]ma,mb;
input [7:0]ea,eb;
output sign;
output [22:0]mant;
output [7:0]exp;
wire [7:0]r;
wire cout,signbit;
wire [23:0]ma1,mb1;
wire [31:0]mashift,mbshift;
wire [4:0]r1;
wire [31:0]x1,x2;
wire [31:0]madumy,mbdumy;
wire [1:0]elg;
reg [7:0]x_temp,x_temp1;
wire [7:0]exp1;
wire [23:0]sum;
wire outcarry;
wire c111;
assign ma1[23]=1'b1;
assign ma1[22:0]=ma[22:0];

assign mb1[23]=1'b1;
assign mb1[22:0]=mb[22:0];

assign mashift[23:0]=ma1[23:0];
assign mbshift[23:0]=mb1[23:0];

assign mashift[31:24]=7'b0;
assign mbshift[31:24]=7'b0;//making mantissa 32 bits

sub ss(ea,eb,r,cout);//subtracting to get which exp is max by what amount

always@*
begin
	if(cout==1'b1)
	begin 
	 x_temp<=ea;
	end
	else
	begin
	 x_temp<=eb;
	end
end

assign exp=x_temp;
assign r1[4:0]=r[4:0];

shifterright32 s0(mashift,r1,x1);//shifting ma

shifterright32 s1(mbshift,r1,x2);//shifting mb

assign madumy=mashift;
assign mbdumy=mbshift;

new n0(r1,cout,x1,x2,madumy,mbdumy,elg);//for detecting which mantissa is shifted

assign ma1[23:0]=madumy[23:0];
assign mb1[23:0]=mbdumy[23:0];

comb n1(sa,sb,opcode,ma1,mb1,elg,sum,outcarry,signbit);//for end calcln

//cla8(cout,s,a,b,cin)
cla8 c000(c111,exp1,exp,00000001,0);//for final ops
always@*
begin
	if(outcarry==1'b1)
	begin 
	 x_temp1<=exp1;
	end
	else
	begin
	 x_temp1<=exp;
	end
end

assign exp=x_temp1;
assign mant=sum;
assign sign =signbit;

endmodule


module new(r,cout,x1,x2,madumy,mbdumy,elg);

input [4:0]r;
input cout;
input [31:0]x1,x2;
output reg [31:0]madumy,mbdumy;
output reg [1:0]elg;

always@(*)
begin
 if(cout==1'b1)
 begin
 mbdumy<=x2;
 elg<=2'b01;
 end
 if(cout==1'b0 && r!=7'b0)
 begin
  madumy<=x1;
  elg<=2'b10;
 end
 if(cout==1'b0 && r==7'b0)
 begin
   madumy<=x1;
   mbdumy<=x2;
   elg<=2'b00;
 end
end

endmodule





module sub(a,b,r,cout);
input [7:0]a,b;
output reg [7:0]r;
output reg cout;
wire e,l,g;
wire [7:0]x1,x2;
wire cout1,cout2; 
//comparator8(a,b,e,l,g)
comp8 c1(a,b,e,l,g);


//cla8(cout,s,a,b,cin);
cla8  c11(cout1,x1,a,~b,1);

cla8  c22(cout2,x2,b,~a,1);
always@(*)
begin
  if(l==1'b1)
  begin
	 r<=x2;
	 cout<=1'b0;
	 
  end
  if(g==1'b1)
  begin
	 r<=x1;
	 cout<=1'b1;
  end
  if(e==1'b1)
  begin
	r<=8'b0;
	cout<=1'b0;
  end

end


endmodule



//`include "cla8.v"
module comp8(a,b,e,l,g);
input [7:0]a,b;
output e,l,g;
wire [7:0]temp,sum;
wire cout;

assign temp=(a&b)|(~a&~b);
assign e=&temp;
//cla8(cout,s,a,b,cin);
cla8 c0(cout,sum,a,~b,1);

assign l=(~cout)&1;

assign g=(~e)&(~l);

endmodule


//`include "cla32.v"
//`include "shifterright32.v"
module comb(sa,sb,opcode,ma1,mb1,elg,sum,cout,signbit);

input sa,sb,opcode;
input [1:0]elg;
input [23:0]ma1,mb1;
output [23:0]sum;
output cout,signbit;
reg [31:0]sum_temp;
reg carry_temp,sign_temp;
wire [31:0]s1,s2,s3,s4,s5;
wire c1,c2,c3,c4,c5;
wire [31:0]macomb,mbcomb;
wire [31:0]sum_temp1;

reg [31:0]x1;



assign macomb[31:24]=7'b0;
assign macomb[23:0]=ma1[23:0];

assign mbcomb[31:24]=7'b0;
assign mbcomb[23:0]=mb1[23:0];


cla32 c11(c1,s1,macomb,mbcomb,0);//1
cla32 c12(c2,s2,macomb,~mbcomb,1);//2

cla32 c13(c4,s4,macomb,mbcomb,0);//4
cla32 c14(c5,s5,~macomb,mbcomb,1);//5
cla32 c15(c3,s3,~s5,1,0);//3

always@(*)
begin
 if(elg==2'b01)
 begin
 	if(sa==1'b0 && sb==1'b0 && opcode==1'b0)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b0 && opcode==1'b1)
	begin
		sum_temp<=s2;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b1 && opcode==1'b0)
	begin
		sum_temp<=s2;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b1 && opcode==1'b1)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b0;
  	end
	if(sa==1'b1 && sb==1'b0 && opcode==1'b0)
	begin
		sum_temp<=s3;
		carry_temp<=1'b0;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b0 && opcode==1'b1)
	begin
		sum_temp<=s4;
		carry_temp<=c4;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b1 && opcode==1'b0)
	begin
		sum_temp<=s4;
		carry_temp<=c4;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b1 && opcode==1'b1)
	begin
		sum_temp<=s3;
		carry_temp<=1'b0;
		sign_temp<=1'b1;
  	end

 end


 if(elg==2'b10)
 begin
 	if(sa==1'b0 && sb==1'b0 && opcode==1'b0)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b0 && opcode==1'b1)
	begin
		sum_temp<=s3;
		carry_temp<=1'b0;
		sign_temp<=1'b1;
  	end
	if(sa==1'b0 && sb==1'b1 && opcode==1'b0)
	begin
		sum_temp<=s3;
		carry_temp<=1'b0;
		sign_temp<=1'b1;
  	end
	if(sa==1'b0 && sb==1'b1 && opcode==1'b1)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b0;
  	end
	if(sa==1'b1 && sb==1'b0 && opcode==1'b0)
	begin
		sum_temp<=s5;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end
	if(sa==1'b1 && sb==1'b0 && opcode==1'b1)
	begin
		sum_temp<=s4;
		carry_temp<=c4;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b1 && opcode==1'b0)
	begin
		sum_temp<=s4;
		carry_temp<=c4;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b1 && opcode==1'b1)
	begin
		sum_temp<=s5;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end

 end


 if(elg==2'b00)
 begin
 	if(sa==1'b0 && sb==1'b0 && opcode==1'b0)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b0 && opcode==1'b1)
	begin
		sum_temp<=1'b0;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b1 && opcode==1'b0)
	begin
		sum_temp<=1'b0;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end
	if(sa==1'b0 && sb==1'b1 && opcode==1'b1)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b0;
  	end
	if(sa==1'b1 && sb==1'b0 && opcode==1'b0)
	begin
		sum_temp<=1'b0;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end
	if(sa==1'b1 && sb==1'b0 && opcode==1'b1)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b1 && opcode==1'b0)
	begin
		sum_temp<=s1;
		carry_temp<=c1;
		sign_temp<=1'b1;
  	end
	if(sa==1'b1 && sb==1'b1 && opcode==1'b1)
	begin
		sum_temp<=1'b0;
		carry_temp<=1'b0;
		sign_temp<=1'b0;
  	end

 end

end


shifterright32  s0(sum_temp,00001,sum_temp1);
always@(*)
begin
 if(carry_temp==1'b1)
 begin 
  x1<=sum_temp1;
 end
 else 
 begin 
  x1<=sum_temp;
 end
end

assign sum[23:0]=x1[23:0];
assign cout=carry_temp;
assign signbit=sign_temp;
endmodule



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


module mux2(a,b,s,r);
input a,b,s;
output r;
wire w1,w2,w3;
assign w1=~s;
assign w2=w1&a;
assign w3=b&s;
assign r=w2|w3;
endmodule


//`include "mux2.v"
module shifterright32(a,s,b);
input [31:0]a;
input [4:0]s;
wire [37:0]w;
wire [31:0]g;
wire [31:0]m,p;
output [31:0]b;
assign w[1]=~s[0];
assign w[2]=~s[1];
assign w[3]=~s[2];
assign w[4]=~s[3];
assign w[5]=~s[4];
assign w[0]=0;	
	mux2	f0(w[0],a[31],w[1],w[6]);
	mux2 	f1(a[31],a[30],w[1],w[7]);
	mux2	f2(a[30],a[29],w[1],w[8]);
	mux2 	f3(a[29],a[28],w[1],w[9]);
	mux2	f4(a[28],a[27],w[1],w[10]);
	mux2 	f5(a[27],a[26],w[1],w[11]);
	mux2	f6(a[26],a[25],w[1],w[12]);
	mux2 	f7(a[25],a[24],w[1],w[13]);
	mux2	f8(a[24],a[23],w[1],w[14]);
	mux2 	f9(a[23],a[22],w[1],w[15]);
	mux2	f10(a[22],a[21],w[1],w[16]);
	mux2 	f11(a[21],a[20],w[1],w[17]);
	mux2	f12(a[20],a[19],w[1],w[18]);
	mux2 	f13(a[19],a[18],w[1],w[19]);
	mux2	f14(a[18],a[17],w[1],w[20]);
	mux2 	f15(a[17],a[16],w[1],w[21]);
	mux2	f16(w[16],a[15],w[1],w[22]);
	mux2 	f17(a[15],a[14],w[1],w[23]);
	mux2	f18(a[14],a[13],w[1],w[24]);
	mux2 	f19(a[13],a[12],w[1],w[25]);
	mux2	f20(a[12],a[11],w[1],w[26]);
	mux2 	f21(a[11],a[10],w[1],w[27]);
	mux2	f22(a[10],a[9],w[1],w[28]);
	mux2 	f23(a[9],a[8],w[1],w[29]);
	mux2	f24(a[8],a[7],w[1],w[30]);
	mux2 	f25(a[7],a[6],w[1],w[31]);
	mux2	f26(a[6],a[5],w[1],w[32]);
	mux2 	f27(a[5],a[4],w[1],w[33]);
	mux2	f28(a[4],a[3],w[1],w[34]);
	mux2 	f29(a[3],a[2],w[1],w[35]);
	mux2	f30(a[2],a[1],w[1],w[36]);
	mux2 	f31(a[1],a[0],w[1],w[37]);


	mux2	p0(w[0],w[6],w[2],g[0]);
	mux2	p1(w[0],w[7],w[2],g[1]);
	mux2	p2(w[6],w[8],w[2],g[2]);
	mux2	p3(w[7],w[9],w[2],g[3]);
	mux2	p4(w[8],w[10],w[2],g[4]);
	mux2	p5(w[9],w[11],w[2],g[5]);
	mux2	p6(w[10],w[12],w[2],g[6]);
	mux2	p7(w[11],w[13],w[2],g[7]);
	mux2	p8(w[12],w[14],w[2],g[8]);
	mux2	p9(w[13],w[15],w[2],g[9]);
	mux2	p10(w[14],w[16],w[2],g[10]);
	mux2	p11(w[15],w[17],w[2],g[11]);
	mux2	p12(w[16],w[18],w[2],g[12]);
	mux2	p13(w[17],w[19],w[2],g[13]);
	mux2	p14(w[18],w[20],w[2],g[14]);
	mux2	p15(w[19],w[21],w[2],g[15]);
	mux2	p00(w[20],w[22],w[2],g[16]);
	mux2	p01(w[21],w[23],w[2],g[17]);
	mux2	p02(w[22],w[24],w[2],g[18]);
	mux2	p03(w[23],w[25],w[2],g[19]);
	mux2	p04(w[24],w[26],w[2],g[20]);
	mux2	p05(w[25],w[27],w[2],g[21]);
	mux2	p06(w[26],w[28],w[2],g[22]);
	mux2	p07(w[27],w[29],w[2],g[23]);
	mux2	p08(w[28],w[30],w[2],g[24]);
	mux2	p09(w[29],w[31],w[2],g[25]);
	mux2	p010(w[30],w[32],w[2],g[26]);
	mux2	p011(w[31],w[33],w[2],g[27]);
	mux2	p012(w[32],w[34],w[2],g[28]);
	mux2	p013(w[33],w[35],w[2],g[29]);
	mux2	p014(w[34],w[36],w[2],g[30]);
	mux2	p015(w[35],w[37],w[2],g[31]);

	mux2	k0(w[0],g[0],w[3],m[0]);
	mux2	k1(w[0],g[1],w[3],m[1]);
	mux2	k2(w[0],g[2],w[3],m[2]);
	mux2	k3(w[0],g[3],w[3],m[3]);
	mux2	k4(g[0],g[4],w[3],m[4]);
	mux2	k5(g[1],g[5],w[3],m[5]);
	mux2	k6(g[2],g[6],w[3],m[6]);
	mux2	k7(g[3],g[7],w[3],m[7]);
	mux2	k8(g[4],g[8],w[3],m[8]);
	mux2	k9(g[5],g[9],w[3],m[9]);
	mux2	k10(g[6],g[10],w[3],m[10]);
	mux2	k11(g[7],g[11],w[3],m[11]);
	mux2	k12(g[8],g[12],w[3],m[12]);
	mux2	k13(g[9],g[13],w[3],m[13]);
	mux2	k14(g[10],g[14],w[3],m[14]);
	mux2	k15(g[11],g[15],w[3],m[15]);
	mux2	k00(g[12],g[16],w[3],m[16]);
	mux2	k01(g[13],g[17],w[3],m[17]);
	mux2	k02(g[14],g[18],w[3],m[18]);
	mux2	k03(g[15],g[19],w[3],m[19]);
	mux2	k04(g[16],g[20],w[3],m[20]);
	mux2	k05(g[17],g[21],w[3],m[21]);
	mux2	k06(g[18],g[22],w[3],m[22]);
	mux2	k07(g[19],g[23],w[3],m[23]);
	mux2	k08(g[20],g[24],w[3],m[24]);
	mux2	k09(g[21],g[25],w[3],m[25]);
	mux2	k010(g[22],g[26],w[3],m[26]);
	mux2	k011(g[23],g[27],w[3],m[27]);
	mux2	k012(g[24],g[28],w[3],m[28]);
	mux2	k013(g[25],g[29],w[3],m[29]);
	mux2	k014(g[26],g[30],w[3],m[30]);
	mux2	k015(g[27],g[31],w[3],m[31]);
	

	mux2	b0(w[0],m[0],w[4],p[0]);
	mux2	b1(w[0],m[1],w[4],p[1]);
	mux2	b2(w[0],m[2],w[4],p[2]);
	mux2	b3(w[0],m[3],w[4],p[3]);
	mux2	b4(w[0],m[4],w[4],p[4]);
	mux2	b5(w[0],m[5],w[4],p[5]);
	mux2	b6(w[0],m[6],w[4],p[6]);
	mux2	b7(w[0],m[7],w[4],p[7]);
	mux2	b8(m[0],m[8],w[4],p[8]);
	mux2	b9(m[1],m[9],w[4],p[9]);
	mux2	b10(m[2],m[10],w[4],p[10]);
	mux2	b11(m[3],m[11],w[4],p[11]);
	mux2	b12(m[4],m[12],w[4],p[12]);
	mux2	b13(m[5],m[13],w[4],p[13]);
	mux2	b14(m[6],m[14],w[4],p[14]);
	mux2	b15(m[7],m[15],w[4],p[15]);
	mux2	b00(m[8],m[16],w[4],p[16]);
	mux2	b01(m[9],m[17],w[4],p[17]);
	mux2	b02(m[10],m[18],w[4],p[18]);
	mux2	b03(m[11],m[19],w[4],p[19]);
	mux2	b04(m[12],m[20],w[4],p[20]);
	mux2	b05(m[13],m[21],w[4],p[21]);
	mux2	b06(m[14],m[22],w[4],p[22]);
	mux2	b07(m[15],m[23],w[4],p[23]);
	mux2	b08(m[16],m[24],w[4],p[24]);
	mux2	b09(m[17],m[25],w[4],p[25]);
	mux2	b010(m[18],m[26],w[4],p[26]);
	mux2	b011(m[19],m[27],w[4],p[27]);
	mux2	b012(m[20],m[28],w[4],p[28]);
	mux2	b013(m[21],m[29],w[4],p[29]);
	mux2	b014(m[22],m[30],w[4],p[30]);
	mux2	b015(m[23],m[31],w[4],p[31]);

	mux2	m0(w[0],p[0],w[5],b[31]);
	mux2	m1(w[0],p[1],w[5],b[30]);
	mux2	m2(w[0],p[2],w[5],b[29]);
	mux2	m3(w[0],p[3],w[5],b[28]);
	mux2	m4(w[0],p[4],w[5],b[27]);
	mux2	m5(w[0],p[5],w[5],b[26]);
	mux2	m6(w[0],p[6],w[5],b[25]);
	mux2	m7(w[0],p[7],w[5],b[24]);
	mux2	m8(w[0],p[8],w[5],b[23]);
	mux2	m9(w[0],p[9],w[5],b[22]);
	mux2	m10(w[0],p[10],w[5],b[21]);
	mux2	m11(w[0],p[11],w[5],b[20]);
	mux2	m12(w[0],p[12],w[5],b[19]);
	mux2	m13(w[0],p[13],w[5],b[18]);
	mux2	m14(w[0],p[14],w[5],b[17]);
	mux2	m15(w[0],p[15],w[5],b[16]);
	mux2	m00(m[0],p[16],w[5],b[15]);
	mux2	m01(m[1],p[17],w[5],b[14]);
	mux2	m02(m[2],p[18],w[5],b[13]);
	mux2	m03(m[3],p[19],w[5],b[12]);
	mux2	m04(m[4],p[20],w[5],b[11]);
	mux2	m05(m[5],p[21],w[5],b[10]);
	mux2	m06(m[6],p[22],w[5],b[9]);
	mux2	m07(m[7],p[23],w[5],b[8]);
	mux2	m08(m[8],p[24],w[5],b[7]);
	mux2	m09(m[9],p[25],w[5],b[6]);
	mux2	m010(m[10],p[26],w[5],b[5]);
	mux2	m011(m[11],p[27],w[5],b[4]);
	mux2	m012(m[12],p[28],w[5],b[3]);
	mux2	m013(m[13],p[29],w[5],b[2]);
	mux2	m014(m[14],p[30],w[5],b[1]);
	mux2	m015(m[15],p[31],w[5],b[0]);
endmodule



module cla32(cout,s,a,b,cin);
output [31:0]s;
output cout;
input [31:0]a,b;
//input clk;
input cin;
wire [31:0]g,p,c,s;
//wire cin1,cout;
//wire [31:0]q,b,c,q3;

assign g=a&b;
assign p=a^b;

//d_ff faa(a[0],b[0],cin,clk,q[0],b[0],cin1);
assign c[0]=g[0]|(p[0]&cin);
//d_ff f0(a[0],b[0],c[0],clk,q[0],b[0],c[0]);


assign c[1]=g[1]|(p[1]&(g[0]|(p[0]&cin)));
//d_ff f1(a[1],b[1],c[1],clk,q[1],b[1],c[1]);

assign c[2]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))));
//d_ff f2(a[2],b[2],c[2],clk,q[2],b[2],c[2]);

assign c[3]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))));
//d_ff f3(a[3],b[3],c[3],clk,q[3],b[3],c[3]);

assign c[4]=g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))));
//d_ff f4(a[4],b[4],c[4],clk,q[4],b[4],c[4]);

assign c[5]=g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))));
//d_ff f5(a[5],b[5],c[5],clk,q[5],b[5],c[5]);

assign c[6]=g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))));
//d_ff f6(a[6],b[6],c[6],clk,q[6],b[6],c[6]);

assign c[7]=g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))));
//d_ff f7(a[7],b[7],c[7],clk,q[7],b[7],c[7]);

assign c[8]=g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))));
//d_ff f8(a[8],b[8],c[8],clk,q[8],b[8],c[8]);

assign c[9]=g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))));
//d_ff f9(a[9],b[9],c[9],clk,q[9],b[9],c[9]);

assign c[10]=g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))));
//d_ff f10(a[10],b[10],c[10],clk,q[10],b[10],c[10]);

assign c[11]=g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))));
//d_ff f11(a[11],b[11],c[11],clk,q[11],b[11],c[11]);

assign c[12]=g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))));
//d_ff f12(a[12],b[12],c[12],clk,q[12],b[12],c[12]);

assign c[13]=g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))));
//d_ff f13(a[13],b[13],c[13],clk,q[13],b[13],c[13]);

assign c[14]=g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))));
//d_ff f14(a[14],b[14],c[14],clk,q[14],b[14],c[14]);

assign c[15]=g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))));
//d_ff f15(a[15],b[15],c[15],clk,q[15],b[15],c[15]);

assign c[16]=g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))));
//d_ff f16(a[16],b[16],c[16],clk,q[16],b[16],c[16]);

assign c[17]=g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))));
//d_ff f17(a[17],b[17],c[17],clk,q[17],b[17],c[17]);

assign c[18]=g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))));
//d_ff f18(a[18],b[18],c[18],clk,q[18],b[18],c[18]);

assign c[19]=g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))));
//d_ff f19(a[19],b[19],c[19],clk,q[19],b[19],c[19]);

assign c[20]=g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))));
//d_ff f20(a[20],b[20],c[20],clk,q[20],b[20],c[20]);

assign c[21]=g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))));
//d_ff f21(a[21],b[21],c[21],clk,q[21],b[21],c[21]);

assign c[22]=g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))));
//d_ff f22(a[22],b[22],c[22],clk,q[22],b[22],c[22]);

assign c[23]=g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f23(a[23],b[23],c[23],clk,q[23],b[23],c[23]);

assign c[24]=g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f24(a[24],b[24],c[24],clk,q[24],b[24],c[24]);

assign c[25]=g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f25(a[25],b[25],c[25],clk,q[25],b[25],c[25]);

assign c[26]=g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p
[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f26(a[26],b[26],c[26],clk,q[26],b[26],c[26]);

assign c[27]=g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f27(a[27],b[27],c[27],clk,q[27],b[27],c[27]);

assign c[28]=g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f28(a[28],b[28],c[28],clk,q[28],b[28],c[28]);

assign c[29]=g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f29(a[29],b[29],c[29],clk,q[29],b[29],c[29]);

assign c[30]=g[30]|(p[30]&(g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f30(a[30],b[30],c[30],clk,q[30],b[30],c[30]);

assign c[31]=g[31]|(p[31]&(g[30]|(p[30]&(g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(g[20]&(g[19]|(p[19]&g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
//d_ff f31(a[31],b[31],c[31],clk,q[31],b[31],c[31]);




assign s[0]=a[0]^b[0]^cin;
assign s[1]=a[1]^b[1]^c[0];
assign s[2]=a[2]^b[2]^c[1];
assign s[3]=a[3]^b[3]^c[2];
assign s[4]=a[4]^b[4]^c[3];
assign s[5]=a[5]^b[5]^c[4];
assign s[6]=a[6]^b[6]^c[5];
assign s[7]=a[7]^b[7]^c[6];
assign s[8]=a[8]^b[8]^c[7];
assign s[9]=a[9]^b[9]^c[8];
assign s[10]=a[10]^b[10]^c[9];
assign s[11]=a[11]^b[11]^c[10]; 
assign s[12]=a[12]^b[12]^c[11];
assign s[13]=a[13]^b[13]^c[12];
assign s[14]=a[14]^b[14]^c[13];
assign s[15]=a[15]^b[15]^c[14];
assign s[16]=a[16]^b[16]^c[15];
assign s[17]=a[17]^b[17]^c[16];
assign s[18]=a[18]^b[18]^c[17];
assign s[19]=a[19]^b[19]^c[18];
assign s[20]=a[20]^b[20]^c[19];
assign s[21]=a[21]^b[21]^c[20];
assign s[22]=a[22]^b[22]^c[21];
assign s[23]=a[23]^b[23]^c[22];
assign s[24]=a[24]^b[24]^c[23];
assign s[25]=a[25]^b[25]^c[24];
assign s[26]=a[26]^b[26]^c[25];
assign s[27]=a[27]^b[27]^c[26];
assign s[28]=a[28]^b[28]^c[27];
assign s[29]=a[29]^b[29]^c[28];
assign s[30]=a[30]^b[30]^c[29];
assign s[31]=a[31]^b[31]^c[30];


assign cout=c[31];





endmodule

