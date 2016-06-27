/***********************************************
Module Name:   CORDIC_sin_cos_test
Feature:       Testbench for CORDIC (mode 1)
               An example for the GEM Projects
Coder:         Garfield
Organization:  XXXX Group, Department of Architecture
------------------------------------------------------
Variables:
         clk: clock for processing
         reset: reset flag
------------------------------------------------------
History:
06-21-2016: First Version by Garfield
***********************************************/
`timescale 10 ns/100 ps
//Simulation time assignment
`define MODE 1
`define LENGTH 256
`define WIDTH 15
`define ORDER 12


//Insert the modules
module CORDIC_sin_cos_test;

//defination for Variables
reg clk;
reg reset;

reg[7:0] cntr;
//loop for test vectors

reg signed[(`WIDTH-1):0] test_vector_w[(`LENGTH-1):0];
reg signed[(`WIDTH-1):0] test_vector_sin[(`LENGTH-1):0];
reg signed[(`WIDTH-1):0] test_vector_cos[(`LENGTH-1):0];
//Test Vector Value

wire signed[(`WIDTH-1):0] cos_value;
wire signed[(`WIDTH-1):0] sin_value;
//middle signals

wire signed[(`WIDTH-1):0] comp_sin;
wire signed[(`WIDTH-1):0] comp_cos;
//Results right? Comparision results

wire[(`WIDTH*2-1):0] op;
wire[(`WIDTH*2-1):0] res;
wire signed[(`WIDTH-1):0] res_sin;
wire signed[(`WIDTH-1):0] res_cos;

wire [7:0] index;

assign res_sin = res[`WIDTH -1 : 0];
assign res_cos = res[`WIDTH*2  -1 : `WIDTH];

assign op = {{(`WIDTH){1'b0}}, test_vector_w[cntr]};

assign index = (cntr - 1 - `ORDER) % `LENGTH;

assign sin_value = test_vector_sin[index];
assign cos_value = test_vector_cos[index];

assign comp_sin = (res_sin - sin_value);
assign comp_cos = (res_cos - cos_value);
//Connection to the modules
CORDIC #(.MODE(`MODE))
//CORDIC Mode
 C  ( 
    .CLK(clk), .RESET_n(reset),
    .operand(op), .results(res)
   );
//Clock generation
    initial
    begin
      clk = 0;
      //Reset
      forever  
      begin
           #10 clk = !clk;
           //Reverse the clock in each 10ns
      end
    end

//Reset operation
    initial  
    begin
      reset = 0;
      //Reset enable
      #14  reset = 1;
     //Counter starts
    end

//Load the test vectors
    initial  
    begin
      $readmemh("angle_test_vector.txt", test_vector_w);
      $readmemh("sin_test_vector.txt", test_vector_sin);
      $readmemh("cos_test_vector.txt", test_vector_cos);
    end
    
//Load the input of 0 order element
    
//Comparision
    always @(posedge clk or negedge reset)
    begin
        if ( !reset)
        //reset statement: counter keeps at 0
        begin
            cntr <= 8'h00;
        end
        else
        begin
            cntr <= cntr + 8'h01;
        end
    end
        
endmodule