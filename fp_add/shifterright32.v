`include "mux2.v"
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
