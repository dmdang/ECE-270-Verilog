module lab10_top(DIP, i_S1_NC, i_S1_NO, i_S2_NC, i_S2_NO, o_TOPRED, o_MIDRED, o_BOTRED, o_DIS1, o_DIS2, o_DIS3, o_DIS4, o_JUMBO, o_LED_YELLOW);

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

// ----------step 3------------------

localparam state0 = 5'b00000;
localparam state1 = 5'b00001;
localparam state2 = 5'b00010;
localparam state3 = 5'b00011;
localparam state4 = 5'b00100;  
localparam state5 = 5'b00101;
localparam state6 = 5'b00110;
localparam state7 = 5'b00111;
localparam state8 = 5'b01000;
localparam state9 = 5'b01001;
localparam state10 = 5'b01010;
localparam state11 = 5'b01011;
localparam state12 = 5'b01100;
localparam state13 = 5'b01101;
localparam state14 = 5'b01110;
localparam state15 = 5'b01111;
localparam state16 = 5'b10000;
localparam state17 = 5'b10001; 
localparam state18 = 5'b10010;
localparam state19 = 5'b10011;
localparam state20 = 5'b10100;
localparam state21 = 5'b10101;
localparam state22 = 5'b10110;
localparam state23 = 5'b10111;
localparam state24 = 5'b11000;
localparam state25 = 5'b11001;
localparam state26 = 5'b11010;
localparam state27 = 5'b11011;
localparam state28 = 5'b11100;
localparam state29 = 5'b11101;
localparam state30 = 5'b11110;
localparam state31 = 5'b11111;

reg CLK_out;
reg CLK_out2;
reg [4:0] next_Q;
reg [4:0] Q;
reg [6:0] out;

always @(posedge tmr_out) begin

	CLK_out <= !CLK_out;

end

always @(posedge CLK_out) begin

	CLK_out2 <= !CLK_out2;

end

always @ (Q) begin

	if (DIP[7]) begin

		next_Q = state0;
		
	end

	else begin
	
	case (Q)
		state0: begin 	// common blank
			
			if (DIP[1:0] == 2'b00) next_Q = state1;
			else if (DIP[1:0] == 2'b01) next_Q = state10;
			else if (DIP[1:0] == 2'b10) next_Q = state15;
			else if (DIP[1:0] == 2'b11) next_Q = state24;
			end

		state1: begin	// ___G
			
			if (DIP[1:0] == 2'b00) next_Q = state2;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
			

		state2: begin	// __GO 
			
			if (DIP[1:0] == 2'b00) next_Q = state3;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state3: begin	// _GO_
			
			if (DIP[1:0] == 2'b00) next_Q = state4;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
			

		state4: begin	// GO_P

			if (DIP[1:0] == 2'b00) next_Q = state5;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
			
			
		state5: begin	// O_PU

			if (DIP[1:0] == 2'b00) next_Q = state6;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state6: begin	// _PUR

			if (DIP[1:0] == 2'b00) next_Q = state7;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
			
		state7: begin	// PURD

			if (DIP[1:0] == 2'b00) next_Q = state8;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state8: begin	// URDU 

			if (DIP[1:0] == 2'b00) next_Q = state9;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state9: begin	// RDUE

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state10: begin // ___N
			
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state11;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
		
		state11: begin //__NO
			
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state12;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
		
		state12: begin //_NOI
			
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state13;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state13: begin //NOIS
			
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state14;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state14: begin //OISE
			
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state15: begin //___B
			
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state16;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state16: begin //__BO

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state17;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state17: begin //_BOI
		
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state18;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state18: begin //BOIL

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state19;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state19: begin //OILE

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state20;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state20: begin //ILER

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state21;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state21: begin //LER_

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state22;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state22: begin //ER_U

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state23;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state23: begin //R_UP

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end

		state24: begin //___R

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state25;
			end

		state25: begin //__RE

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state26;
			end

		state26: begin //_REA

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state27;
			end

		state27: begin //REAL

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state28;
			end

		state28: begin //EAL_
		
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state29;
			end

		state29: begin //AL_B
		
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state30;
			end

		state30: begin //L_BI

			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state31;
			end

		state31: begin //_BIG
	
			if (DIP[1:0] == 2'b00) next_Q = state0;
			else if (DIP[1:0] == 2'b01) next_Q = state0;
			else if (DIP[1:0] == 2'b10) next_Q = state0;
			else if (DIP[1:0] == 2'b11) next_Q = state0;
			end
		
	endcase
	end


end

always @(Q) begin 

	case(Q) 
		state0: out = blank; 
		state1: out = charG; 
		state2: out = charO; 
		state3: out = blank; 
		state4: out = charP; 
		state5: out = charU; 
		state6: out = charR; 
		state7: out = charD;
		state8: out = charU;
		state9: out = charE;
		state10: out = charN;
		state11: out = charO;
		state12: out = charI;
		state13: out = charS;
		state14: out = charE;
		state15: out = charB;
		state16: out = charO;
		state17: out = charI;
		state18: out = charL;
		state19: out = charE;
		state20: out = charR;
		state21: out = blank;
		state22: out = charU;
		state23: out = charP;
		state24: out = charR;
		state25: out = charE;
		state26: out = charA;
		state27: out = charL;
		state28: out = blank;
		state29: out = charB;
		state30: out = charI;
		state31: out = charG;
			
	endcase 
end 

always @ (posedge CLK_out2) begin
	
	Q <= next_Q;

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

always @ (CLK_out2) begin

	LED_YELLOW_R = CLK_out2;
end


// ----------step 3------------------

// -----------step 2----------------
/*
reg CLK_out;
reg CLK_out2;
reg [6:0] next_Q;

always @(posedge tmr_out) begin

	CLK_out <= !CLK_out;

end

always @(posedge CLK_out) begin

	CLK_out2 <= !CLK_out2;

end

always @ (posedge CLK_out2, posedge DIP[7]) begin
	if (DIP[7]) begin
		DIS1 <= blank;
		DIS2 <= blank;
		DIS3 <= blank;
		DIS4 <= blank;
	end
	else begin	
		DIS1 <= next_Q;
		DIS2 <= DIS1;
		DIS3 <= DIS2;
		DIS4 <= DIS3;
	end
end
always @ (DIP[6:0]) begin
	LED_YELLOW_R = CLK_out2;
	next_Q <= DIP[6:0];
end
*/
// -----------step 2 ---------------

// -----------step 1----------------
/*
reg CLK_out;
reg CLK_out2;

always @(posedge tmr_out) begin

	CLK_out <= !CLK_out;

end

always @(posedge CLK_out) begin

	CLK_out2 <= !CLK_out2;

end


always @ (CLK_out2) begin

	LED_YELLOW_R = CLK_out2;
end

*/

// -----------step 1----------------


endmodule 