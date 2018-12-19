module lab11_top(DIP, i_S1_NC, i_S1_NO, i_S2_NC, i_S2_NO, o_TOPRED, o_MIDRED, o_BOTRED, o_DIS1, o_DIS2, o_DIS3, o_DIS4, o_JUMBO, o_LED_YELLOW);

// ====== DO NOT MODIFY BELOW ======
input wire [7:0] DIP /*synthesis loc="26,25,24,23,76,77,78,79"*/;		// DIP switches (MSB on the left)

input wire i_S1_NC /*synthesis loc="58"*/;					// ACTIVE LOW normally closed (down position)
input wire i_S1_NO /*synthesis loc="59"*/;					// ACTIVE LOW normally opened (up position)
input wire i_S2_NC /*synthesis loc="60"*/;					// ACTIVE LOW normally closed (down position)
input wire i_S2_NO /*synthesis loc="61"*/;					// ACTIVE LOW normally opened (up position)

output wire [7:0] o_TOPRED /*synthesis loc="28,29,30,31,32,33,39,40"*/;			// ACTIVE LOW first row of LED (from top, MSB on the left)
output wire [7:0] o_MIDRED /*synthesis loc="130,131,132,133,134,135,138,139"*/;		// ACTIVE LOW second row of LED (from top, MSB on the left)
output wire [7:0] o_BOTRED /*synthesis loc="112,111,105,104,103,102,101,100"*/;		// ACTIVE LOW third row of LED (from top, MSB on the left)

output wire [6:0] o_DIS1 /*synthesis loc="87,86,85,84,83,81,80"*/;			// ACTIVE LOW right most 7-segment
output wire [6:0] o_DIS2 /*synthesis loc="98,97,96,95,94,93,88"*/;			// ACTIVE LOW second right most 7-segment
output wire [6:0] o_DIS3 /*synthesis loc="125,124,123,122,121,120,116"*/;		// ACTIVE LOW second left most 7-segment
output wire [6:0] o_DIS4 /*synthesis loc="44,48,49,50,51,52,53"*/;			// ACTIVE LOW left most 7-segment

output wire [3:0] o_JUMBO /*synthesis loc="143,142,141,140*/;			// ACTIVE LOW Jumbo R-Y-G LED (unused, RED, YELLOW, GREEN)

output wire [1:0] o_LED_YELLOW /*synthesis loc="62,63*/;			// ACTIVE LOW yellow LED next to pushbuttons

// Active Low Assignments
wire S1_NC, S1_NO, S2_NC, S2_NO;
reg [7:0] TOPRED;
reg [7:0] MIDRED;
reg [7:0] BOTRED;
reg [6:0] DIS1;
reg [6:0] DIS2;
reg [6:0] DIS3;
reg [6:0] DIS4;
reg JUMBO_unused, JUMBO_R, JUMBO_Y, JUMBO_G;
reg LED_YELLOW_L, LED_YELLOW_R;

assign S1_NC = ~i_S1_NC;
assign S1_NO = ~i_S1_NO;
assign S2_NC = ~i_S2_NC;
assign S2_NO = ~i_S2_NO;
assign o_TOPRED = ~TOPRED;
assign o_MIDRED = ~MIDRED;
assign o_BOTRED = ~BOTRED;
assign o_DIS1 = ~DIS1;
assign o_DIS2 = ~DIS2;
assign o_DIS3 = ~DIS3;
assign o_DIS4 = ~DIS4;
assign o_JUMBO = {~JUMBO_unused, ~JUMBO_G, ~JUMBO_Y, ~JUMBO_R};
assign o_LED_YELLOW = {~LED_YELLOW_L, ~LED_YELLOW_R};


// Oscillator

wire osc_dis, tmr_rst, osc_out, tmr_out;
assign osc_dis = 1'b0;
assign tmr_rst = 1'b0;

defparam I1.TIMER_DIV = "1048576";
OSCTIMER I1 (.DYNOSCDIS(osc_dis), .TIMERRES(tmr_rst), .OSCOUT(osc_out), .TIMEROUT(tmr_out));


// 7-segment alphanumeric display code
localparam blank = 7'b0000000;
localparam char0 = 7'b1111110;
localparam char1 = 7'b0110000;
localparam char2 = 7'b1101101;
localparam char3 = 7'b1111001;
localparam char4 = 7'b0110011;
localparam char5 = 7'b1011011;
localparam char6 = 7'b1011111;
localparam char7 = 7'b1110000;
localparam char8 = 7'b1111111;
localparam char9 = 7'b1111011;
localparam charA = 7'b1110111;
localparam charB = 7'b0011111;
localparam charC = 7'b1001110;
localparam charD = 7'b0111101;
localparam charE = 7'b1001111;
localparam charF = 7'b1000111;
localparam charG = 7'b1111011;
localparam charH = 7'b0110111;
localparam charI = 7'b0010000;
localparam charJ = 7'b0111000;
localparam charL = 7'b0001110;
localparam charN = 7'b0010101;
localparam charO = 7'b0011101;
localparam charP = 7'b1100111;
localparam charR = 7'b0000101;
localparam charS = 7'b1011011;
localparam charU = 7'b0111110;
localparam charY = 7'b0111011;

