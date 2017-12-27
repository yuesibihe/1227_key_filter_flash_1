module led_top(
                clk,
                rst_n,
                key,
                led
                 );

input clk;
input rst_n;
input key;

wire key_flag1;
wire flash_done;
wire [5:0]times;
wire en;

output [3:0]led;

key_filter key_filter1(
                      .clk(clk),
                      .rst_n(rst_n),
                      .key_in(key),
                      .key_flag(key_flag1),
                      .key_state(key_state1)               
                       );  
                       
led_FSM  led_FSM (
                  .clk(clk),
                  .rst_n(rst_n),
                  .key_flag(key_flag1),                     
                  .key_state(key_state1),
                  .flash_done(flash_done),
                  .times(times),
                  .mode(mode),
                  .en(en)
                       );          
                       
led_flash led_flash(
                   .clk(clk),
                   .rst_n(rst_n),
                   .mode(mode),
                   .times(times),
                   .en(en),
                   .flash_done(flash_done),
                   .led(led)
                     ); 

endmodule                                                                                              