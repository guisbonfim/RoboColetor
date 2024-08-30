// Copyright (C) 2018  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 18.1.0 Build 625 09/12/2018 SJ Lite Edition"
// CREATED		"Mon Aug 19 02:16:37 2024"

module TOP(
	CLOCK_50,
	CLOCK_25,
	Pino1,
	Pino2,
	Pino3,
	Pino4,
	Pino6,
	Pino9,
	SW,
	VGA_VS,
	VGA_HS,
	VGA_BLANK_N,
	VGA_CLK,
	Select,
	ColunasSprites,
	LEDG,
	LEDR,
	LinhasSprites,
	VGA_B,
	VGA_G,
	VGA_R
);


input wire	CLOCK_50;
input wire	CLOCK_25;
input wire	Pino1;
input wire	Pino2;
input wire	Pino3;
input wire	Pino4;
input wire	Pino6;
input wire	Pino9;
input wire	[17:17] SW;
output wire	VGA_VS;
output wire	VGA_HS;
output wire	VGA_BLANK_N;
output wire	VGA_CLK;
output wire	Select;
output wire	[23:0] ColunasSprites;
output wire	[7:0] LEDG;
output wire	[11:0] LEDR;
output wire	[17:0] LinhasSprites;
output wire	[7:0] VGA_B;
output wire	[7:0] VGA_G;
output wire	[7:0] VGA_R;

wire	[9:0] SYNTHESIZED_WIRE_2;
wire	[23:0] SYNTHESIZED_WIRE_3;
wire	[9:0] SYNTHESIZED_WIRE_4;
wire	[17:0] SYNTHESIZED_WIRE_5;
wire	[23:0] SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_15;
wire	[11:0] SYNTHESIZED_WIRE_10;

assign	VGA_VS = SYNTHESIZED_WIRE_15;
assign	VGA_CLK = CLOCK_25;
assign	ColunasSprites = SYNTHESIZED_WIRE_3;
assign	LEDR = SYNTHESIZED_WIRE_10;
assign	LinhasSprites = SYNTHESIZED_WIRE_5;

Grafico	b2v_inst(
	.Clock50(CLOCK_50),
	.Clock25(CLOCK_25),
	.Reset(SW),
	.Coluna(SYNTHESIZED_WIRE_2),
	.ColunasSprites(SYNTHESIZED_WIRE_3),
	.Linha(SYNTHESIZED_WIRE_4),
	.LinhasSprites(SYNTHESIZED_WIRE_5),
	.RGB(SYNTHESIZED_WIRE_7));


Interface	b2v_inst1(
	.Clock(CLOCK_25),
	.Reset(SW),
	.RGB(SYNTHESIZED_WIRE_7),
	.v_sync(SYNTHESIZED_WIRE_15),
	.h_sync(VGA_HS),
	.blank(VGA_BLANK_N),
	.B(VGA_B),
	.ColunaOut(SYNTHESIZED_WIRE_2),
	.G(VGA_G),
	.LinhaOut(SYNTHESIZED_WIRE_4),
	.R(VGA_R));


TemporizadorEntradas	b2v_inst4(
	.Clock50(CLOCK_50),
	.Reset(SW),
	.v_sync(SYNTHESIZED_WIRE_15),
	.Entradas(SYNTHESIZED_WIRE_10),
	.ColunasSprites(SYNTHESIZED_WIRE_3),
	.LEDG(LEDG),
	.LinhasSprites(SYNTHESIZED_WIRE_5));


Gamepad	b2v_inst7(
	.Clock50(CLOCK_50),
	.Reset(SW),
	.Pino1(Pino1),
	.Pino2(Pino2),
	.Pino3(Pino3),
	.Pino4(Pino4),
	.Pino6(Pino6),
	.Pino9(Pino9),
	.v_sync(SYNTHESIZED_WIRE_15),
	.Select(Select),
	.Saidas(SYNTHESIZED_WIRE_10));

endmodule
