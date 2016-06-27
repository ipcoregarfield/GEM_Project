/***********************************************
Module Name:   CORDIC_Element
Feature:       One step CORDIC calculation
               An example for the GEM Projects
Coder:         Garfield
Organization:  xxxx Group, Department of Architecture
------------------------------------------------------
Input ports:   clk: System clock
               Reset: System reset
               x_k, y_k, z_k: result from pre-step
Output Ports:  x_k1, y_k1, z_k1: results of this step
------------------------------------------------------
History:
03-19-2016: First Version by Garfield
06-20-2016: Verified by CORDIC_Element_Test
***********************************************/

module CORDIC_elemet
#(parameter ADDRESS_WIDTH = 8,
//Address bit width for z_k
parameter VALUE_WIDTH = 8,
//Output value's bit width, internal one, for x_k and y_k
parameter[ADDRESS_WIDTH - 1 : 0] e_k = 2**(ADDRESS_WIDTH - 1),
//The rotation angle in this step
parameter ORDER = 0,
parameter MODE = 1)
//Order of this element


  ( 
    input CLK,
    input RESET_n,
    input signed[VALUE_WIDTH : 0] x_k,
    input signed[VALUE_WIDTH : 0] y_k,
    input signed[ADDRESS_WIDTH : 0] z_k,
    output reg signed[VALUE_WIDTH : 0] x_k1,
    output reg signed[VALUE_WIDTH : 0] y_k1,
    output reg signed[ADDRESS_WIDTH : 0] z_k1
  );

//Defination for Varables in the module
wire d_k;

//Logicals
generate
  if (MODE == 1)
    begin
        assign d_k = z_k[ADDRESS_WIDTH];
        //Get the symbol of z_k
    end
  else
    begin
        assign d_k = ~(x_k[ADDRESS_WIDTH]^y_k[ADDRESS_WIDTH]);
        //Get the symbol of -x_k * y_k
    end
endgenerate


//z_k calculation
//Angle rotation operation
always @ (posedge CLK or negedge RESET_n)
begin
    if (!RESET_n)
    begin
        z_k1 <= {(ADDRESS_WIDTH){1'b0}};
    end
    else if (d_k == 1'b0)
    //d_k is positive or zero
    begin
        z_k1 <= z_k -{1'b0, e_k};
    end
    else
    //d_k is positive or zero
    begin
        z_k1 <= z_k + {1'b0, e_k};
    end
end

//x_k and z_k calculation
//Value operation
always @ (posedge CLK or negedge RESET_n)
begin
    if (!RESET_n)
    begin
        x_k1 <= {(VALUE_WIDTH){1'b0}};
    end
    else if (d_k == 1'b0)
    //d_k is positive or zero
    begin
        x_k1 <= x_k - (y_k>>>ORDER);
    end
    else
    //d_k is negative
    begin
        x_k1 <= x_k + (y_k>>>ORDER);
    end
end

always @ (posedge CLK or negedge RESET_n)
begin
    if (!RESET_n)
    begin
        y_k1 <= {(VALUE_WIDTH){1'b0}};
    end
    else if (d_k == 1'b0)
    //d_k is positive or zero
    begin
        y_k1 <= y_k + (x_k>>>ORDER);
    end
    else
    //d_k is negative
    begin
        y_k1 <= y_k - (x_k>>>ORDER);
    end
end
endmodule