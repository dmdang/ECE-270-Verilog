module lab12_top (DIP, i_S1_NC, i_S1_NO, i_S2_NC, i_S2_NO, o_TOPRED, o_MIDRED, o_BOTRED, o_DIS1, o_DIS2, o_DIS3, o_DIS4, o_JUMBO, o_LED_YELLOW);

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

// ====== DO NOT MODIFY ABOVE ====== // 
// NOTE: The Displays need multiple drivers in the last step of this experiment. 
//	 You might have to modify the declarations for DIS1 to DIS4.

// -----------step 6--------------










// -----------step 6--------------
// -----------step 5--------------
reg [7:0] score; 
reg [3:0] increment;
//wire [3:0] adderOut; 
//wire [3:0] Cout2;
reg correction; 
//wire [3:0] adderRect;
//wire [3:0] Cout3;
//wire [3:0] Cout4;
//wire [0:0] carry;
reg [4:0] joint;
//wire [3:0] adderTenOut;
reg [3:0] count; 

always @ (JUMBO_G, JUMBO_Y, JUMBO_R) begin

	if (JUMBO_G == 1'b1) begin
	
		increment = 4'b1001;
	end
	
	else if (JUMBO_Y == 1'b1) begin

		increment = 4'b0100;
	end

	else if (JUMBO_R == 1'b1) begin
		
		increment = 4'b0000;
	end
end

// determine if correction needed
always @ (posedge ledTemp2, posedge ledTemp1) begin

	if (ledTemp1 == 1'b1) begin
		
		score[7:0] = 8'b00000000;
		joint[4:0] = 5'b00000;
		//count[3:0] = 4'b0000;
	end

	else if (BOTREDtemp != 4'b1010) begin
		joint = increment + score[3:0];
		score[3:0] = joint[3:0];
		correction = joint[4] | joint[3] & joint[2] | joint[3] & joint[1];
		if (correction == 1'b1) begin
			joint[4:0] = joint[4:0] + 4'b0110; // rectify by adding 6
			score[3:0] = joint[3:0];
			score[7:4] = score[7:4] + 4'b0001; // add carry to 10's digit
		end	
	end

	//count = count + 4'b0001;

	//if (DIS4 == char9) begin

	//	DIS1 = DIS1;
	//	DIS2 = DIS2;
	//	count = count; 
	//end
	
end

always @(score, joint) begin
	//BOTRED[7:4] = score[7:4];
	//BOTRED[3:0] = joint[3:0];
	case(joint[3:0])
		
		4'b0000: DIS1 = char0;
		4'b0001: DIS1 = char1;
		4'b0010: DIS1 = char2;
		4'b0011: DIS1 = char3;
		4'b0100: DIS1 = char4;
		4'b0101: DIS1 = char5;
		4'b0110: DIS1 = char6;
		4'b0111: DIS1 = char7;
		4'b1000: DIS1 = char8;
		4'b1001: DIS1 = char9;
		default: DIS1 = char0; 
	
	endcase

	case(score[7:4])
		
		4'b0000: DIS2 = char0;
		4'b0001: DIS2 = char1;
		4'b0010: DIS2 = char2;
		4'b0011: DIS2 = char3;
		4'b0100: DIS2 = char4;
		4'b0101: DIS2 = char5;
		4'b0110: DIS2 = char6;
		4'b0111: DIS2 = char7;
		4'b1000: DIS2 = char8;
		4'b1001: DIS2 = char9;
		default: DIS2 = char0; 

	endcase

end

// -----------step 5--------------

// -----------step 4--------------

wire ledTemp1;
wire ledTemp2;							// bounceless switches

DFF_BF bounceless_L (.CLK(1'b0), .AR(S2_NC), .AP(S2_NO), .D(1'b0), .BFC(ledTemp1));

DFF_BF bounceless_R (.CLK(1'b0), .AR(S1_NC), .AP(S1_NO), .D(1'b0), .BFC(ledTemp2));

always @ (ledTemp1, ledTemp2) begin
	
	LED_YELLOW_L = ledTemp1;
	LED_YELLOW_R = ledTemp2;
end

wire [3:0] BOTREDtemp;
wire [6:0] DIS4temp; 

rcnt4U fourBitUp_cnt (.CLK(LED_YELLOW_R), .R(LED_YELLOW_L), .Q(BOTREDtemp[3:0]), .DIS(DIS4temp));

always @ (BOTREDtemp, DIS4temp) begin

	BOTRED[3:0] = BOTREDtemp;
	DIS4 = DIS4temp; 
end

// -----------step 4--------------

// -----------step 3--------------

reg [3:0] MIDREDtemp;
wire RST;
reg [3:0] next_MIDREDtemp;
assign RST = LED_YELLOW_L;
reg JUMBO_Gx;
reg JUMBO_Yx;
reg JUMBO_Rx; 

always @ (posedge LED_YELLOW_R, posedge RST) begin
	
	if (RST == 1'b1) begin
		MIDREDtemp[3:0] <= 4'b0000;
	
	end

	else begin 
		MIDREDtemp <= next_MIDREDtemp;
	
	end

end

always @ (MIDREDtemp) begin

	next_MIDREDtemp[3] <= MIDREDtemp[2];
	next_MIDREDtemp[2] <= MIDREDtemp[1];
	next_MIDREDtemp[1] <= MIDREDtemp[0];
	next_MIDREDtemp[0] <= (MIDREDtemp[3] ^ MIDREDtemp[2]) ^ (~(MIDREDtemp[2] | MIDREDtemp[1] | MIDREDtemp[0]));
end

always @ (MIDREDtemp) begin

	if (DIP[7] == 1'b1) begin

		MIDRED = MIDREDtemp;
		MIDRED[7:4] = count;
	
	end

	else begin
		MIDRED = 4'b0000;

	end
end

// -----------step 3--------------

// -----------step 2--------------

wire [7:0] TOPREDtemp;
//wire [3:0] num1;
wire [3:0] num2;

wire [3:0] Cout; 

//assign num1 = DIP[7:4];
assign num2 = DIP[3:0];

cla4compare cla4Bitcompare (.X(MIDREDtemp), .Y(num2), .CIN(1'b1), .S(TOPREDtemp[3:0]), .C(Cout)); // subtraction only

always @ (TOPREDtemp[7:4]) begin
		
	if (TOPREDtemp[7:4] == 4'b1010) begin // C N Z V GREEN LED
		JUMBO_Y = 1'b0;
		JUMBO_G = 1'b1;
		JUMBO_R = 1'b0;
		
	end
	
	else if (TOPREDtemp[7:4] == 4'b0000 || TOPREDtemp[7:4] == 4'b1000 || TOPREDtemp[7:4] == 4'b0101) begin // YELLOW LED
		JUMBO_Y = 1'b1;
		JUMBO_G = 1'b0;
		JUMBO_R = 1'b0;

	end

	else if (TOPREDtemp[7:4] == 4'b0100 || TOPREDtemp[7:4] == 4'b1100 || TOPREDtemp[7:4] == 4'b1001) begin // RED LED
		JUMBO_Y = 1'b0;
		JUMBO_G = 1'b0;
		JUMBO_R = 1'b1;

	end

	else begin				// all off
		JUMBO_Y = 1'b0;
		JUMBO_G = 1'b0;
		JUMBO_R = 1'b0;
	end


end



assign TOPREDtemp[7] = Cout[3];								// CF   
assign TOPREDtemp[6] = TOPREDtemp[3]; 							// NF
assign TOPREDtemp[5] = ~(TOPREDtemp[3] | TOPREDtemp[2] | TOPREDtemp[1] | TOPREDtemp[0]);  //ZF
assign TOPREDtemp[4] = Cout[3] ^ Cout[2];						//VF

always @ (*) begin	
	TOPRED = TOPREDtemp[7:0];

end 

// -----------step 2--------------

// -----------step 1--------------
/*
wire [3:0] num1;
wire [3:0] num2;
wire [7:0] TOPREDtemp;

wire [3:0] Cout; 

assign num1 = DIP[7:4];
assign num2 = DIP[3:0];

wire ledTemp1;
//wire ledTemp2;							
										// switch toggle (+/-)

DFF_BF bounceless_L (.CLK(1'b0), .AR(S2_NC), .AP(S2_NO), .D(1'b0), .BFC(ledTemp1));

//DFF_BF bounceless_R (.CLK(1'b0), .AR(S1_NC), .AP(S1_NO), .D(1'b0), .BFC(ledTemp2));

always @ (ledTemp1, ledTemp2) begin
	
	LED_YELLOW_L = ledTemp1;
	//LED_YELLOW_R = ledTemp2;
end


cla4 cla4Bit (.X(num1), .Y(num2), .CIN(~LED_YELLOW_L), .S(TOPREDtemp[3:0]), .C(Cout)); // addition/subtraction


assign TOPREDtemp[7] = Cout[3];								// CF   
assign TOPREDtemp[6] = TOPREDtemp[3]; 							// NF
assign TOPREDtemp[5] = ~(TOPREDtemp[3] | TOPREDtemp[2] | TOPREDtemp[1] | TOPREDtemp[0]);  //ZF
assign TOPREDtemp[4] = Cout[3] ^ Cout[2];						//VF

always @ (*) begin

	TOPRED = TOPREDtemp[7:0];

end 
*/
// -----------step 1--------------

endmodule 

// -----------functions-----------
module cla4compare(X, Y, CIN, S, C);

	input wire [3:0] X, Y; // Operands
	input wire CIN; // Carry in
	output wire [3:0] S; // Sum outputs

	output wire [3:0] C; // Carry equations (C[3] is Cout)
	wire [3:0] P, G;

	assign G[0] = X[0] & (Y[0] ^ CIN); // Generate functions G[0] = X[0]&Y[0]; G[1] = .. so on
	assign G[1] = X[1] & (Y[1] ^ CIN);
	assign G[2] = X[2] & (Y[2] ^ CIN);
	assign G[3] = X[3] & (Y[3] ^ CIN);
	

	assign P[0] = X[0] ^ (Y[0] ^ CIN); // Propagate functions P[0] = X[0]^Y[0]; P[1] = .. so on
	assign P[1] = X[1] ^ (Y[1] ^ CIN);
	assign P[2] = X[2] ^ (Y[2] ^ CIN);
	assign P[3] = X[3] ^ (Y[3] ^ CIN);

	// Carry function definitions
	
	assign C[0] = G[0] | CIN & P[0];
	assign C[1] = G[1] | G[0] & P[1] | CIN & P[0] & P[1];
	assign C[2] = G[2] | G[1] & P[2] | G[0] & P[1] & P[2] | CIN & P[0] & P[1] & P[2];
	assign C[3] = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3] | CIN & P[0] & P[1] & P[2] & P[3];
	
	assign S[0] = CIN ^ P[0];
	assign S[3:1] = C[2:0] ^ P[3:1];		

	

endmodule

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

module rcnt4U(CLK, R, Q, DIS);

	localparam char1 = 7'b0110000;
	localparam char2 = 7'b1101101;
	localparam char3 = 7'b1111001;
	localparam char4 = 7'b0110011;
	localparam char5 = 7'b1011011;
	localparam char6 = 7'b1011111;
	localparam char7 = 7'b1110000;
	localparam char8 = 7'b1111111;
	localparam char9 = 7'b1111011;

	input wire CLK;
	input wire R;
	output reg [3:0] Q;
	output reg [6:0] DIS; 
	reg [3:0] next_Q;
	

	always @ (posedge CLK, posedge R) begin
	
		Q <= next_Q;
		if (R == 1'b1) begin
			Q <= 4'b0001; // next_Q
			
		end
	end

	always @ (Q) begin
	
		next_Q[0] = ~Q[0];
		next_Q[1] = Q[1] ^ Q[0];
		next_Q[2] = Q[2] ^ (Q[1] & Q[0]);
		next_Q[3] = Q[3] ^ (Q[2] & Q[1] & Q[0]);

		if (Q == 4'b1010) begin
		
			next_Q = Q; 
		end

		case(Q)
			
			4'b0001: DIS = char1;
			4'b0010: DIS = char2; 
			4'b0011: DIS = char3;
			4'b0100: DIS = char4;
			4'b0101: DIS = char5; 
			4'b0110: DIS = char6; 
			4'b0111: DIS = char7; 
			4'b1000: DIS = char8;
			4'b1001: DIS = char9;
			4'b1010: DIS = char9;
			default: DIS = char9;

		endcase
		
	end
	
endmodule

module cla4BCD(X, Y, CIN, S, C);

	input wire [3:0] X, Y; // Operands
	input wire CIN; // Carry in
	output wire [3:0] S; // Sum outputs

	output wire [3:0] C; // Carry equations (C[3] is Cout)
	wire [3:0] P, G;

	assign G[0] = X[0] & (Y[0] ^ CIN); // Generate functions G[0] = X[0]&Y[0]; G[1] = .. so on
	assign G[1] = X[1] & (Y[1] ^ CIN);
	assign G[2] = X[2] & (Y[2] ^ CIN);
	assign G[3] = X[3] & (Y[3] ^ CIN);
	

	assign P[0] = X[0] ^ (Y[0] ^ CIN); // Propagate functions P[0] = X[0]^Y[0]; P[1] = .. so on
	assign P[1] = X[1] ^ (Y[1] ^ CIN);
	assign P[2] = X[2] ^ (Y[2] ^ CIN);
	assign P[3] = X[3] ^ (Y[3] ^ CIN);

	// Carry function definitions
	
	assign C[0] = G[0] | CIN & P[0];
	assign C[1] = G[1] | G[0] & P[1] | CIN & P[0] & P[1];
	assign C[2] = G[2] | G[1] & P[2] | G[0] & P[1] & P[2] | CIN & P[0] & P[1] & P[2];
	assign C[3] = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3] | CIN & P[0] & P[1] & P[2] & P[3];
	
	assign S[0] = CIN ^ P[0];
	assign S[3:1] = C[2:0] ^ P[3:1];		

	

endmodule

module cla4(X, Y, CIN, S, C);

	input wire [3:0] X, Y; // Operands
	input wire CIN; // Carry in
	output wire [3:0] S; // Sum outputs

	output wire [3:0] C; // Carry equations (C[3] is Cout)
	wire [3:0] P, G;

	assign G[0] = X[0] & (Y[0] ^ CIN); // Generate functions G[0] = X[0]&Y[0]; G[1] = .. so on
	assign G[1] = X[1] & (Y[1] ^ CIN);
	assign G[2] = X[2] & (Y[2] ^ CIN);
	assign G[3] = X[3] & (Y[3] ^ CIN);
	

	assign P[0] = X[0] ^ (Y[0] ^ CIN); // Propagate functions P[0] = X[0]^Y[0]; P[1] = .. so on
	assign P[1] = X[1] ^ (Y[1] ^ CIN);
	assign P[2] = X[2] ^ (Y[2] ^ CIN);
	assign P[3] = X[3] ^ (Y[3] ^ CIN);

	// Carry function definitions
	
	assign C[0] = G[0] | CIN & P[0];
	assign C[1] = G[1] | G[0] & P[1] | CIN & P[0] & P[1];
	assign C[2] = G[2] | G[1] & P[2] | G[0] & P[1] & P[2] | CIN & P[0] & P[1] & P[2];
	assign C[3] = G[3] | G[2] & P[3] | G[1] & P[2] & P[3] | G[0] & P[1] & P[2] & P[3] | CIN & P[0] & P[1] & P[2] & P[3];
	
	assign S[0] = CIN ^ P[0];
	assign S[3:1] = C[2:0] ^ P[3:1];		

	

endmodule