`include"subtractor.v"
module maintb();
/*input sa,sb,opcode;
input [22:0]ma,mb;
input [7:0]ea,eb;
output sign;
output [22:0]mant;
output [7:0]exp;
*/
reg sa,sb,opcode;
reg [22:0]ma,mb;
reg [7:0]ea,eb;
wire sign;
wire [22:0]mant;
wire [7:0]exp;

main  m00(sa,sb,opcode,ma,mb,ea,eb,sign,mant,exp);
initial
begin
sa=1'b0;
sb=1'b0;
opcode=1'b0;
ma=23'b10000000000000000000000;
mb=23'b01000000000000000000000;
ea=8'b00000001;
eb=8'b00000010;



$monitor("sa=%b , sb=%b, opcode=%b,ma=%b, mb=%b,ea=%d,eb=%d,sign =%b,exp=%d,mant=%b",sa,sb,opcode,ma,mb,ea,eb,sign,exp,mant);
end 
endmodule

