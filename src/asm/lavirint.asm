/*

	 p_rgb_matrix = 0x100;
	 p_frame_sync = 0x140;
	 p_pb_dec = 0x200;
	 p_rng = 0x300;
	

*/
.data
5			//starting point begins at this address
0x100
0x140
0x200
0x300
//x, y  -- starting and current point
//x, y  -- finish point

//x, y  -- random maze...
//.
//.
//.
// -1   -- random maze ends with -1

.text
/*
	List of registers:
	R0 - temp
	R1 - x
	R2 - y
	R3 - color and temp
	R4 - pointer
	R5 - p_pb_dec
	R6 - p_frame_sync
	R7 - p_rgb_matrix
*/

begin:

		// Setup pointers and color.
	inc R0, R0                  // addr = 1
	ld R7, R0                   // R7 <- p_rgb_matrix
	inc R0, R0                  // addr = 2
	ld R6, R0                   // R6 <- p_frame_sync
	inc R0, R0                  // addr = 3
	ld R5, R0                   // R5 <- p_pb_dec
	
first_frame_sync_rising_edge:
first_frame_sync_wait_0:
	ld R0, R6                   // R0 <- p_frame_sync
	jmpnz first_frame_sync_wait_0
first_frame_sync_wait_1:
	ld R0, R6                   // R0 <- p_frame_sync
	jmpz first_frame_sync_wait_1
	
all_leds_red:
	sub R1, R1, R1		// R1 <- 0
	inc R1, R1			// R1 <- 1
	inc R1, R1			// R1 <- 2
	shl R1, R1			// R1 <- 4
	shl R1, R1			// R1 <- 8
	dec R1, R1			// R1 <- 7
	mov R2, R1			// R2 <- 7
	sub R3, R3, R3
	inc R3, R3			//color - RED
	
loop:

	mov R0, R2			// R0 <- y
	shl R0, R0    
	shl R0, R0
	shl R0, R0			// y<<3
	add R0, R1, R0		// (y<<3) + x
	add R0, R7, R0		// p_rgb_matrix + (y<<3) + x
	st R3, R0

if:
	dec R1, R1			// x--
	jmpns loop
	sub R1, R1, R1
	inc R1, R1
	inc R1, R1
	shl R1, R1
	shl R1, R1
	dec R1, R1			// R1 <- 7
	dec R2, R2			// y--
	jmpns loop			
							//all LEDs are red now
							
		// generating random maze
priprema:
	sub R1, R1, R1		// R1 <- 0
	inc R1, R1			// R1 <- 1
	inc R1, R1			// R1 <- 2
	shl R1, R1			// R2 <- 4
	ld R4, R1			// R4 <- p_rng
	shl R1, R1			// R1 <- 8
	dec R1, R1			// R1 <- 7
	mov R2, R1			// R2 <- 7
	sub R3, R3, R3		// color - none
	
random_maze:
	mov R2, R2
	jmpz levo			//  y is at 0 coordinate
	ld R0, R4			// R0 <- random number between 0 and 1
	jmpz levo
	
gore:
	mov R0, R2			// R0 <- y
	dec R0, R0			// y--
	shl R0, R0
	shl R0, R0
	shl R0, R0			// y<<3
	add R0, R1, R0		// (y<<3) + x
	add R0, R7, R0		// p_rgb_matrix + (y<<3) + x
	st R3, R0
	jmp pomeraj_x

levo:
	mov R0, R2			// R0 <- y
	shl R0, R0
	shl R0, R0
	shl R0, R0			// y<<3
	add R0, R1, R0    // (y<<3) + x
	dec R0, R0			// x--
	add R0, R7, R0		// p_rgb_matrix + (y<<3) + x
	st R3, R0
	
pomeraj_x:
	dec R1, R1			// x--
	jmpz gore
	jmpns random_maze
	sub R1, R1, R1		// R1 <- 0
	inc R1, R1			// R1 <- 1
	inc R1, R1			// R1 <- 2
	shl R1, R1			// R1 <- 4
	shl R1, R1			// R1 <- 8
	dec R1, R1			// R1 <- 7
	dec R2, R2			// y--
	jmps upis
	jmp random_maze
												// random map is generated, now we will store its coordinates in memory											
upis:
	sub R1, R1, R1		// R1 <- 0
	inc R1, R1			// R1 <- 1
	inc R1, R1			// R1 <- 2
	shl R1, R1			// R1 <- 4
	shl R1, R1			// R1 <- 8
	mov R4, R1			// R4 <- 8
	inc R4, R4			// R4 <- 9 start of random maze coordinates 
	dec R1, R1			// R1 <- 7 -  x
	mov R2, R1			// R2 <- 7 -  y

