module main(sa,sb,opcode,ma,mb,ea,eb,out_mant,sign,exponent,totalcarry);

 input [7:0]ea,eb;
input [22:0]ma,mb;
input sa,sb,opcode;
wire [23:0]ma1,mb1;
//input clk;

reg [31:0]maaa,mbbb;
wire [23:0]out1,out2;
wire [23:0]mant;
output sign,totalcarry;
//output [31:0]sum2;
wire [23:0]sum;
wire outcarry,signbit;
wire [31:0]mashift,mbshift;
wire [7:0]r;
wire [4:0]r1;
wire cout;
wire [31:0]madumy,mbdumy;
wire [1:0]elg;
wire [31:0]x1,x2,x11;
wire c111,ccc;
wire [31:0]pri_mant;
wire [31:0]mantissa,mantissa_temp;
output [23:0]out_mant;

reg [7:0]x_temp;
output [7:0]exponent;
wire [7:0]x_temp1,res;
wire [7:0]temp_sub,out_sub;
wire A;
wire [4:0]out;
sub  sab(ea,eb,r,cout);

assign ma1[23]=1'b1;
assign ma1[22:0]=ma[22:0];

assign mb1[23]=1'b1;
assign mb1[22:0]=mb[22:0];

assign mashift[7:0]=8'b0;
assign mbshift[7:0]=8'b0;

assign mashift[31:8]=ma1[23:0];
assign mbshift[31:8]=mb1[23:0];

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

//assign exp=x_temp;
assign r1[4:0]=r[4:0];

shifterright32 s0(mashift,r1,x1);//shifting ma

