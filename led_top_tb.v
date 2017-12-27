`timescale 1ns/1ns
`define clk_period 20

module led_top_tb;

reg clk;
reg rst_n;
reg key;

wire [3:0] led;

parameter time_down = 32'd500_000_000;

led_top led_top(
               .clk(clk),
               .rst_n(rst_n),
               .key(key),
               .led(led)               
                 ); 
                 
initial clk=1'b1;
always#(`clk_period/2) clk=~clk;

initial begin
		rst_n = 0;
		key = 1;
		#(`clk_period*20)
		rst_n = 1;
		#(`clk_period*100)
		
		press_n;
		#(`clk_period);
		press_p;
		@(posedge led_top.led_flash.flash_done)
	
		press_n;
		#(time_down*2);
		#(`clk_period);
		press_p;
		@(posedge led_top.led_flash.flash_done)

		press_n;
		#(time_down*4);
		#(`clk_period);
		press_p;
		@(posedge led_top.led_flash.flash_done)

		
		#1000;
		$stop;
	end 
reg [15:0] myrand;
task press_n;
    begin
    	   repeat(50)
    	         begin
    	         	    myrand = {$random}%65535;
    	         	    #myrand key = ~key;
    	         end
    	            key = 1'b0;
    	            #500_000_000;    	                	    	
    end
                 
endtask

task press_p;
    begin
    	   repeat(50)
    	         begin
    	         	    myrand = {$random}%65535;
    	         	    #myrand key = ~key;
    	         	    key = 1'b1;
    	         	    #20;
    	         end    	    	
    end
endtask    

endmodule







    
                 
                 