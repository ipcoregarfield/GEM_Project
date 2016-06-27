/***********************************************
Module Name:   CORDIC_atan_test
Feature:       Testbench for CORDIC (mode 2)
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
`define MODE 2
`define LENGTH 256
`define WIDTH 16
`define ORDER 12


//Insert the modules
module CORDIC_atan_test;

//defination for Variables
reg clk;
reg reset;

reg[7:0] cntr;
//loop for test vectors

reg signed[(`WIDTH-1):0] test_vector_tan[(`LENGTH-1):0];
reg signed[(`WIDTH-1):0] test_vector_atan[(`LENGTH-1):0];
//Test Vector Value

wire signed[(`WIDTH-1):0] atan_value;
//middle signals

wire signed[(`WIDTH-1):0] atan_adj;
wire signed[(`WIDTH-1):0] comp_atan;
//Results right? Comparision results

wire[(`WIDTH*2-1):0] op;
wire[(`WIDTH*2-1):0] res;
wire signed[(`WIDTH-1):0] res_atan;


wire [7:0] index;

assign res_atan = res[`WIDTH -1 : 0];

assign op = {{(`WIDTH){1'b0}}, test_vector_tan[cntr]};

assign index = (cntr - 1 - `ORDER) % `LENGTH;

assign atan_value = test_vector_atan[index];

assign atan_adj = res_atan;

assign comp_atan = atan_value - atan_adj;

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
      $readmemh("tan_test_vector.txt", test_vector_tan);
      $readmemh("atan_test_vector.txt", test_vector_atan);
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