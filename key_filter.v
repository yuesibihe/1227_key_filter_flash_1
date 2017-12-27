module key_filter(
                  clk,
                  rst_n,
                  key_in,
                  key_flag,
                  key_state
                   );
                   
   input clk;
   input rst_n;
   input key_in;

   output reg key_flag;
   output reg key_state;

   localparam 
              IDEL = 4'b0001,
              FILTER0 = 4'b0010,
              DOWN = 4'b0100,
              FILTER1 = 4'b1000;
  
   reg[3:0] state;
   reg[19:0] cnt;
   reg en_cnt;
      
   reg key_in_sa,key_in_sb;
   always@(posedge clk or negedge rst_n)
         begin
         	    if(!rst_n)
         	      begin
         	          key_in_sa <= 1'b0;
         	          key_in_sb <= 1'b0;
         	      end
         	      else
         	          begin 
         	          	    key_in_sa <= key_in;
         	          	    key_in_sb <= key_in_sa;
         	          end         	              	
         end                           
   
   reg key_tmpa,key_tmpb;
   wire pedge,nedge;
   reg cnt_full;
   
   always@(posedge clk or negedge rst_n)
         begin
         	    if(!rst_n)
         	      begin
         	      	   key_tmpa <= 4'b0;
         	      	   key_tmpb <= 4'b0;         	      	   
         	      end
         	     else 
         	         begin
         	         	    key_tmpa <= key_in_sb;
         	         	    key_tmpb <= key_tmpa ;
         	         end
         	
         end     
   assign  nedge = !key_tmpa & key_tmpb ;
   assign  pedge = key_tmpa & (!key_tmpb); 
   
   always@(posedge clk or negedge rst_n)
         begin
           	   if(!rst_n)
           	     begin
           	     	    en_cnt <= 1'b0;
           	     	    state <= IDEL;
           	     	    key_flag <= 1'b0;
           	     	    key_state <= 1'b1;
           	     end
         	     else
         	         begin
         	         	    case(state)
         	         	    	 IDEL:
         	         	    	      begin
         	         	    	      	   key_flag <= 1'b0;
         	         	    	      	   if(nedge)
         	         	    	      	    begin
         	         	    	      	    	   state <= FILTER0;
         	         	    	      	    	   en_cnt <= 1'b1;
         	         	    	      	    end
         	         	    	      	    else
         	         	    	      	        state <= IDEL;
         	         	    	      end
         	         	    	 FILTER0:
         	         	    	        begin
         	         	    	        	   if(cnt_full)
         	         	    	        	    begin
         	         	    	        	    	   key_flag <= 1'b1;
         	         	    	        	    	   key_state <= 1'b0;
         	         	    	        	    	   en_cnt <= 1'b0;
         	         	    	        	    	   state <= DOWN;
         	         	    	        	    end
         	         	    	        	    else
         	         	    	        	         state <= FILTER0;         	         	    	        	
         	         	    	        end
         	         	    	 DOWN:
         	         	    	      begin
         	         	    	      	   key_flag <= 1'b0;
         	         	    	      	   if(pedge)
         	         	    	      	     begin
         	         	    	      	     	    state <= FILTER1 ;
         	         	    	      	     	    en_cnt <= 1'b1;
         	         	    	      	     end
         	         	    	      	    else
         	         	    	      	        begin
         	         	    	      	        	   state <= DOWN;         	         	    	      	        	   
         	         	    	      	        end         	         	    	      	                 	         	    	     
         	         	    	      end
         	         	    	 FILTER1:
         	         	    	         begin
         	         	    	         	    if(cnt_full)
         	         	    	         	      begin
         	         	    	         	      	   key_flag <= 1'b1;
         	         	    	         	      	   key_state <= 1'b1;
         	         	    	         	      	   en_cnt <= 1'b0;
         	         	    	         	      	   state <= IDEL;
         	         	    	         	      end
         	         	    	         	    else if(nedge)
         	         	    	         	           begin
         	         	    	         	           	    en_cnt <= 1'b0;
         	         	    	         	           	    state <= DOWN;         	         	    	         	           	    
         	         	    	         	           end
         	         	    	         	    else
         	         	    	         	        begin
         	         	    	         	        	   state <= FILTER1;
         	         	    	         	        end
         	         	    	         end
         	         	    	 default:
         	         	    	         begin
         	         	    	         	    state <= IDEL;
         	         	    	         	    en_cnt <= 1'b0;
         	         	    	         	    key_flag <= 1'b0;
         	         	    	         	    key_state <= 1'b1;         	         	    	         	
         	         	    	         end
         	         	    endcase
         	         end
         	
         end 
         
    always@(posedge clk or negedge rst_n)     
         begin
         	    if(!rst_n)
         	      begin
         	      	  cnt <= 20'd0;
         	      end
         	    else if(en_cnt)
         	           cnt <= cnt + 1'b1;
         	    else
         	        begin
         	        	   cnt <= 20'd0;
         	        end         	         	         	         	
         end
         
   always@(posedge clk or negedge rst_n)
         begin
         	    if(!rst_n)
         	     begin
         	     	   cnt_full <= 1'b0;
         	     end
         	    else if(cnt == 999_999)
         	           begin
         	           	    cnt_full <= 1'b1;
         	           end
         	    else 
         	         cnt_full <= 1'b0;
         end      
         
         
endmodule
         