shifterright32 s1(mbshift,r1,x2);//shifting mb

 
//new n0(r1,cout,x1,x2,madumy,mbdumy,elg);//for detecting which mantissa is shifted
new n000(r1,cout,x1,x2,x11,elg);
//
always@(*)
begin
	if(elg==2'b10)
	 begin 
	 	mbbb<=x11;
		maaa<=mashift;
	 end
	if(elg==2'b01)
	 begin 
		maaa<=x11;
		mbbb<=mbshift;
	 end
	if(elg==2'b00)
	 begin 
		maaa<=mashift;
		mbbb<=mbshift;
	 end
end
modinp mod(maaa,mbbb,sa,sb,opcode,elg,out1,out2,sum,outcarry,signbit);
modinput moddd(x_temp,outcarry,x_temp1);


assign sign=signbit;
assign mant=sum;
assign totalcarry=outcarry;
//assign exp=x_temp1;

assign pri_mant[31:24]=7'b0;
assign pri_mant[23:0]=mant[23:0];

pri_enc32 p0000(pri_mant,out,A);
//sub ss(ea,eb,r,cout);
assign temp_sub=8'b00010111;
assign out_sub[4:0]=out[4:0];
assign out_sub[7:5]=3'b0;
sub sdd(temp_sub,out_sub,res,ccc);
//assign res1=res;
assign exponent=x_temp1-res;


modinput2 mdi(res,mant,out_mant);

//barrellft16(a,s0,s1,s2,s3,s4,o4);
/*assign mantissa[23:0]=mant[23:0];
assign mantissa[31:24]=8'b0;


barrellft16 b0(mantissa,res1[0],res1[1],res1[2],res1[3],res1[4],mantissa_temp);

assign mant[23:0]=mantissa_temp[23:0];*/
endmodule



module modinput2 (res,mant,out_mant);
input [7:0]res;
input [23:0]mant;
//input clk;
wire [31:0]mantissa_temp,mantissa;
output [23:0]out_mant;
//wire [23:0]out_mant;
	assign mantissa[23:0]=mant[23:0];
	assign mantissa[31:24]=8'b0;

	barrellft16 b0(mantissa,res[4],res[1],res[2],res[3],res[0],mantissa_temp);
	assign out_mant[23:0]=mantissa_temp[23:0];
//modinput2_dff dbfjd(out_mant,q,clk);
endmodule

module modinput2_dff (out_mant,q,clk);
   input [23:0]out_mant;
   input clk;
   output reg [23:0]q;
   wire clk;
  
   always @ (posedge clk)
   begin
    q <= out_mant;
    
 end
endmodule


module modinput (x_temp,outcarry,x_temp1);
input [7:0]x_temp;
output outcarry;
output reg [7:0]x_temp1;
wire [7:0]exp1;
//output [7:0]q1;
//output q;
cla8 c000(c111,exp1,x_temp,00000001,0);//for final ops

always@*
begin
	if(outcarry==1'b1)
	begin 
	 x_temp1<=exp1;
	end
	else
	begin
	 x_temp1<=x_temp;
	end
end
//modinput_dff df0000(outcarry,x_temp1,q,q1,clk);
endmodule

module modinput_dff ( outcarry,x_temp1,q,q1,clk);
   input outcarry;
   input [7:0]x_temp1;
   input clk;
   output reg q;
   output  reg [7:0] q1;
   wire clk;
  
   always @ (posedge clk)
   begin
    q <= outcarry;
    q1 <=x_temp1;
    
 end
endmodule

//mod(maaa,mbbb,sa,sb,opcode,elg,sum,outcarry,signbit,out1,out2,clk)
module modinp (maaa,mbbb,sa,sb,opcode,elg,out1,out2,sum,signbit,outcarry);
input [31:0]maaa,mbbb;
input sa,sb,opcode;
input [1:0]elg;
output [23:0]out1,out2,sum;
output signbit;
output outcarry;

//output [23:0]q,q1,q2;
//output q3,q4;
assign out1[23:0]=maaa[31:8];
assign out2[23:0]=mbbb[31:8]; 

comb n1(sa,sb,opcode,out1,out2,elg,sum,outcarry,signbit);
//modinp_dff  dffffff(out1,out2,sum,signbit,outcarry,q,q1,q2,q3,q4,clk);
endmodule


module modinp_dff ( out1,out2,sum,signbit,outcarry,q,q1,q2,q3,q4,clk);
   input [23:0]out1,out2,sum;
   input signbit,outcarry;
   //input [63:0]c;
   input clk;
   output reg[23:0]q,q1,q2;
   output  reg q3,q4;
   wire clk;
  
   always @ (posedge clk)
   begin
    q <= out1;
    q1 <=out2;
    q2<= sum;
    q3 <= signbit;
	q4<=outcarry;
    //q63 <= c;
 end
endmodule
module comb(sa,sb,opcode,out1,out2,elg,sum,cout,signbit);

input sa,sb,opcode;
input [1:0]elg;
input [23:0]out1,out2;
output [23:0]sum;
output cout,signbit;
reg [31:0]sum_temp;
reg carry_temp,sign_temp;
wire [31:0]s1,s2,s3,s4,s5,s6;
wire c1,c2,c3,c4,c5,c6;
wire [31:0]macomb,mbcomb;
wire [31:0]sum_temp1;

reg [31:0]x1;
wire temppp;


assign macomb[31:24]=7'b0;
assign macomb[23:0]=out1[23:0];

assign mbcomb[31:24]=7'b0;
assign mbcomb[23:0]=out2[23:0];


cla32 c11(temppp,s1,macomb,mbcomb,0);//1
assign c1=s1[24];
cla32 c12(temppp,s2,macomb,~mbcomb,1);//2
assign c2=s2[24];
cla32 c13(temppp,s4,macomb,mbcomb,0);//4
assign c4=s4[24];
cla32 c14(temppp,s5,~macomb,mbcomb,1);//5
assign c5=s5[24];
cla32 c15(temppp,s3,~s5,1,0);//3
assign c3=s3[24];

always@(*)
begin
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

//`include "pri_enc.v"
//
module pri_enc32(d,out,A);

	input [31:0]d;
	output [4:0]out;
	output A;
	//output [4:0]q;
	//output q1;
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

//pri_enc_dff dfppp(out ,A,q,q1,clk);
endmodule

module pri_enc_dff ( out ,A,q,q1,clk);
   input [4:0]out;
   input A;
   input clk;
   output reg[4:0]q;
   output  reg q1;
   wire clk;
  
   always @ (posedge clk)
   begin
    q <= out;
    q1 <=A;
 
 end
endmodule

module new(r,cout,x1,x2,x11,elg);

input [4:0]r;
input cout;
input [31:0]x1,x2;
output reg [31:0]x11;
output reg [1:0]elg;
//output  [31:0]q;
//output  [1:0]q1;
//reg [31:0]ma;

always@(*)
begin
 if(cout==1'b1)
 begin
 x11<=x2;
 elg<=2'b10;
 end
 if(cout==1'b0 && r!=7'b0)
 begin
  x11<=x1;
  elg<=2'b01;
 end
 if(cout==1'b0 && r==7'b0)
 begin
   x11<=32'b0;
   elg<=2'b00;
 end
end

//new_dff dff5(x11,elg,clk,q,q1);


endmodule

module new_dff ( a,b, clk, q,q1);
   input [31:0]a;
   input [1:0]b;
   input clk;
   output reg [31:0]q;
   output  reg [1:0]q1;	
   wire clk;
   always @ (posedge clk)
   begin
    q <= a;
    q1 <=b;
 end

endmodule


module sub(a,b,r,cout);
input [7:0]a,b;
 output reg[7:0]r;
 output reg cout;
//output [7:0]q;
//output q1;
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
//  sub_dff dffff1(r,cout,clk,q,q1);
endmodule

module sub_dff ( a,b, clk, q,q1);
   input [7:0]a;
   input b;
   input clk;
   output reg [7:0]q;
   output  reg q1;	
   wire clk;
   always @ (posedge clk)
   begin
    q <= a;
    q1 <=b;
 end

endmodule




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



module barrellft16(a,s0,s1,s2,s3,s4,o4);
input [31:0]a;
input s0,s1,s2,s3,s4;
output [31:0]o4;
wire [31:0]o,o1,o2,o3;
wire ns0,ns1,ns2,ns3,ns4;
assign ns0=~s0;
assign ns1=~s1;
assign ns2=~s2;

assign ns3=~s3;
assign ns4=~s4;
//mux2 m33(a[31],a[32],ns0,o[32]);
mux2 m32(a[30],a[31],ns0,o[31]);
mux2 m31(a[29],a[30],ns0,o[30]);
mux2 m30(a[28],a[29],ns0,o[29]);
mux2 m29(a[27],a[28],ns0,o[28]);
mux2 m28(a[26],a[27],ns0,o[27]);
mux2 m27(a[25],a[26],ns0,o[26]);
mux2 m26(a[24],a[25],ns0,o[25]);
mux2 m25(a[23],a[24],ns0,o[24]);
mux2 m24(a[22],a[23],ns0,o[23]);
mux2 m23(a[21],a[22],ns0,o[22]);
mux2 m22(a[20],a[21],ns0,o[21]);
mux2 m21(a[19],a[20],ns0,o[20]);
mux2 m20(a[18],a[19],ns0,o[19]);
mux2 m19(a[17],a[18],ns0,o[18]);
mux2 m18(a[16],a[17],ns0,o[17]);
mux2 m17(a[15],a[16],ns0,o[16]);
mux2 m16(a[14],a[15],ns0,o[15]);
mux2 m1(a[13],a[14],ns0,o[14]);
mux2 m2(a[12],a[13],ns0,o[13]);
mux2 m3(a[11],a[12],ns0,o[12]);
mux2 m4(a[10],a[11],ns0,o[11]);
mux2 m5(a[9],a[10],ns0,o[10]);
mux2 m6(a[8],a[9],ns0,o[9]);
mux2 m7(a[7],a[8],ns0,o[8]);
mux2 m8(a[6],a[7],ns0,o[7]);
mux2 m9(a[5],a[6],ns0,o[6]);
mux2 m10(a[4],a[5],ns0,o[5]);
mux2 m11(a[3],a[4],ns0,o[4]);
mux2 m12(a[2],a[3],ns0,o[3]);
mux2 m13(a[1],a[2],ns0,o[2]);
mux2 m14(a[0],a[1],ns0,o[1]);
mux2 m15(0,a[0],ns0,o[0]);



//mux2 m33(0[30],a[32],ns0,o[32]);
mux2 M32(o[29],a[31],ns1,o1[31]);
mux2 M31(o[28],a[30],ns1,o1[30]);
mux2 M30(o[27],a[29],ns1,o1[29]);
mux2 M29(o[26],a[28],ns1,o1[28]);
mux2 M28(o[25],a[27],ns1,o1[27]);
mux2 M27(o[24],a[26],ns1,o1[26]);
mux2 M26(o[23],a[25],ns1,o1[25]);
mux2 M25(o[22],a[24],ns1,o1[24]);
mux2 M24(o[21],a[23],ns1,o1[23]);
mux2 M23(o[20],a[22],ns1,o1[22]);
mux2 M22(o[19],a[21],ns1,o1[21]);
mux2 M21(o[18],a[20],ns1,o1[20]);
mux2 M20(o[17],a[19],ns1,o1[19]);
mux2 M19(o[16],a[18],ns1,o1[18]);
mux2 M18(o[15],a[17],ns1,o1[17]);
mux2 M17(o[14],a[16],ns1,o1[16]);
mux2 M16(o[13],a[15],ns1,o1[15]);
mux2 M1(o[12],a[14],ns1,o1[14]);
mux2 M2(o[11],a[13],ns1,o1[13]);
mux2 M3(o[10],a[12],ns1,o1[12]);
mux2 M4(o[9],a[11],ns1,o1[11]);
mux2 M5(o[8],a[10],ns1,o1[10]);
mux2 M6(o[7],a[9],ns1,o1[9]);
mux2 M7(o[6],a[8],ns1,o1[8]);
mux2 M8(o[5],a[7],ns1,o1[7]);
mux2 M9(o[4],a[6],ns1,o1[6]);
mux2 M10(o[3],a[5],ns1,o1[5]);
mux2 M11(o[2],a[4],ns1,o1[4]);
mux2 M12(o[1],a[3],ns1,o1[3]);
mux2 M13(o[0],a[2],ns1,o1[2]);
mux2 M14(0,a[1],ns1,o1[1]);
mux2 M15(0,a[0],ns1,o1[0]);


mux2 R32(o1[27],o1[31],ns2,o2[31]);
mux2 R31(o1[26],o1[30],ns2,o2[30]);
mux2 R30(o1[25],o1[29],ns2,o2[29]);
mux2 R29(o1[24],o1[28],ns2,o2[28]);
mux2 R28(o1[23],o1[27],ns2,o2[27]);
mux2 R27(o1[22],o1[26],ns2,o2[26]);
mux2 R26(o1[21],o1[25],ns2,o2[25]);
mux2 R25(o1[20],o1[24],ns2,o2[24]);
mux2 R24(o1[19],o1[23],ns2,o2[23]);
mux2 R23(o1[18],o1[22],ns2,o2[22]);
mux2 R22(o1[17],o1[21],ns2,o2[21]);
mux2 R21(o1[16],o1[20],ns2,o2[20]);
mux2 R20(o1[15],o1[19],ns2,o2[19]);
mux2 R19(o1[14],o1[18],ns2,o2[18]);
mux2 R18(o1[13],o1[17],ns2,o2[17]);
mux2 R17(o1[12],o1[16],ns2,o2[16]);
mux2 R16(o1[11],o1[15],ns2,o2[15]);
mux2 R1(o1[10],o1[14],ns2,o2[14]);
mux2 R2(o1[9],o1[13],ns2,o2[13]);
mux2 R3(o1[8],o1[12],ns2,o2[12]);
mux2 R4(o1[7],o1[11],ns2,o2[11]);
mux2 R5(o1[6],o1[10],ns2,o2[10]);
mux2 R6(o1[5],o1[9],ns2,o2[9]);
mux2 R7(o1[4],o1[8],ns2,o2[8]);
mux2 R8(o1[3],o1[7],ns2,o2[7]);
mux2 R9(o1[2],o1[6],ns2,o2[6]);
mux2 R10(o1[1],o1[5],ns2,o2[5]);
mux2 R11(o1[0],o1[4],ns2,o2[4]);
mux2 R12(0,o1[3],ns2,o2[3]);
mux2 R13(0,o1[2],ns2,o2[2]);
mux2 R14(0,o1[1],ns2,o2[1]);
mux2 R15(0,o1[0],ns2,o2[0]);



mux2 S32(o2[23],o2[31],ns3,o3[31]);
mux2 S31(o2[22],o2[30],ns3,o3[30]);
mux2 S30(o2[21],o2[29],ns3,o3[29]);
mux2 S29(o2[20],o2[28],ns3,o3[28]);
mux2 S28(o2[19],o2[27],ns3,o3[27]);
mux2 S27(o2[18],o2[26],ns3,o3[26]);
mux2 S26(o2[17],o2[25],ns3,o3[25]);
mux2 S25(o2[16],o2[24],ns3,o3[24]);
mux2 S24(o2[15],o2[23],ns3,o3[23]);
mux2 S23(o2[14],o2[22],ns3,o3[22]);
mux2 S22(o2[13],o2[21],ns3,o3[21]);
mux2 S21(o2[12],o2[20],ns3,o3[20]);
mux2 S20(o2[11],o2[19],ns3,o3[19]);
mux2 S19(o2[10],o2[18],ns3,o3[18]);
mux2 S18(o2[9],o2[17],ns3,o3[17]);
mux2 S17(o2[8],o2[16],ns3,o3[16]);
mux2 S16(o2[7],o2[15],ns3,o3[15]);
mux2 S1(o2[6],o2[14],ns3,o3[14]);
mux2 S2(o2[5],o2[13],ns3,o3[13]);
mux2 S3(o2[4],o2[12],ns3,o3[12]);
mux2 S4(o2[3],o2[11],ns3,o3[11]);
mux2 S5(o2[2],o2[10],ns3,o3[10]);
mux2 S6(o2[1],o2[9],ns3,o3[9]);
mux2 S7(o2[0],o2[8],ns3,o3[8]);
mux2 S8(0,o2[7],ns3,o3[7]);
mux2 S9(0,o2[6],ns3,o3[6]);
mux2 S10(0,o2[5],ns3,o3[5]);
mux2 S11(0,o2[4],ns3,o3[4]);
mux2 S12(0,o2[3],ns3,o3[3]);
mux2 S13(0,o2[2],ns3,o3[2]);
mux2 S14(0,o2[1],ns3,o3[1]);
mux2 S15(0,o2[0],ns3,o3[0]);


mux2 L32(o3[15],o3[31],ns4,o4[31]);
mux2 L31(o3[14],o3[30],ns4,o4[30]);
mux2 L30(o3[13],o3[29],ns4,o4[29]);
mux2 L29(o3[12],o3[28],ns4,o4[28]);
mux2 L28(o3[11],o3[27],ns4,o4[27]);
mux2 L27(o3[10],o3[26],ns4,o4[26]);
mux2 L26(o3[9],o3[25],ns4,o4[25]);
mux2 L25(o3[8],o3[24],ns4,o4[24]);
mux2 L24(o3[7],o3[23],ns4,o4[23]);
mux2 L23(o3[6],o3[22],ns4,o4[22]);
mux2 L22(o3[5],o3[21],ns4,o4[21]);
mux2 L21(o3[4],o3[20],ns4,o4[20]);
mux2 L20(o3[3],o3[19],ns4,o4[19]);
mux2 L19(o3[2],o3[18],ns4,o4[18]);
mux2 L18(o3[1],o3[17],ns4,o4[17]);
mux2 L17(o3[0],o3[16],ns4,o4[16]);
mux2 L16(0,o3[15],ns4,o4[15]);
mux2 L1(0,o3[14],ns4,o4[14]);
mux2 L2(0,o3[13],ns4,o4[13]);
mux2 L3(0,o3[12],ns4,o4[12]);
mux2 L4(0,o3[11],ns4,o4[11]);
mux2 L5(0,o3[10],ns4,o4[10]);
mux2 L6(0,o3[9],ns4,o4[9]);
mux2 L7(0,o3[8],ns4,o4[8]);
mux2 L8(0,o3[7],ns4,o4[7]);
mux2 L9(0,o3[6],ns4,o4[6]);
mux2 L10(0,o3[5],ns4,o4[5]);
mux2 L11(0,o3[4],ns4,o4[4]);
mux2 L12(0,o3[3],ns4,o4[3]);
mux2 L13(0,o3[2],ns4,o4[2]);
mux2 L14(0,o3[1],ns4,o4[1]);
mux2 L15(0,o3[0],ns4,o4[0]);

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
output [31:0]b;
wire [37:0]w;
wire [31:0]g;
wire [31:0]m,p;
//wire [31:0]q;
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
//shiftright_dff s0(b,clk,q);
endmodule

module shiftright_dff ( a, clk, q);
   input [31:0]a;
   input clk;
   output reg [31:0]q;
   wire clk;
   always @ (posedge clk)
   begin
    q <= a;
 end
endmodule




module cla32(cout,sum,a,b,cin);
input [31:0]a,b;
input cin;
           output [31:0]sum;
output cout;
	   
           wire [31:0]p,g;
	 
	wire [31:0]c;
	//wire [31:0]w;
              
          assign p=a^b;
          assign g=a&b;

assign c[0]=cin;
assign c[1]=g[0]|(p[0]&cin);
assign c[2]=g[1]|(p[1]&(g[0]|(p[0]&cin)));
assign c[3]=g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))));
assign c[4]=g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))));
assign c[5]=g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))));

