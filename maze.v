`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:45:35 11/30/2021 
// Design Name: 
// Module Name:    maze 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module maze(
	input 		          			clk,
	input [maze_width - 1:0]  		starting_col, starting_row, 	// indicii punctului de start
	input  			 				 	maze_in, 			// ofera informa?ii despre punctul de coordonate [row, col]
	output reg [maze_width - 1:0] row, col,	 		// selecteaza un rând si o coloana din labirint
	output reg		  					maze_oe,				// output enable (activeaza citirea din labirint la rândul ?i coloana date) - semnal sincron	
	output reg		  					maze_we, 			// write enable (activeaza scrierea în labirint la rândul ?i coloana date) - semnal sincron
	output reg		  					done);		 		// ie?irea din labirint a fost gasita; semnalul ramane activ 
	
	parameter maze_width=6;
	reg [maze_width - 1:0] state, next_state=0;
	
	`define INIT 	0
	`define S1		1		
	`define S2		2		
	`define S3		3		
	`define S4		4
	`define S5		5		
	`define S6		6		
	`define S7		7		
	`define S8		8
	`define STOP	9
	
	always@(posedge clk)begin
		state<=next_state;
	end
	
	always@(*)begin
		maze_we=0;
		maze_oe=0;
		case(state)
			`INIT:begin
				col=starting_col;
				row=starting_row;
				done=0;
				maze_oe=1;
				next_state=`S1;
			end
			`S1:begin					//EST
				if((row==63 || row==0 || col==63 || col==0) && maze_in!=1)begin
						next_state=`STOP;
						done=1;
				end else
				if(maze_in==0)begin
					maze_we=1;
					next_state=`S2;
				end else begin
					col=col-1;
					maze_oe=1;
					next_state=`S7;
				end
			end
			`S2:begin
				row=row+1;
				maze_oe=1;
				next_state=`S3;
			end
			`S3:begin				//SUD
				if((row==63 || row==0 || col==63 || col==0) && maze_in!=1)begin
						next_state=`STOP;
						done=1;
				end else 
				if(maze_in==0)begin
					maze_we=1;
					next_state=`S4;
				end else begin
					row=row-1;
					maze_oe=1;
					next_state=`S5;				
				end
			end
			`S4:begin
				col=col-1;
				maze_oe=1;
				next_state=`S7;
			end
			`S5:begin			//NORD
				if((row==63 || row==0 || col==63 || col==0) && maze_in!=1)begin
						next_state=`STOP;
						done=1;
				end else 
				if(maze_in==0)begin
					maze_we=1;
					next_state=`S6;
				end else begin
					row=row+1;
					maze_oe=1;
					next_state=`S3;
				end
			end
			`S6:begin
				col=col+1;
				maze_oe=1;
				next_state=`S1;
			end
			`S7:begin		//VEST
				if((row==63 || row==0 || col==63 || col==0) && maze_in!=1)begin
						next_state=`STOP;
						done=1;
				end else 
				if(maze_in==0)begin
					maze_we=1;
					next_state=`S8;
				end else begin
					col=col+1;
					maze_oe=1;
					next_state=`S1;				
				end
			end
			`S8:begin
				row=row-1;
				maze_oe=1;
				next_state=`S5;
			end
			`STOP:begin
				maze_we=1;
				maze_oe=0;
			end 
		endcase
	end
endmodule
