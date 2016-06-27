/***********************************************
Module Name:   CORDIC
Feature:       CORDIC algorithm
               An example for the GEM Projects
Coder:         Garfield
Organization:  xxxx Group, Department of Architecture
------------------------------------------------------
Input ports:   clk: System clock
               Reset_n: System reset
               opernd: input number to be calculated
Output Ports:  results: results of operation
------------------------------------------------------
History:
06-21-2016: First Version by Garfield
06-21-2016: Verified by CORDIC_Test
***********************************************/
`define ORDER 12
// CORDIC order by simulation
`define WIDTH 15
//CORDIC ports bit width by simulatation
`define K 14'h26DD

module CORDIC
#(parameter MODE = 1)
//CORDIC Mode
   ( 
    CLK,
    RESET_n,
    operand,
    results
   );
localparam PORT_WIDTH = (MODE == 3) ? (7 + `WIDTH) : ( (MODE == 2) ? (2 + `WIDTH) :(`WIDTH));
localparam IN_WIDTH = 2 * PORT_WIDTH;
localparam OUT_WIDTH = 2 * PORT_WIDTH;
localparam ONE = 15'd16384;

input CLK;
input RESET_n;
input signed[(IN_WIDTH - 1) : 0] operand;
output signed[(OUT_WIDTH - 1) : 0] results;

wire[(PORT_WIDTH-1):0] x[(`ORDER+1):0];
wire[(PORT_WIDTH-1):0] y[(`ORDER+1):0];
wire[(PORT_WIDTH-1):0] z[(`ORDER+1):0];
//middle signals

generate
begin
	case(MODE)
		1:
		begin
			assign x[0] = `K;
			assign y[0] = 14'h0;
			assign z[0] = operand[PORT_WIDTH -1 : 0];
		end
		2:
		begin
			assign x[0] = ONE;
			assign y[0] = operand[PORT_WIDTH -1 : 0];
			assign z[0] = 14'h0;
		end
		3:
		begin
			assign x[0] = operand[PORT_WIDTH -1 : 0];
			assign y[0] = operand[2*PORT_WIDTH  -1 : PORT_WIDTH];
			assign z[0] = 14'h0;
		end
		default:
		begin
			assign x[0] = `K;
			assign y[0] = 14'h0;
			assign z[0] = operand[PORT_WIDTH -1 : 0];
		end
	endcase
end
endgenerate

generate
begin
	case(MODE)
		1:
		begin
			assign results = {x[13], y[13]};
		end
		2:
		begin
			assign results = {{(PORT_WIDTH){1'b0}}, z[13]};
		end
		3:
		begin
			assign results = {{(PORT_WIDTH){1'b0}}, x[13]};
		end
		default:
		begin
			assign results = {x[13], y[13]};
		end
	endcase
end
endgenerate		

//CORDIC pipeline
//Connection to the modules
CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h3243), .ORDER(0), .MODE(MODE) )
   CE0   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[0]), .y_k(y[0]), .z_k(z[0]), 
           .x_k1(x[1]), .y_k1(y[1]), .z_k1(z[1])  );
           
CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h1DAC), .ORDER(1), .MODE(MODE)  )
   CE1   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[1]), .y_k(y[1]), .z_k(z[1]), 
           .x_k1(x[2]), .y_k1(y[2]), .z_k1(z[2])  );           

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h0FAD), .ORDER(2), .MODE(MODE)  )
   CE2   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[2]), .y_k(y[2]), .z_k(z[2]), 
           .x_k1(x[3]), .y_k1(y[3]), .z_k1(z[3])  );

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h07F5), .ORDER(3) , .MODE(MODE) )
   CE3   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[3]), .y_k(y[3]), .z_k(z[3]), 
           .x_k1(x[4]), .y_k1(y[4]), .z_k1(z[4])  );

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h03FE), .ORDER(4) , .MODE(MODE) )
   CE4   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[4]), .y_k(y[4]), .z_k(z[4]), 
           .x_k1(x[5]), .y_k1(y[5]), .z_k1(z[5])  );

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h01FF), .ORDER(5) , .MODE(MODE) )
   CE5   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[5]), .y_k(y[5]), .z_k(z[5]), 
           .x_k1(x[6]), .y_k1(y[6]), .z_k1(z[6])  );


CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h00FF), .ORDER(6) , .MODE(MODE) )
   CE6   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[6]), .y_k(y[6]), .z_k(z[6]), 
           .x_k1(x[7]), .y_k1(y[7]), .z_k1(z[7])  );


CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h007F), .ORDER(7) , .MODE(MODE) )
   CE7   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[7]), .y_k(y[7]), .z_k(z[7]), 
           .x_k1(x[8]), .y_k1(y[8]), .z_k1(z[8])  );
           
CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h003F), .ORDER(8) , .MODE(MODE) )
   CE8   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[8]), .y_k(y[8]), .z_k(z[8]), 
           .x_k1(x[9]), .y_k1(y[9]), .z_k1(z[9])  ); 

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h001F), .ORDER(9) , .MODE(MODE) )
   CE9   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[9]), .y_k(y[9]), .z_k(z[9]), 
           .x_k1(x[10]), .y_k1(y[10]), .z_k1(z[10])  );

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h000F), .ORDER(10) , .MODE(MODE) )
   CE10   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[10]), .y_k(y[10]), .z_k(z[10]), 
           .x_k1(x[11]), .y_k1(y[11]), .z_k1(z[11])  );

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h0007), .ORDER(11) , .MODE(MODE) )
   CE11   ( .CLK(CLK), .RESET_n(RESET_n),
           .x_k(x[11]), .y_k(y[11]), .z_k(z[11]), 
           .x_k1(x[12]), .y_k1(y[12]), .z_k1(z[12])  );

CORDIC_elemet #(.ADDRESS_WIDTH(PORT_WIDTH-1), .VALUE_WIDTH(PORT_WIDTH-1), .e_k(14'h0003), .ORDER(12) , .MODE(MODE) )
   CE12   ( .CLK(CLK), .RESET_n(RESET_n), 
           .x_k(x[12]), .y_k(y[12]), .z_k(z[12]), 
           .x_k1(x[13]), .y_k1(y[13]), .z_k1(z[13])  );
           
endmodule