module dangd_lab7(inSwitches, nA, nB, nC, nD, nE, nF, nG, nDP);

input wire [7:0] inSwitches /* synthesis loc= "9,8,7,6,5,4,3,2" */;

reg[7:0] abcdefgh; // conditional array

output wire nA /* synthesis loc = "14" */;
output wire nB /* synthesis loc = "15" */;
output wire nC /* synthesis loc = "16" */;
output wire nD /* synthesis loc = "17" */;
output wire nE /* synthesis loc = "18" */;
output wire nF /* synthesis loc = "19" */;
output wire nG /* synthesis loc = "20" */;
output wire nDP /* synthesis loc = "21" */;


always @ (inSwitches) begin
	case(inSwitches)
		8'b00000001 : abcdefgh = 8'b10000000;
		8'b00000010 : abcdefgh = 8'b01000000;
		8'b00000100 : abcdefgh = 8'b00100000;
		8'b00001000 : abcdefgh = 8'b00010000;
		8'b00010000 : abcdefgh = 8'b00001000;
		8'b00100000 : abcdefgh = 8'b00000100;
		8'b01000000 : abcdefgh = 8'b00000010;
		8'b10000000 : abcdefgh = 8'b00000001;
		default: abcdefgh = 8'b00000000;
	endcase
end
assign {nA, nB, nC, nD, nE, nF, nG, nDP} = ~abcdefgh;


endmodule


module dangd_lab7p2(inSwitches, nA, nB, nC, nD, nE, nF, nG, nDP);

input wire [4:0] inSwitches /* synthesis loc="6,5,4,3,2" */;

reg [7:0] abcdefgh; // conditional array

output wire nA /* synthesis loc = "14" */;
output wire nB /* synthesis loc = "15" */;
output wire nC /* synthesis loc = "16" */;
output wire nD /* synthesis loc = "17" */;
output wire nE /* synthesis loc = "18" */;
output wire nF /* synthesis loc = "19" */;
output wire nG /* synthesis loc = "20" */;
output wire nDP /* synthesis loc = "21" */;

always @ (inSwitches) begin
	case(inSwitches)
		5'b00000 : abcdefgh = 8'b11111100; // 0
		5'b00001 : abcdefgh = 8'b01100000; // 1
		5'b00010 : abcdefgh = 8'b11011010; // 2
		5'b00011 : abcdefgh = 8'b11110010; // 3
		5'b00100 : abcdefgh = 8'b01100110; // 4
		5'b00101 : abcdefgh = 8'b10110110; // 5
		5'b00110 : abcdefgh = 8'b10111110; // 6
		5'b00111 : abcdefgh = 8'b11100000; // 7
		5'b01000 : abcdefgh = 8'b11111110; // 8
		5'b01001 : abcdefgh = 8'b11110110; // 9
		5'b01010 : abcdefgh = 8'b11101110; // A
		5'b01011 : abcdefgh = 8'b00111110; // b
		5'b01100 : abcdefgh = 8'b10011100; // C
		5'b01101 : abcdefgh = 8'b01111010; // d
		5'b01110 : abcdefgh = 8'b10011110; // E
		5'b01111 : abcdefgh = 8'b10001110; // F (end of i4 = 0)
		5'b10000 : abcdefgh = 8'b11101111; // A
		5'b10001 : abcdefgh = 8'b00111111; // b
		5'b10010 : abcdefgh = 8'b10011101; // C
		5'b10011 : abcdefgh = 8'b01111011; // d
		5'b10100 : abcdefgh = 8'b10011111; // E
		5'b10101 : abcdefgh = 8'b10001111; // F
		5'b10110 : abcdefgh = 8'b11110111; // g
		5'b10111 : abcdefgh = 8'b01101111; // H
		5'b11000 : abcdefgh = 8'b11111001; // J
		5'b11001 : abcdefgh = 8'b00011101; // L
		5'b11010 : abcdefgh = 8'b00101011; // n
		5'b11011 : abcdefgh = 8'b00111011; // o
		5'b11100 : abcdefgh = 8'b11001111; // P
		5'b11101 : abcdefgh = 8'b00001011; // r
		5'b11110 : abcdefgh = 8'b01111101; // U
		5'b11111 : abcdefgh = 8'b01110111; // y
		default: abcdefgh = 8'b00000000;
	endcase
end
assign {nA, nB, nC, nD, nE, nF, nG, nDP} = ~abcdefgh;


endmodule


module dangd_lab7p3(inSwitches, outSwitches);

input wire [7:0] inSwitches /* synthesis loc="9,8,7,6,5,4,3,2" */;

output wire [7:0] outSwitches /* synthesis loc="14,15,16,17,18,19,20,21" */;

reg [7:0] abcdefgh; // conditional array

always @ (inSwitches) begin
	casez(inSwitches)
		8'b00000001 : abcdefgh = 8'b11101110; // A
		8'b00000011 : abcdefgh = 8'b01100000; // 1 tripped
		8'b000001?1 : abcdefgh = 8'b11011010; // 2 tripped
		8'b00001??1 : abcdefgh = 8'b11110010; // 3 tripped
		8'b0001???1 : abcdefgh = 8'b01100110; // 4 tripped
		8'b001????1 : abcdefgh = 8'b10110110; // 5 tripped
		8'b01?????1 : abcdefgh = 8'b10111110; // 6 tripped
		8'b1??????1 : abcdefgh = 8'b11100000; // 7 tripped
		default: abcdefgh = 8'b01111100; // U
	endcase
end

assign outSwitches = ~abcdefgh;

endmodule
