module dff1 (s,cout,clk,q3,cout1);
   input s,clk,cout;
   output q3,cout1;
   wire clk;
   reg q3,cout1;
     	 
   always @ (posedge clk)
   begin
    q3 <= s;
    cout1 <= cout;
   
 end

endmodule
