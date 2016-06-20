/***********************************************
Module Name:   CORDIC_Element_test
Feature:       Testbench for CORDIC_Element
               An example for the GEM Projects
Coder:         Garfield
Organization:  XXXX Group, Department of Architecture
------------------------------------------------------
Variables:
         clk: clock for processing
         reset: reset flag
         cntr: counter for the EN and CLRinput 
         
------------------------------------------------------
History:
12-20-2015: First Version by Garfield
***********************************************/
`timescale 10 ns/100 ps
//Simulation time assignment
`define WIDTH 15
//Bit Width
`define ORDER 12

//Insert the modules
module CORDIC_Element_test;

//defination for Variables
reg clk;
reg reset;


reg[(`WIDTH-1):0] test_vector_x[(`ORDER+1):0];
reg[(`WIDTH-1):0] test_vector_y[(`ORDER+1):0];
reg[(`WIDTH-1):0] test_vector_z[(`ORDER+1):0];
//Test Vector Value

wire[(`WIDTH-1):0] x[(`ORDER+1):0];
wire[(`WIDTH-1):0] y[(`ORDER+1):0];
wire[(`WIDTH-1):0] z[(`ORDER+1):0];
//middle signals

reg[(`WIDTH-1):0] comp_x[(`ORDER+1):0];
reg[(`WIDTH-1):0] comp_y[(`ORDER+1):0];
reg[(`WIDTH-1):0] comp_z[(`ORDER+1):0];
//Results right? Comparision results

reg[3:0] loop;

//Connection to the modules
CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h3243), .ORDER(0) )
   CE0   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[0]), .y_k(y[0]), .z_k(z[0]), 
           .x_k1(x[1]), .y_k1(y[1]), .z_k1(z[1])  );
           
CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h1DAC), .ORDER(1) )
   CE1   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[1]), .y_k(y[1]), .z_k(z[1]), 
           .x_k1(x[2]), .y_k1(y[2]), .z_k1(z[2])  );           

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h0FAD), .ORDER(2) )
   CE2   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[2]), .y_k(y[2]), .z_k(z[2]), 
           .x_k1(x[3]), .y_k1(y[3]), .z_k1(z[3])  );

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h07F5), .ORDER(3) )
   CE3   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[3]), .y_k(y[3]), .z_k(z[3]), 
           .x_k1(x[4]), .y_k1(y[4]), .z_k1(z[4])  );

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h03FE), .ORDER(4) )
   CE4   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[4]), .y_k(y[4]), .z_k(z[4]), 
           .x_k1(x[5]), .y_k1(y[5]), .z_k1(z[5])  );

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h01FF), .ORDER(5) )
   CE5   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[5]), .y_k(y[5]), .z_k(z[5]), 
           .x_k1(x[6]), .y_k1(y[6]), .z_k1(z[6])  );


CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h00FF), .ORDER(6) )
   CE6   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[6]), .y_k(y[6]), .z_k(z[6]), 
           .x_k1(x[7]), .y_k1(y[7]), .z_k1(z[7])  );


CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h007F), .ORDER(7) )
   CE7   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[7]), .y_k(y[7]), .z_k(z[7]), 
           .x_k1(x[8]), .y_k1(y[8]), .z_k1(z[8])  );
           
CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h003F), .ORDER(8) )
   CE8   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[8]), .y_k(y[8]), .z_k(z[8]), 
           .x_k1(x[9]), .y_k1(y[9]), .z_k1(z[9])  ); 

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h001F), .ORDER(9) )
   CE9   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[9]), .y_k(y[9]), .z_k(z[9]), 
           .x_k1(x[10]), .y_k1(y[10]), .z_k1(z[10])  );

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h000F), .ORDER(10) )
   CE10   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[10]), .y_k(y[10]), .z_k(z[10]), 
           .x_k1(x[11]), .y_k1(y[11]), .z_k1(z[11])  );

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h0007), .ORDER(11) )
   CE11   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[11]), .y_k(y[11]), .z_k(z[11]), 
           .x_k1(x[12]), .y_k1(y[12]), .z_k1(z[12])  );

CORDIC_elemet #(.ADDRESS_WIDTH(`WIDTH-1), .VALUE_WIDTH(`WIDTH-1), .e_k(14'h0003), .ORDER(12) )
   CE12   ( .CLK(clk), .RESET_n(reset), 
           .x_k(x[12]), .y_k(y[12]), .z_k(z[12]), 
           .x_k1(x[13]), .y_k1(y[13]), .z_k1(z[13])  );

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
      $readmemh("triangle_x_test_vector.txt", test_vector_x);
      $readmemh("triangle_y_test_vector.txt", test_vector_y);
      $readmemh("triangle_z_test_vector.txt", test_vector_z);
    end
    
//Load the input of 0 order element
assign      x[0] = test_vector_x[0];
assign      y[0] = test_vector_y[0];
assign      z[0] = test_vector_z[0];
    
//Comparision
    always @(posedge clk)
    begin
        if ( !reset)
        //reset statement: counter keeps at 0
        begin
            for (loop = 0; loop <= (`ORDER+1); loop = loop + 1)
            begin
            	comp_x[loop] <= 1'b0;
            	comp_y[loop] <= 1'b0;
            	comp_z[loop] <= 1'b0;
            end
        end
        else
        begin
            for (loop = 0; loop <= (`ORDER+1); loop = loop + 1)
            begin
                comp_x[loop] <= (x[loop] - test_vector_x[loop]);
                comp_y[loop] <= (y[loop] - test_vector_y[loop]);
                comp_z[loop] <= (z[loop] - test_vector_z[loop]);
            end
        end
    end
        
endmodule