petlja_upis:
	mov R0, R2			// R0 <- y
	shl R0, R0
	shl R0, R0
	shl R0, R0			// y<<3
	add R0, R1, R0		// (y<<3) + x
	add R0, R7, R0		// p_rgb_matrix + (y<<3) + x
	ld R3, R0			// R3 <- color from R0 address
	jmpz pomeraj
	
upis_u_memoriju:
	st R1,R4				// store x coordinate in memory
	inc R4, R4
	st R2, R4			// store y coordinate in memory
	inc R4, R4

pomeraj:
	dec R1, R1			// x--
	jmpns petlja_upis
	sub R1, R1, R1		// R1 <- 0
	inc R1, R1			// R1 <- 1
	inc R1, R1			// R1 <- 2
	shl R1, R1			// R1 <- 4
	shl R1, R1			// R1 <- 8
	dec R1, R1			// R1 <- 7
	dec R2, R2			// y--
	jmpns petlja_upis
	st R2, R4			// when all coordinates are written, we store -1 in memory -> end of the maze
	
							// generating random starting and random finish point
	sub R0, R0, R0 
	ld R3, R0			// R3 <- starting point x
	dec R0, R3			// R0 <- 4
	ld R4, R0 			// R4 <- p_rng
	inc R4, R4			// R4 <- p_rng + 1 (rng 7)
	
random_start:
	ld R1, R4			// R1 <- random x
	ld R2, R4			// R2 <- random y
	mov R0, R2
	shl R0, R0
	shl R0, R0
	shl R0, R0			// y<<3
	add R0, R1, R0		// (y<<3) + x
	add R0, R7, R0 	// p_rgb_matrix + (y<<3) + x
	ld R3, R0
	jmpnz random_start
	
	ld R0, R3			// R0 <- p_starting point x		R3 <- 0
	st R1, R0			// store x in memory
	inc R0, R0			// R0 <- p_starting point y
	st R2, R0 			// store y in memory
	
random_finish:
	ld R1, R4			// random x
	ld R2, R4			// random y
	mov R0, R2
	shl R0, R0
	shl R0, R0
	shl R0, R0			// y<<3
	add R0, R1, R0		// (y<<3) + x
	add R0, R7, R0 	// p_rgb_matrix + (y<<3) + x
	ld R3, R0
	jmpnz random_finish
	
	ld R0, R3			// R0 <- p_starting point x		R3 <- 0
	inc R0, R0			// R0 <- p_starting point y
	inc R0, R0			// R0 <- p_finish point x
	st R1, R0			// store x in memory
	inc R0, R0			// R0 <- p_finish point y		
	st R2, R0			// store y in memory
	
frame_sync_rising_edge:
frame_sync_wait_0:
	ld R0, R6                   // R0 <- p_frame_sync
	jmpnz frame_sync_wait_0
frame_sync_wait_1:
	ld R0, R6                   // R0 <- p_frame_sync
	jmpz frame_sync_wait_1
	
		//drawing begin
	
	sub R0, R0, R0
	ld R4, R0			// R4 <- p_starting point x
	sub R3, R3, R3
	inc R3, R3			// color RED
	inc R3, R3			// color GREEN
	
		//drawing starting point
		
	ld R1, R4			// R1 <- starting point x
	inc R4, R4
	ld R2, R4			// R2 <- starting point y
	shl R2, R2
	shl R2, R2
	shl R2, R2			// y<<3
	add R2, R1, R2		// (y<<3) + x
	add R2, R7, R2		// p_rgb_matrix + (y<<3) + x
	st R3, R2			// starting point is GREEN
	
		//drawing finish point
	
	shl R3, R3			// color is BLUE now
	inc R4, R4			// R4 <- p_finish  point x
	ld R1, R4			// R1 <- finish point x
	inc R4, R4			// R4 <- p_finish  point y
	ld R2, R4			// R2 <- finish point y
	shl R2, R2
	shl R2, R2
	shl R2, R2			// y<<3
	add R2, R1, R2		// (y<<3) + x
	add R2, R7, R2		// p_rgb_matrix + (y<<3) + x
	st R3, R2			// finish point is BLUE
	
			// drawing maze
	
	inc R4, R4 			// R4 <- 9
	sub R3, R3, R3
	inc R3, R3			// RED color
	
drawing_loop:
	ld R1, R4			// R1 <- x
	jmps moving			// when we load -1 from memory -> end of drawing maze walls
	inc R4, R4
	ld R2, R4			// R2 <- y
	inc R4, R4
	
	shl R2, R2
	shl R2, R2			
	shl R2, R2			// y<<3
	add R2, R1, R2		// (y<<3) + x
	add R2, R7, R2		// p_rgb_matrix + (y<<3) + x
	st R3, R2
	jmp drawing_loop
	
	
