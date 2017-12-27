module led_FSM(
               clk,
               rst_n,
               key_flag,
               key_state,
               flash_done,
               times,
               mode,
               en
                );
                
input clk;
input rst_n;
input key_flag;
input key_state;

input flash_done;

output reg[5:0] times;
output reg mode;
output reg en;

reg en_cnt;

wire nedge,pedge;

assign nedge = key_flag && !key_state;
assign pedge = key_flag && key_state ;

reg [2:0] state;
reg [29:0] cnt;

always@(posedge clk or negedge rst_n)
      begin
      	   if(!rst_n)
      	     begin
      	     	    state <= 1'b0;
      	     	    en_cnt <= 1'b0;
      	     end
      	   else
      	       begin
                    case(state)
                    	  0:begin
                    	         if(nedge)
                    	           begin
                    	           	    state <= 1'b1;
                    	           	    en_cnt <= 1'b1;
                    	           end	
                    	          else
                    	              begin
                    	              	  state <= 1'b0;
                    	              	  en_cnt <= 1'b0;                    	              	
                    	              end
                    	    end
                    	    
                    	  1:begin
                    	  	     if(pedge)
                    	  	       begin
                    	  	       	    en_cnt <= 1'b0;
                    	  	       	    if(cnt < 50_000_000)
                    	  	       	      begin
                    	  	       	      	  state <= 2'd2;                    	  	       	      	  
                    	  	       	      end
                    	  	       	    else if(cnt >= 50_000_000 && cnt<100_000_000)  
                    	  	       	           begin
                    	  	       	           	    state <= 3'd3;
                    	  	       	           end                
                    	  	       	    else
                    	  	       	        begin
                    	  	       	        	   state <= 3'd4;
                    	  	       	        end  	  	       	   
                    	  	       end
                    	  	      else
                    	  	          begin
                    	  	          	   state <= 3'd1;
                    	  	          	   en_cnt <= 3'd1;
                    	  	          end                    	  	                    	  	                    	    
                    	    end 
                    	  2:begin
                    	  	     if(flash_done)
                    	  	       begin
                    	  	       	   en<=2'd0;
                    	  	       	   state <= 2'd0;                    	  	       	
                    	  	       end
                    	  	     else
                    	  	         begin
                    	  	         	    en<=2'd1;
                    	  	         	    state <= 3'd2;
                    	  	         	    mode <= 3'd0;
                    	  	         	    times <= 5'd5;
                    	  	         end                    	  	                    	  	
                    	     end 
                    	  3:begin
                    	  	     if(flash_done)
                    	  	       begin
                    	  	           en <= 3'd0;
                    	  	           state <= 3'd0; 	
                    	  	       end
                    	  	     else
                    	  	         begin
                    	  	         	    en<=3'd1;
                    	  	         	    state <= 3'd3;
                    	  	         	    mode <= 3'd0;
                    	  	         	    times <= 10'd10;                    	  	         	                        	  	         	
                    	  	         end                    	  	                    	  	
                    	    end         
                    	  4:begin
                    	  	     if(flash_done)
                    	  	      begin
                    	  	      	  en <= 3'd0;
                    	  	      	  state <= 3'd0;                    	  	      	                     	  	      	
                    	  	      end
                    	  	     else
                    	  	        begin
                    	  	        	  en <= 3'd1;
                    	  	        	  state <= 3'd4;
                    	  	        	  mode <= 3'd1;
                    	  	        	  times <= 20'd20;                    	  	        	                      	  	        	
                    	  	        end
                    	    end
                    	  default:begin
                    	  	      state <= 1'd0;                          	  	
                    	  	      end                    	                        	    	                    	                             	          	       	           
      	       	    endcase
      	       end            	
      end

always@(posedge clk or negedge rst_n)
      begin
      	   if(!rst_n)
      	    begin
      	    	  cnt <= 30'd0;      	    	  
      	    end
      	   else if(en_cnt)
      	          begin
      	               cnt <= cnt + 1'b1;
                  end
           else
               begin
               	    cnt <= 30'd0;
               end      	                	         	      	
      end      
      
endmodule                