// ====== DO NOT MODIFY ABOVE ======

// ---------step 4--------------------
localparam stated0 = 4'b0000;
localparam stated1 = 4'b0001;
localparam stated2 = 4'b0010;
localparam stated3 = 4'b0011;
localparam stated4 = 4'b0100;  
localparam stated5 = 4'b0101;
localparam stated6 = 4'b0110;
localparam stated7 = 4'b0111;
localparam stated8 = 4'b1000;
localparam stated9 = 4'b1001;
localparam stated10 = 4'b1010;
localparam stated11 = 4'b1011;
localparam stated12 = 4'b1100;
localparam stated13 = 4'b1101;
localparam stated14 = 4'b1110;  
localparam stated15 = 4'b1111;

reg [3:0] next_Qd;
reg [3:0] Qd; 
reg [6:0] out;

always @ (Qd) begin

	if (DIP[7]) begin

		next_Qd = stated0; 
	end 
		
	else begin 

	case (Qd)
		stated0: begin // blank
 
		if (Q == state0) next_Qd = stated1;
		else if (Q == state8) next_Qd = stated7;
		else if (Q == state9) next_Qd = stated11;		
		end
		
		stated1: begin // S
	
		if (Q == state0) next_Qd = stated2;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated2: begin // E
	
		if (Q == state0) next_Qd = stated3;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated3: begin // C
	
		if (Q == state0) next_Qd = stated4;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated4: begin // U
	
		if (Q == state0) next_Qd = stated5;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated5: begin // R
	
		if (Q == state0) next_Qd = stated6;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end
		
		stated6: begin // E
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated7: begin // O
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated8;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated8: begin // P
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated9;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated9: begin // E
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated10;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated10: begin // N
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		stated11: begin // E
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated12;		
		end

		stated12: begin // R
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated13;		
		end

		stated13: begin // R
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated14;		
		end

		stated14: begin // O
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated15;		
		end

		stated15: begin // R
	
		if (Q == state0) next_Qd = stated0;
		else if (Q == state8) next_Qd = stated0;
		else if (Q == state9) next_Qd = stated0;		
		end

		endcase

	end
end


always @(Qd) begin 

	case(Qd) 
		stated0: out = blank; 
		stated1: out = charS; 
		stated2: out = charE; 
		stated3: out = charC; 
		stated4: out = charU; 
		stated5: out = charR; 
		stated6: out = charE; 
		stated7: out = charO;
		stated8: out = charP;
		stated9: out = charE;
		stated10: out = charN;
		stated11: out = charE;
		stated12: out = charR;
		stated13: out = charR;
		stated14: out = charO;
		stated15: out = charR;

	endcase 
end




always @ (posedge CLK_out2) begin
	
	Qd <= next_Qd;

	if (DIP[7]) begin
		DIS1 <= blank;
		DIS2 <= blank;
		DIS3 <= blank;
		DIS4 <= blank;
	end

	else begin	
		DIS1 <= out;
		DIS2 <= DIS1;
		DIS3 <= DIS2;
		DIS4 <= DIS3;
	end
end





// ----------step 4-------------------

// ---------step 2/3------------------

localparam state0 = 4'b0000;
localparam state1 = 4'b0001;
localparam state2 = 4'b0010;
localparam state3 = 4'b0011;
localparam state4 = 4'b0100;  
localparam state5 = 4'b0101;
localparam state6 = 4'b0110;
localparam state7 = 4'b0111;
localparam state8 = 4'b1000;
localparam state9 = 4'b1001;

reg [3:0] next_Q;			
reg [3:0] Q;
//reg [7:0] TOPREDtemp2;

