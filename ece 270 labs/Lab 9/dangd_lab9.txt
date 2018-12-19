module lab9_top (DIP, i_S1_NC, i_S1_NO, i_S2_NC, i_S2_NO, o_TOPRED, o_MIDRED, o_BOTRED, o_DIS1, o_DIS2, o_DIS3, o_DIS4, o_JUMBO, o_LED_YELLOW);

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
//assign osc_dis = 1'b0;
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

// -----------------functions-------------------

// -----------------bounceless switch-----------
module DFF_BF(CLK, AR, AP, D, BFC);
	input wire CLK;
	input wire AR,AP;
	input wire D;
	output reg BFC;
	
always @ (posedge CLK, posedge AR, posedge AP) begin

	if (AR == 1'b1)
		BFC <= 0;

	else if (AP == 1'b1)
		BFC <= 1;
	else
		BFC <= D;

end
endmodule
// -----------------bounceless switch-----------

//
// lab 9 Step 10
// Light Sequence Detector 
// Moore Model 
//

module moorelsa_sd(clk,reset,in,out);
input clk;
input reset;
input [1:0] in;
output reg [2:0] out;
reg [2:0] present_state;
reg [2:0] next_state; 

localparam A0 = 3'b000;
localparam A1 = 3'b001;
localparam A2 = 3'b010;
localparam A3 = 3'b011;
localparam A4 = 3'b100;
localparam A5 = 3'b101;
localparam A6 = 3'b110;
localparam A7 = 3'b111;


// Sequential always block 
always @(posedge clk) begin
	if (reset == 1) 
			present_state <= A0;
	else  
			present_state <= next_state; 
end 

// Next state logic Combinational  

always @(in or present_state) begin 
	case (present_state) 
		A0: begin 
			if (in == 2'b00)      next_state = A4;
		    	else if (in == 2'b01) next_state = A1;
		    	else if (in == 2'b10) next_state = A4;
		    	else if (in == 2'b11) next_state = A1;
		    end 
		A1: begin 
			if (in == 2'b00)      next_state = A0;
		    	else if (in == 2'b01) next_state = A2;
		    	else if (in == 2'b10) next_state = A0;
		    	else if (in == 2'b11) next_state = A3;
		    end 
		A2: begin 
			if (in == 2'b00)      next_state = A1;
		    	else if (in == 2'b01) next_state = A4;
		    	else if (in == 2'b10) next_state = A0;
		    	else if (in == 2'b11) next_state = A0;
		    end 
		A3: begin 
			if (in == 2'b00)      next_state = A0;
		    	else if (in == 2'b01) next_state = A0;
		    	else if (in == 2'b10) next_state = A0;
		    	else if (in == 2'b11) next_state = A7;
		    end 
		A4: begin 
			if (in == 2'b00)      next_state = A2;
		    	else if (in == 2'b01) next_state = A0;
		    	else if (in == 2'b10) next_state = A6;
		    	else if (in == 2'b11) next_state = A0;
		    end 
		A5: begin 
		    	next_state = A0;
		    end 
		A6: begin 
			if (in == 2'b00)      next_state = A0;
		    	else if (in == 2'b01) next_state = A0;
		    	else if (in == 2'b10) next_state = A7;
		    	else if (in == 2'b11) next_state = A0;
		    end 
		A7: begin 
			if (in == 2'b00)      next_state = A0;
		    	else if (in == 2'b01) next_state = A0;
		    	else if (in == 2'b10) next_state = A0;
		    	else if (in == 2'b11) next_state = A0;
		    end
		endcase
	end 
// Output logic Combinational  
always @(present_state) begin 
	case(present_state) 
		A0: out = A0; 
		A1: out = A1; 
		A2: out = A2; 
		A3: out = A3; 
		A4: out = A4; 
		A5: out = A5; 
		A6: out = A6; 
		A7: out = A7;
	endcase 
end 
endmodule  

//
// lab 9 Step 10
// Light Sequence Detector 
// Moore Model 
//

// -----------4 bit upcount left side--------
module rcnt4U2(CLK, R, Q);

	input wire CLK;
	input wire R;
	output reg [7:4] Q;
	reg [7:4] next_Q;
	//input wire AR, AP;

	always @ (posedge CLK, posedge R) begin
	
		Q <= next_Q;
		if (R == 1'b1) begin
			Q <= 4'b0000; // next_Q
			
		end
		

	end

	always @ (Q) begin

		next_Q[4] = ~Q[4];
		next_Q[5] = Q[5] ^ Q[4];
		next_Q[6] = Q[6] ^ (Q[5] & Q[4]);
		next_Q[7] = Q[7] ^ (Q[6] & Q[5] & Q[4]);
	end
	
endmodule
// -----------4 bit upcount left side--------
// -----------4 bit upcount right side--------
 module rcnt4UD(CLK, R, M, Q);

	input wire CLK, M; // M=0 count down, M=1 count up
	output reg [7:0] Q;
	input wire R;
	
	reg [7:0] next_Q;
	
	always @ (posedge CLK, posedge R) begin
		Q <= next_Q;

		if (R == 1'b1) begin
			Q <= 4'b0000; // next_Q
		end
	end	

	always @ (Q, M) begin

		if (M == 1'b0) begin
			next_Q[0] = ~Q[0];
			next_Q[1] = Q[1] ^ ~Q[0];
			next_Q[2] = Q[2] ^ (~Q[1] & ~Q[0]);
			next_Q[3] = Q[3] ^ (~Q[2] & ~Q[1] & ~Q[0]);
		end

		else begin
			next_Q[0] = ~Q[0];
			next_Q[1] = Q[1] ^ Q[0];
			next_Q[2] = Q[2] ^ (Q[1] & Q[0]);
			next_Q[3] = Q[3] ^ (Q[2] & Q[1] & Q[0]);
		end
	end	
		

endmodule
// -----------4 bit upcount right side--------
// -----------ring oscillator-----------------

module ring8sc(CLK, Q);

	input wire CLK;
	output reg [7:0] Q;


	reg [7:0] next_Q;

	always @(posedge CLK) begin
		Q <= next_Q;
	end
	
	always @ (Q) begin
		next_Q[7] = Q[6];
		next_Q[6] = Q[5];
		next_Q[5] = Q[4];
		next_Q[4] = Q[3];
		next_Q[3] = Q[2];
		next_Q[2] = Q[1];
		next_Q[1] = Q[0];
		next_Q[0] = ~(Q[6] | Q[5] | Q[4] | Q[3] | Q[2] | Q[1] | Q[0]);
	end
	

endmodule

// --------------ring oscillator-----------------
// --------------4 bit up down counter-----------
module rcnt4UD(CLK, R, M, Q);

	input wire CLK, M; // M=0 count down, M=1 count up
	output reg [7:0] Q;
	input wire R;
	
	reg [7:0] next_Q;
	
	always @ (posedge CLK, posedge R) begin
		Q <= next_Q;

		if (R == 1'b1) begin
			Q <= 4'b0000; // next_Q
		end
	end	

	always @ (Q, M) begin

		if (M == 1'b0) begin
			next_Q[0] = ~Q[0];
			next_Q[1] = Q[1] ^ ~Q[0];
			next_Q[2] = Q[2] ^ (~Q[1] & ~Q[0]);
			next_Q[3] = Q[3] ^ (~Q[2] & ~Q[1] & ~Q[0]);
		end

		else begin
			next_Q[0] = ~Q[0];
			next_Q[1] = Q[1] ^ Q[0];
			next_Q[2] = Q[2] ^ (Q[1] & Q[0]);
			next_Q[3] = Q[3] ^ (Q[2] & Q[1] & Q[0]);
		end
	end	
		

endmodule
// --------------4 bit up down counter-----------
//------------------functions-------------------

// -----------------step 10---------------------

output reg CLK_out;
input wire RST;
wire [2:0] jumboLedTemp;
wire [7:0] MIDREDtemp;
assign osc_dis = !DIP[1];

always @(posedge tmr_out, posedge RST) begin
	if (RST == 1'b1) begin
		CLK_out <= 0;
	end
	
	else begin
		CLK_out <= !CLK_out;
	end
end

moorelsa_sd lightSequencer (.clk(CLK_out), .reset(DIP[0]), .in(DIP[3:2]), .out(jumboLedTemp[2:0]));

always @ (jumboLedTemp) begin

	JUMBO_R = jumboLedTemp[0];
	JUMBO_Y = jumboLedTemp[1]; 
	JUMBO_G = jumboLedTemp[2];
	
end

ring8sc ringCounter (.CLK(CLK_out), .Q(MIDREDtemp));

always @ (MIDREDtemp) begin
	
	MIDRED = MIDREDtemp;
	
end

wire [3:0] TOPREDtemp6;
wire [7:4] TOPREDtemp7;

rcnt4U2 fourBitUP_cnt2 (.CLK(LED_YELLOW_L), .R(DIP[0]), .Q(TOPREDtemp7[7:4]));
rcnt4UD fourBitUP_cntUD (.CLK(LED_YELLOW_R), .R(DIP[0]), .M(DIP[6]), .Q(TOPREDtemp6[3:0]));

always @ (TOPREDtemp6, TOPREDtemp7) begin

	TOPRED[3:0] = TOPREDtemp6;
	TOPRED[7:4] = TOPREDtemp7;
	
	case(DIP)
		DIP: BOTRED = DIP;
		default: BOTRED = 8'b00000000;
	endcase
	
	if (DIP[7] == 1'b1) begin
		BOTRED[7] = 1'b1;
		DIS4 = charG;
		DIS3 = charO;
		DIS2 = charP;
		DIS1 = charU;
	end
	
	else begin
		
		DIS3 = blank;
		DIS2 = blank;
		
		case(TOPREDtemp6)
			
			4'b0000 : DIS1 = char0;
			4'b0001 : DIS1 = char1;
			4'b0010 : DIS1 = char2;
			4'b0011 : DIS1 = char3;
			4'b0100 : DIS1 = char4;
			4'b0101 : DIS1 = char5;
			4'b0110 : DIS1 = char6;
			4'b0111 : DIS1 = char7;
			4'b1000 : DIS1 = char8;
			4'b1001 : DIS1 = char9;
			4'b1010 : DIS1 = charA;
			4'b1011 : DIS1 = charB;
			4'b1100 : DIS1 = charC;
			4'b1101 : DIS1 = charD;
			4'b1110 : DIS1 = charE;
			4'b1111 : DIS1 = charF;
			default: DIS1 = blank;
	
		endcase

		case(TOPREDtemp7)
		
			4'b0000 : DIS4 = char0;
			4'b0001 : DIS4 = char1;
			4'b0010 : DIS4 = char2;
			4'b0011 : DIS4 = char3;
			4'b0100 : DIS4 = char4;
			4'b0101 : DIS4 = char5;
			4'b0110 : DIS4 = char6;
			4'b0111 : DIS4 = char7;
			4'b1000 : DIS4 = char8;
			4'b1001 : DIS4 = char9;
			4'b1010 : DIS4 = charA;
			4'b1011 : DIS4 = charB;
			4'b1100 : DIS4 = charC;
			4'b1101 : DIS4 = charD;
			4'b1110 : DIS4 = charE;
			4'b1111 : DIS4 = charF;
			default: DIS4 = blank;

		endcase

	end 
end


assign o_BOTRED = ~BOTRED;
assign o_DIS4 = ~DIS4;
assign o_DIS1 = ~DIS1;

// -----------------step 10---------------------

// -----------------step 9----------------------
/*
output reg CLK_out;
input wire RST;
wire [7:0] MIDREDtemp;

always @(posedge tmr_out, posedge RST) begin
	if (RST == 1'b1) begin
		CLK_out <= 0;
	end
	
	else begin
		CLK_out <= !CLK_out;
	end
end

ring8sc ringCounter (.CLK(CLK_out), .Q(MIDREDtemp));

always @ (MIDREDtemp) begin
	
	MIDRED = MIDREDtemp;
	
end
*/
// -----------------step 9----------------------

// -----------------step 8----------------------
// comment out if on step 9
/*
wire [3:0] TOPREDtemp6;
wire [7:4] TOPREDtemp7;

rcnt4U2 fourBitUP_cnt2 (.CLK(LED_YELLOW_L), .R(DIP[0]), .Q(TOPREDtemp7[7:4]));
rcnt4UD fourBitUP_cntUD (.CLK(LED_YELLOW_R), .R(DIP[0]), .M(DIP[6]), .Q(TOPREDtemp6[3:0]));

always @ (TOPREDtemp6, TOPREDtemp7) begin

	TOPRED[3:0] = TOPREDtemp6;
	TOPRED[7:4] = TOPREDtemp7;
	
	case(DIP)
		DIP: BOTRED = DIP;
		default: BOTRED = 8'b00000000;
	endcase
	
	if (DIP[7] == 1'b1) begin
		BOTRED[7] = 1'b1;
		DIS4 = charG;
		DIS3 = charO;
		DIS2 = charP;
		DIS1 = charU;
	end
	
	else begin
		
		DIS3 = blank;
		DIS2 = blank;
		
		case(TOPREDtemp6)
			
			4'b0000 : DIS1 = char0;
			4'b0001 : DIS1 = char1;
			4'b0010 : DIS1 = char2;
			4'b0011 : DIS1 = char3;
			4'b0100 : DIS1 = char4;
			4'b0101 : DIS1 = char5;
			4'b0110 : DIS1 = char6;
			4'b0111 : DIS1 = char7;
			4'b1000 : DIS1 = char8;
			4'b1001 : DIS1 = char9;
			4'b1010 : DIS1 = charA;
			4'b1011 : DIS1 = charB;
			4'b1100 : DIS1 = charC;
			4'b1101 : DIS1 = charD;
			4'b1110 : DIS1 = charE;
			4'b1111 : DIS1 = charF;
			default: DIS1 = blank;
	
		endcase

		case(TOPREDtemp7)
		
			4'b0000 : DIS4 = char0;
			4'b0001 : DIS4 = char1;
			4'b0010 : DIS4 = char2;
			4'b0011 : DIS4 = char3;
			4'b0100 : DIS4 = char4;
			4'b0101 : DIS4 = char5;
			4'b0110 : DIS4 = char6;
			4'b0111 : DIS4 = char7;
			4'b1000 : DIS4 = char8;
			4'b1001 : DIS4 = char9;
			4'b1010 : DIS4 = charA;
			4'b1011 : DIS4 = charB;
			4'b1100 : DIS4 = charC;
			4'b1101 : DIS4 = charD;
			4'b1110 : DIS4 = charE;
			4'b1111 : DIS4 = charF;
			default: DIS4 = blank;

		endcase

	end 
end

assign o_BOTRED = ~BOTRED;
assign o_DIS4 = ~DIS4;
assign o_DIS1 = ~DIS1;
*/
// -------------------step 7--------------------
// comment out if on step 8
/*
output reg CLK_out;
input wire RST;

always @(posedge tmr_out, posedge RST) begin
	if (RST == 1'b1) begin
		CLK_out <= 0;
	end
	
	else begin
		CLK_out <= !CLK_out;
	end
end

wire [3:0] TOPREDtemp5;
assign osc_dis = !DIP[1];

rcnt4UD fourBitUP_cntUD (.CLK(CLK_out), .R(DIP[0]), .M(DIP[6]), .Q(TOPREDtemp5[3:0]));

always @ (TOPREDtemp5) begin

	TOPRED[3:0] = TOPREDtemp5;
end
*/
// -------------------step 7--------------------

// -------------------step 6--------------------
// comment out if on step 7
/*
wire [3:0] TOPREDtemp5;
assign osc_dis = !DIP[1];

rcnt4UD fourBitUP_cntUD (.CLK(tmr_out), .R(DIP[0]), .M(DIP[6]), .Q(TOPREDtemp5[3:0]));

always @ (TOPREDtemp5) begin

	TOPRED[3:0] = TOPREDtemp5;
end
*/
// -------------------step 6--------------------

// -------------------step 5--------------------
// comment out if on step 3,4,6,7
/*
wire [7:4] TOPREDtemp3;

rcnt4U2 fourBitUP_cnt2 (.CLK(LED_YELLOW_L), .R(DIP[0]), .Q(TOPREDtemp3[7:4]));

always @ (TOPREDtemp3) begin

	TOPRED[7:4] = TOPREDtemp3;

end

wire [3:0] TOPREDtemp4;

rcnt4UD fourBitUP_cntUD (.CLK(LED_YELLOW_R), .R(DIP[0]), .M(DIP[6]), .Q(TOPREDtemp4[3:0]));

always @ (TOPREDtemp4) begin

	TOPRED[3:0] = TOPREDtemp4;
end
*/
// -------------------step 5--------------------

// --------------------step 4-------------------
// comment out if doing step 5
/*
wire [7:4] TOPREDtemp2;

rcnt4U2 fourBitUP_cnt2 (.CLK(LED_YELLOW_R), .R(DIP[0]), .Q(TOPREDtemp2[7:4]));

always @ (TOPREDtemp2) begin

	TOPRED[7:4] = TOPREDtemp2;

end
*/
// --------------------step 4-------------------

// --------------------step 3-------------------
// comment out if doing step 5
/*
wire [3:0] TOPREDtemp;

rcnt4U fourBitUP_cnt (.CLK(LED_YELLOW_R), .R(DIP[0]), .Q(TOPREDtemp[3:0]));

always @ (TOPREDtemp) begin

	TOPRED[3:0] = TOPREDtemp;
	
end
*/
// --------------------step 3-------------------

// --------------------step 2 ------------------

wire ledTemp1, ledTemp2;

DFF_BF bounceless_L (.CLK(1'b0), .AR(S2_NC), .AP(S2_NO), .D(1'b0), .BFC(ledTemp1));

DFF_BF bounceless_R (.CLK(1'b0), .AR(S1_NC), .AP(S1_NO), .D(1'b0), .BFC(ledTemp2));

always @ (ledTemp1, ledTemp2) begin
	
	LED_YELLOW_L = ledTemp1;
	LED_YELLOW_R = ledTemp2;
end
// --------------------step 2-------------------

// --------------------step 1 ------------------
// comment out if doing step 8
/*
always @ (DIP) begin
	
	if (DIP[7] == 1'b1) begin
		BOTRED[7] = 1'b1;
		DIS4 = charG;
		DIS3 = charO;
		DIS2 = charP;
		DIS1 = charU;
	end
	
	else begin
		BOTRED[7] = 1'b0;
		DIS4 = blank;
		DIS3 = blank;
		DIS2 = blank;
		DIS1 = blank;
	end
	
	case(DIP)
		DIP: BOTRED = DIP;
		default: BOTRED = 8'b00000000;
	endcase
end

assign o_BOTRED = ~BOTRED;
assign o_DIS4 = ~DIS4;
assign o_DIS3 = ~DIS3;
assign o_DIS2 = ~DIS2;
assign o_DIS1 = ~DIS1;
*/
// ------------------step 1 --------------------
endmodule
