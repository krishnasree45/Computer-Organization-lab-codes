module mux2(a,b,s,r);
input a,b,s;
output r;
wire w1,w2,w3;
assign w1=~s;
assign w2=w1&a;
assign w3=b&s;
assign r=w2|w3;
endmodule

