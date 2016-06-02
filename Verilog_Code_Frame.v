
/***********************************************
Module Name:   name of the module (i.e., frac_FreqDiv)
Feature:       feature description(i.e., Integer frequency division)
Coder:         name of the writer (i.e., Garfield)
Organization:  department of the writer(i.e., XXXX Group, Department of Architecture)
------------------------------------------------------
Input ports:   input-port(s) list
               (i.e., CLK_in, 1bit clock
                      RST, 1 bit, reset)
Output Ports:  output-port(s) list
               (i.e., CLK_out, Divided Clock)
------------------------------------------------------
History: story on creation, verification and modification oprations
(i.e., 02-05-2016: First Version by Garfield
       02-05-2016: First verified by int_FreqDiv_test  ISE/Modelsim)
***********************************************/

module  frac_FreqDiv #(parameter DIV_IN = 3, DIV_OUT = 2)
//module declaration (with parameter(s))

//parameter(s)description, (i.e., DIV: factor for frequency division)
 ( 
    input CLK_in, RST,
    output CLK_out
  );
//port(s) list

//Declaration of local parameter(s) with descriptions
localparam N = DIV_IN / DIV_OUT;
localparam DIV_X = DIV_IN - DIV_OUT * N;
localparam DIV_Y = DIV_OUT;
localparam M1 = DIV_Y - DIV_X;
localparam M2 = DIV_X;
//Parameters in the paper
localparam CLK_M1 = M1 * N;
localparam CLK_M2 = M2 * (N + 1);
//Clock numbers for two periods
localparam CLK_NUMBER = CLK_M1 + CLK_M2;
//Total clock number
localparam WIDTH = int_log2(CLK_NUMBER);
//Counter width

//function(s) and task(s) definition
function integer int_log2(input integer num);
//feature description, i.e., Return the up-integer for log2(num)
begin
    int_log2 = 1;
    //operation description, i.e., Initial
    while ( (2 ** int_log2) < num)
    //Not reaching the number
    begin
        int_log2 = int_log2 + 1;
    end
end
endfunction

//Definition for Variables in the module with description
reg[WIDTH - 1:0] counter;
//Counter inset
wire c1, c2;
//Clock output for the two int_FreqDiv modules
reg sync1, sync2;
//Synchronization control
reg clk_selection;
//Clock slection between the two integer frequncy division modules

//Load other module(s)
int_FreqDiv #(.DIV(N)) I1(.CLK_in(CLK_in), .RST(RST),.SYNC(sync1), .CLK_out(c1));
int_FreqDiv #(.DIV(N+1)) I2(.CLK_in(CLK_in), .RST(RST), .SYNC(sync2), .CLK_out(c2));

//Logic  
//assign block(s) with description
assign CLK_out =(clk_selection) ? (c1) : (c2);
//Clock switching




//always blocks
//for combined logic with description
always @(*)
begin
    sync1 <= (counter   <  CLK_M1 );
end

always @(*)
begin
    assign sync2 <= ~sync1;
end

//for timing logic with description
always @(posedge CLK_in or negedge RST)
//Counter operation
begin
    if (!RST)
    //Reset
    begin
        counter <= 1'h0;
    end
    else if (counter == CLK_NUMBER - 1)
    //Reached the division value
    begin
        counter <= 1'h0;
    end
    else
    //Not yet
    begin
        counter <= counter + 1'h1;
    end
end 

always @(posedge CLK_in or negedge RST)
//Counter operation
begin
    if (!RST)
    //Reset
    begin
        clk_selection <=1'b0;
    end
    else
    //1 clock delay for sync1
    //Inter_FreqDiv has 1 clock delay between SYNC and CLK_out'e positive edge
    begin
        clk_selection <= sync1;
    end
end

endmodule