always @ (posedge LED_YELLOW_R, posedge DIP[7]) begin

	if (DIP[7] == 1'b1) begin
		Q <= state0;
	end

	else begin
		Q <= next_Q;
	end
	
end

always @ (DIP[2], LED_YELLOW_R) begin
	
	next_Q = Q;

	case (Q)
		state0: begin	// secure state, print secure
			
			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;


			if (LED_YELLOW_L == TOPRED[0]) next_Q = state1; 	// if switch matches, next state
			else if (LED_YELLOW_L != TOPRED[0]) next_Q = state9; // switch doesn't match, error state
			else if (DIP[2] == 1'b1) next_Q = state0; 		// relock
			end

		state1: begin	// int state 1
			
			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;


			if (LED_YELLOW_L == TOPRED[1]) next_Q = state2;
			else if (LED_YELLOW_L != TOPRED[1]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end 

		state2: begin // int state 2

			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;

			
			if (LED_YELLOW_L == TOPRED[2]) next_Q = state3;
			else if (LED_YELLOW_L != TOPRED[2]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state3: begin // int state 3

			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;

			
			if (LED_YELLOW_L == TOPRED[3]) next_Q = state4;
			else if (LED_YELLOW_L != TOPRED[3]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state4: begin

			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;


			if (LED_YELLOW_L == TOPRED[4]) next_Q = state5;
			else if (LED_YELLOW_L != TOPRED[4]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state5: begin

			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;

			
			if (LED_YELLOW_L == TOPRED[5]) next_Q = state6;
			else if (LED_YELLOW_L != TOPRED[5]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state6: begin

			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;


			if (LED_YELLOW_L == TOPRED[6]) next_Q = state7;
			else if (LED_YELLOW_L != TOPRED[6]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state7: begin

			JUMBO_Y = 1'b1;
			JUMBO_G = 1'b0;
			JUMBO_R = 1'b0;

		
			if (LED_YELLOW_L == TOPRED[7]) next_Q = state8;
			else if (LED_YELLOW_L != TOPRED[7]) next_Q = state9; 
			else if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state8: begin // open state, reset ring counter, green led

			JUMBO_Y = 1'b0;
			JUMBO_G = 1'b1;
			JUMBO_R = 1'b0;

			if (DIP[2] == 1'b1) next_Q = state0; 
			end

		state9: begin // error state, flash led and print error

			JUMBO_R = CLK_out2;
			JUMBO_Y = 1'b0;
			JUMBO_G = 1'b0;
			
			if (DIP[7] == 1'b1) next_Q = state0; // asynch reset
			end
		
		default: begin
				next_Q = state0;
				JUMBO_Y = 1'b1;
				JUMBO_G = 1'b0;
				JUMBO_R = 1'b0;

			end
 
			
		endcase

end

// ----------------------------------------

wire [7:0] MIDREDtemp;
wire ledTemp1, ledTemp2;

DFF_BF bounceless_L (.CLK(1'b0), .AR(S2_NC), .AP(S2_NO), .D(1'b0), .BFC(ledTemp1));

DFF_BF bounceless_R (.CLK(1'b0), .AR(S1_NC), .AP(S1_NO), .D(1'b0), .BFC(ledTemp2));

always @ (ledTemp1, ledTemp2) begin
	
	LED_YELLOW_L = ledTemp1;
	LED_YELLOW_R = ledTemp2;
end

ring8sc ringCounter (.CLK(LED_YELLOW_R), .Q(MIDREDtemp), .RST(DIP[7]), .relock(DIP[2]));

always @ (MIDREDtemp) begin

		MIDRED = MIDREDtemp;
end

// ---------step 2/3------------------

// ---------step 1------------------

reg CLK_out;
reg CLK_out2;
reg [7:0] TOPREDtemp;
wire RST;

assign RST = DIP[7];

always @(posedge tmr_out) begin

	CLK_out <= !CLK_out;
end

always @(posedge CLK_out) begin

	CLK_out2 <= !CLK_out2;

end

always @ (posedge CLK_out2, posedge RST) begin

	if (RST==1'b1) begin
		
		TOPREDtemp[7:0] <= 8'b11111111;
	end

	else if (DIP[0]== 1'b1) begin	

		TOPREDtemp[7] <= TOPREDtemp[6];
		TOPREDtemp[6] <= TOPREDtemp[5];
		TOPREDtemp[5] <= TOPREDtemp[4];
		TOPREDtemp[4] <= TOPREDtemp[3];
		TOPREDtemp[3] <= TOPREDtemp[2];
		TOPREDtemp[2] <= TOPREDtemp[1];
		TOPREDtemp[1] <= TOPREDtemp[0];
		TOPREDtemp[0] <= TOPREDtemp[4] ^ TOPREDtemp[3] ^ TOPREDtemp[2] ^ TOPREDtemp[0];
	
	end

	else begin
		TOPREDtemp[7:0] <= TOPREDtemp[7:0];
	
	end
end

always @ (TOPREDtemp) begin
	if (DIP[1] == 1'b0) begin
		TOPRED = TOPREDtemp;
	end
	else begin
		TOPRED = 8'b00000000;
	end
		
		
end

// ---------step 1------------------

endmodule
