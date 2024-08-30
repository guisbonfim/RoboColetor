module TOP(
    // Entradas
    Clock50,        // CLOCK_50
    Clock25,        // CLOCK_25
    Reset,          // SW (foi mapeado como Reset)
    Entradas,       // As entradas do robô
    Pino1,
    Pino2,
    Pino3,
    Pino4,
    Pino6,
    Pino9,
    v_sync,         // VGA_VS
    h_sync,         // VGA_HS
    RGB,            // Entrada RGB
    ColunasSprites, // Colunas de Sprites
    LinhasSprites,  // Linhas de Sprites
    Linha,          // Linha atual
    Coluna,         // Coluna atual
    head, left, under, barrier,  // Sensores do robô
    inclk0,         // Clock de entrada

    // Saídas
    Saidas,         // Saídas do robô
    Select,         // Select do Gamepad
    LEDG,           // LEDs verdes
    forward, turn, remove,  // Controles do robô
    blank,          // VGA_BLANK_N
    R, G, B,        // VGA R, G, B
    LinhaOut,       // Linha de saída
    ColunaOut,      // Coluna de saída
    c0, c1          // Saídas do PLL
);

// Mapeamento das entradas
input wire Clock50;
input wire Clock25;
input wire Reset;
input wire [11:0] Entradas;
input wire Pino1, Pino2, Pino3, Pino4, Pino6, Pino9;
input wire v_sync;
input wire h_sync;
input wire [23:0] RGB;
input wire [23:0] ColunasSprites;
input wire [17:0] LinhasSprites;
input wire [9:0] Linha, Coluna;
input wire head, left, under, barrier;
input wire inclk0;

// Mapeamento das saídas
output wire [11:0] Saidas;
output wire Select;
output wire [7:0] LEDG;
output wire forward, turn, remove;
output wire blank;
output wire [7:0] R, G, B;
output wire [9:0] LinhaOut, ColunaOut;
output wire c0, c1;

wire [9:0] SYNTHESIZED_WIRE_2;
wire [23:0] SYNTHESIZED_WIRE_3;
wire [9:0] SYNTHESIZED_WIRE_4;
wire [17:0] SYNTHESIZED_WIRE_5;
wire [23:0] SYNTHESIZED_WIRE_7;
wire SYNTHESIZED_WIRE_15;
wire [11:0] SYNTHESIZED_WIRE_10;

// Atribuições de saídas VGA
assign R = SYNTHESIZED_WIRE_7[23:16];
assign G = SYNTHESIZED_WIRE_7[15:8];
assign B = SYNTHESIZED_WIRE_7[7:0];
assign LinhaOut = SYNTHESIZED_WIRE_4;
assign ColunaOut = SYNTHESIZED_WIRE_2;

// Conexão dos módulos internos
Grafico b2v_inst(
    .Clock50(Clock50),
    .Clock25(Clock25),
    .Reset(Reset),
    .Coluna(SYNTHESIZED_WIRE_2),
    .ColunasSprites(SYNTHESIZED_WIRE_3),
    .Linha(SYNTHESIZED_WIRE_4),
    .LinhasSprites(SYNTHESIZED_WIRE_5),
    .RGB(SYNTHESIZED_WIRE_7)
);

Interface b2v_inst1(
    .Clock(Clock25),
    .Reset(Reset),
    .RGB(SYNTHESIZED_WIRE_7),
    .v_sync(SYNTHESIZED_WIRE_15),
    .h_sync(h_sync),
    .blank(blank),
    .B(RGB[7:0]),
    .ColunaOut(SYNTHESIZED_WIRE_2),
    .G(RGB[15:8]),
    .LinhaOut(SYNTHESIZED_WIRE_4),
    .R(RGB[23:16])
);

TemporizadorEntradas b2v_inst4(
    .Clock50(Clock50),
    .Reset(Reset),
    .v_sync(SYNTHESIZED_WIRE_15),
    .Entradas(Saidas),
    .ColunasSprites(SYNTHESIZED_WIRE_3),
    .LEDG(LEDG),
    .LinhasSprites(SYNTHESIZED_WIRE_5)
);

Gamepad b2v_inst7(
    .Clock50(Clock50),
    .Reset(Reset),
    .Pino1(Pino1),
    .Pino2(Pino2),
    .Pino3(Pino3),
    .Pino4(Pino4),
    .Pino6(Pino6),
    .Pino9(Pino9),
    .v_sync(SYNTHESIZED_WIRE_15),
    .Select(Select),
    .Saidas(SYNTHESIZED_WIRE_10)
);

endmodule