assign c[6]=g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))));

assign c[7]=g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))));

assign c[8]=g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))));

assign c[9]=g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))));

assign c[10]=g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))));

assign c[11]=g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))));

assign c[12]=g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))));

assign c[13]=g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))));

assign c[14]=g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))));

assign c[15]=g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))));

assign c[16]=g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))));

assign c[17]=g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))));

assign c[18]=g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))));

assign c[19]=g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))));

assign c[20]=g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))));

assign c[21]=g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))));

assign c[22]=g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))));

assign c[23]=g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))));

assign c[24]=g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))));

assign c[25]=g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))));

assign c[26]=g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[27]=g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[28]=g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[29]=g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[30]=g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))))));

assign c[31]=g[30]|(p[30]&(g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));





//assign temp1=g[31]|(p[31]&(g[30]|(p[30]&(g[29]|(p[29]&(g[28]|(p[28]&(g[27]|(p[27]&(g[26]|(p[26]&(g[25]|(p[25]&(g[24]|(p[24]&(g[23]|(p[23]&(g[22]|(p[22]&(g[21]|(p[21]&(g[20]|(p[20]&(g[19]|(p[19]&(g[18]|(p[18]&(g[17]|(p[17]&(g[16]|(p[16]&(g[15]|(p[15]&(g[14]|(p[14]&(g[13]|(p[13]&(g[12]|(p[12]&(g[11]|(p[11]&(g[10]|(p[10]&(g[9]|(p[9]&(g[8]|(p[8]&(g[7]|(p[7]&(g[6]|(p[6]&(g[5]|(p[5]&(g[4]|(p[4]&(g[3]|(p[3]&(g[2]|(p[2]&(g[1]|(p[1]&(g[0]|(p[0]&cin)))))))))))))))))))))))))))))))))))))))))))))))))))))))))))))));
	  
          assign sum=a^b^c;
          assign cout=c[31];
	  

endmodule


