/***********************************************
Module Name:   CORDIC_sqrt_test
Feature:       Testbench for CORDIC (mode 3)
               An example for the GEM Projects
Coder:         Garfield
Organization:  XXXX Group, Department of Architecture
------------------------------------------------------
Variables:
         clk: clock for processing
         reset: reset flag
------------------------------------------------------
History:
06-27-2016: First Version by Garfield
***********************************************/
`timescale 10 ns/100 ps
//Simulation time assignment
`define MODE 3
`define LENGTH 65536
`define WIDTH 16 + 7
`define ORDER 12
`define CNTR_WIDTH 16


//Insert the modules
module CORDIC_sqrt_test;

//defination for Variables
reg clk;
reg reset;

reg[`CNTR_WIDTH - 1:0] cntr;
//loop for test vectors

reg signed[(`WIDTH-2):0] test_vector_a[(`LENGTH-1):0];
reg signed[(`WIDTH-2):0] test_vector_b[(`LENGTH-1):0];
reg signed[(`WIDTH-2):0] test_vector_sqrt[(`LENGTH-1):0];
//Test Vector Value

wire signed[(`WIDTH-1):0] sqrt_value;
//middle signals

wire signed[(`WIDTH-1):0] sqrt_adj;
wire signed[(`WIDTH-1):0] comp_sqrt;
//Results right? Comparision results

wire[(`WIDTH*2 + 14 -1):0] op;
wire[(`WIDTH*2 + 14 -1):0] res;
wire signed[(`WIDTH-1):0] res_sqrt;


wire [`CNTR_WIDTH - 1:0] index;

assign res_sqrt = res[`WIDTH - 1 + 7: 0];

assign op = { test_vector_a[cntr], test_vector_b[cntr]};

assign index = (cntr - 1 - `ORDER) % `LENGTH;

assign sqrt_value = test_vector_sqrt[index];

assign sqrt_adj = res_sqrt;

assign comp_sqrt = sqrt_value - sqrt_adj;

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
      $readmemh("a_test_vector.txt", test_vector_a);
      $readmemh("b_test_vector.txt", test_vector_b);
      $readmemh("sqrt_test_vector.txt", test_vector_sqrt);
    end
    
//Load the input of 0 order element
    
//Comparision
    always @(posedge clk or negedge reset)
    begin
        if ( !reset)
        //reset statement: counter keeps at 0
        begin
            cntr <= `CNTR_WIDTH'h00;
        end
        else
        begin
            cntr <= cntr + `CNTR_WIDTH'h01;
        end
    end
        
endmodule