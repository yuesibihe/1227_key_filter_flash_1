module led_flash(
                 clk,
                 rst_n,
                 mode,
                 times,
                 en,
                 flash_done,
                 led
                 );
                 
input clk;
input rst_n;
input mode;
input [5:0] times;
input en;

output reg flash_done;
output reg [3:0] led;

reg [23:0] cnt;
reg [5:0]  cnt_flash;
reg en_cnt;

parameter cnt_max = 24'd9_999_999;

always@(posedge clk or negedge rst_n)
      begin
      	   if(!rst_n)
      	    begin
      	    	   cnt <= 24'd0;
      	    end
      	   else if(en_cnt)
      	          begin
      	          	   if(cnt==cnt_max)
      	          	    begin
      	          	    	   cnt <= 24'd0;  	          	    	
      	          	    end
      	          	    else
      	          	        begin
      	          	        	   cnt <= cnt + 1'b1;
      	          	        end      	          	      	          	
      	          end
      	   else 
      	       begin
      	       	    cnt <= 24'd0;
      	       end      	      	
      end         
      
always@(posedge clk or negedge rst_n)
      begin
      	   if(!rst_n)
      	     begin
      	     	    led <= 4'b1111;
      	     end
      	   else if(!mode)
      	          begin
      	          	   if(cnt == cnt_max)
      	          	     begin
      	          	     	    led[0] <= ~ led[0];      	          	     	           	          	     	
      	          	     end  
      	          	   else
      	          	       begin
      	          	       	    led[0] <= led[0];
      	          	       end
      	          end
      	   else
      	       begin
      	       	    if(cnt==cnt_max)
      	       	      begin
      	       	      	   led <= ~led;
      	       	      end
      	       	    else
      	       	        begin
      	       	        	   led <= led;
      	       	        end      	       	      	       	
      	       end      	             	
      end         

always@(posedge clk or negedge rst_n)
      begin
      	   if(!rst_n)
      	     begin
      	     	    flash_done <= 1'd0;
      	     	    en_cnt <= 1'd0;
      	     end
      	   else if(en)
      	         begin
      	              if(cnt_flash < times*2)
      	                begin
      	                	   en_cnt <= 1'b1;
      	                end
      	              else
      	                  begin
      	                  	   flash_done <= 1'b1;
      	                  	   en_cnt <= 1'b0;      	                  	
      	                  end
      	         end
      	   else 
      	       begin
      	       	    flash_done <= 1'b0;
      	       	    en_cnt <= 1'b0;
      	       end      	
      end         
      
always@(posedge clk or negedge rst_n)      
      begin
      	  if(!rst_n)
      	    begin
      	    	   cnt_flash <= 1'b0;      	    	
      	    end
      	  else if(en)
      	         begin
      	         	   if(cnt == cnt_max)
      	         	     cnt_flash <= cnt_flash + 1'b1;
      	         	   else
      	         	     cnt_flash <= cnt_flash ;
      	         end
      	  else
      	      cnt_flash <= 1'b0;      	  
      end 

endmodule 