moving:
moving_x:
	sub R0, R0, R0
	ld R4, R0								// R4 <- p_current point x
	ld R1, R4								// R1 <- current point x
	ld R0, R5								// R0 <- pb_dec->x
	jmpz moving_y
	add R0, R1, R0							// moving x coordinate
	jmps frame_sync_rising_edge		// out of bounds (0,7) = -1
	sub R2, R2, R2							// R2 <- 0
	inc R2, R2								// R2 <- 1
	inc R2, R2								// R2 <- 2
	shl R2, R2								// R2 <- 4
	shl R2, R2								// R2 <- 8
	sub R2, R2, R0
	jmpz frame_sync_rising_edge		// out of bounds (0,7) = 8
	inc R4, R4								// R4 <- p_current point y
	ld R2, R4								// R2 <- current point y
	shl R2, R2
	shl R2, R2
	shl R2, R2								// y<<3
	add R2, R0, R2							// y<<3 + x
	add R2, R7, R2							// p_rgb_matrix + (y<<3) + x
	ld R1, R2
	jmpnz proveraX							// there is either wall or finish point
	dec R4, R4								// R4 <- p_current point x
	st R0, R4								// R0 -> current point x
	jmp frame_sync_rising_edge
	
		// checking if the address we want to move to is finish point
proveraX:
	inc R4, R4								// R4 <- p_finish point x
	ld R0, R4								// R0 <- finish point x
	inc R4, R4								// R4 <- p_finish point y
	ld R1, R4								// R1 <- finish point y
	shl R1, R1
	shl R1, R1
	shl R1, R1								// y<<3
	add R1, R0, R1							// (y<<3) + x
	add R1, R7, R1							// R1 <- address of finish point
	sub R1, R1, R2
	jmpz end									// the address we want to move towards is finish point and that is the end of the maze
	jmp frame_sync_rising_edge
	
moving_y:
	inc R4, R4								// R4 <- p_current point y
	inc R5, R5                  		// R5 <- p_pb_dec y
	ld R1, R4								// R2 <- current point y
	ld R0, R5								// R0 <- pb_dec y
	dec R5, R5								// R5 <- p_pb_dec x
	add R0, R1, R0							// moving y coordinate
	jmps frame_sync_rising_edge		// out of bounds (0,7) = -1
	sub R2, R2, R2							// R2 <- 0
	inc R2, R2								// R2 <- 1
	inc R2, R2								// R2 <- 2
	shl R2, R2								// R2 <- 4
	shl R2, R2								// R2 <- 8
	sub R2, R2, R0
	jmpz frame_sync_rising_edge		// out of bounds (0,7) = 8
	dec R4, R4								// R4 <- p_current point x
	ld R1, R4								// R1 <- current point x
	mov R2, R0								// R2 <- y
	shl R2, R2
	shl R2, R2
	shl R2, R2								// y<<3
	add R2, R1, R2							// (y<<3) + x
	add R2, R7, R2							// p_rgb_matrix + (y<<3) + x
	ld R1, R2
	jmpnz proveraY							// there is either wall or finish point
	inc R4, R4								// R4 <- p_current point y
	st R0, R4								// R0 -> current point y
	jmp frame_sync_rising_edge

		// checking if the address we want to move to is finish point
proveraY:
	inc R4, R4								// R4 <- p_current point y
	inc R4, R4								// R4 <- p_finish point x
	ld R0, R4								// R0 <- finish point x
	inc R4, R4								// R4 <- p_finish point y
	ld R1, R4								// R1 <- finish point y
	shl R1, R1
	shl R1, R1
	shl R1, R1								// y<<3							
	add R1, R0, R1							// (y<<3) + x	
	add R1, R7, R1							// p_rgb_matrix + (y<<3) + x
	sub R1, R1, R2
	jmpz end									// the address we want to move towards is finish point and that is the end of the maze
	jmp frame_sync_rising_edge

		
		// turning all LEDs off
end:

	sub R1, R1, R1							// R1 <- 0
	inc R1, R1								// R1 <- 1
	inc R1, R1								// R1 <- 2
	shl R1, R1								// R1 <- 4
	shl R1, R1								// R1 <- 8
	dec R1, R1								// R1 <- 7
	mov R2, R1								// R2 <- 7
	sub R3, R3, R3							// color - none
	
petljica:
	mov R0, R2								// R0 <- y
	shl R0, R0
	shl R0, R0
	shl R0, R0								// y<<3
	add R0, R1, R0							// (y<<3) + x
	add R0, R7, R0							// p_rgb_matrix + (y<<3) + x
	st R3, R0
	
	dec R1, R1								// x--
	jmpns petljica
	sub R1, R1, R1							// R1 <- 0
	inc R1, R1								// R1 <- 1
	inc R1, R1								// R1 <- 2
	shl R1, R1								// R1 <- 4
	shl R1, R1								// R1 <- 8
	dec R1, R1								// R1 <- 7
	dec R2, R2								// y--
	jmpns petljica
	jmp first_frame_sync_rising_edge
	