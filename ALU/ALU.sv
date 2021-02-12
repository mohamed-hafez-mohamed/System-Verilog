/*
 * ALU
 *
 * Created: 25/2/2020 10:22:49 AM
 * Author : Mohamed Hafez Mohamed
 */ 
 
/*I put N = 4 to make simulation using testbench more easier
We can now easily change it to N = 32*/

module ALU #(parameter N = 4)(input logic [N-1:0] A,B, 
input logic [1:0] ALUC, output logic [N-1:0] RESULT, output logic [3:0] FLAGS);

//internal variables
logic [N-1:0] B_BCOMP;
logic [N:0] SUM;                       //ADDER & SUBTRACTOR RESULT
logic [N-1:0] AND, OR;                   //AND , OR RESULT
logic NEGATIVE, ZERO, CARRY, OVERFLOW;   //ALU FLAGS

assign B_BCOMP  = ALUC[0]? ~B : B;       //determine B OR NOT ~B ALUC[0](B with ADD and vice versa)
assign SUM      = A + B_BCOMP + ALUC[0]; //ADD or SUB depend on the value of ALUC[0]
assign AND      = A & B;                 //AND operation
assign OR       = A | B;                 //OR operation

assign RESULT   = ALUC[1]?(ALUC[0]?OR:AND):(SUM);//output result

//flags assignment
assign NEGATIVE = RESULT[N - 1];            //the MSB determine negativity
assign ZERO     = &(~RESULT);               //using negative AND to detemine zeros
assign CARRY    = (~ALUC[1]) & SUM[N];     //it must ADD OR SUB to out carry
assign OVERFLOW = (~ALUC[1]) & (A[N - 1] ^ SUM [N - 1])//overflow occure with add or sub
& (~( ALUC[0] ^ A[N - 1] ^ B[N - 1]));                 //this show overflow conditions

assign FLAGS    = {NEGATIVE, ZERO, CARRY, OVERFLOW}; //concatenate flags

endmodule
