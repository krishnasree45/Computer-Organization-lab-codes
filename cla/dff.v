module dff(q,d,clock,reset);
input clock, d, reset;
output q;
//reg q, qb;

wire w2, w2b, w1, w1b,qb;

assign w2 = w1b ~& w2b;
assign w2b = (clock ~& w2) ~& reset;

assign w1 = (w2b ~& clock) ~& w1b;
assign w1b = (w1 ~& d) ~& reset;

assign q = w2b ~& qb;
assign qb = reset ~& (w1 ~& q);


endmodule
