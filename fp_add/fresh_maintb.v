`include"fresh_main.v"
module maintb();


reg sa,sb,opcode;
reg [22:0]ma,mb;
reg [7:0]ea,eb;
wire [7:0]exponent,exp;
wire sign,totalcarry;
wire [23:0]mant;
//wire [7:0]exp;

//sa,sb,opcode,ma,mb,ea,eb,out_mant,sign,exponent,totalcarry,res,clk;
main  m00(sa,sb,opcode,ma,mb,ea,eb,mant,sign,exponent,totalcarry);



initial
begin
sa=1'b0;
sb=1'b0;
opcode=1'b0;
ma=23'b10000000000000000000000;
mb=23'b00000000000000000000000;
ea=8'b00000001;
eb=8'b00000001;
$monitor("sa=%b , sb=%b, opcode=%b,ma=%b, mb=%b,ea=%d,eb=%d,mant=%b,sign=%b,exponent=%b,carryout=%b",sa,sb,opcode,ma,mb,ea,eb,mant,sign,exponent,totalcarry);
end
endmodule




