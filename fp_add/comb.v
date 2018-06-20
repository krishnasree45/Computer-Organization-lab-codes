`include "cla32.v"
`include "shifterright32.v"
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
