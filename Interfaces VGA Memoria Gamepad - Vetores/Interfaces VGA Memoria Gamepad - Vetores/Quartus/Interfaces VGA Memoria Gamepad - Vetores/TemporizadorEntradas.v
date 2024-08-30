module TemporizadorEntradas (Clock50, Reset, Entradas, v_sync, ColunasSprites, LinhasSprites, LEDG);

input Clock50, Reset, v_sync;
input [11:0] Entradas;
output reg [23:0] ColunasSprites;
output reg [17:0] LinhasSprites;
output reg [7:0] LEDG;

// Posicao de Sprites
reg [3:0] ColunaCelulaPreta;
reg [3:0] ColunaLixo1;
reg [3:0] ColunaLixo2;
reg [3:0] ColunaLixo3;
reg [3:0] ColunaRobo;
reg [3:0] ColunaCursor;

reg [2:0] LinhaCelulaPreta;
reg [2:0] LinhaLixo1;
reg [2:0] LinhaLixo2;
reg [2:0] LinhaLixo3;
reg [2:0] LinhaRobo;
reg [2:0] LinhaCursor;

reg [5:0] ContadorFrames;
reg HabilitaNovaLeitura;

// Flag baseado na deteccao de borda de subida de v_sync

reg v_sync_Primeiro_FlipFLop, v_sync_Segundo_FlipFLop;
wire Flag;

always @(negedge Clock50)
begin
	v_sync_Primeiro_FlipFLop <= v_sync;
	v_sync_Segundo_FlipFLop <= v_sync_Primeiro_FlipFLop;
end

assign Flag = v_sync_Primeiro_FlipFLop && !v_sync_Segundo_FlipFLop;

always @(posedge Clock50)
begin
	if (Reset)
	begin		
		ColunaCelulaPreta <= 1;
		ColunaLixo1 <= 6;
		ColunaLixo2 <= 10;
		ColunaLixo3 <= 1;
		ColunaRobo <= 1;
		ColunaCursor <= 6;
		
		LinhaCelulaPreta <= 5;		
		LinhaLixo1 <= 3;		
		LinhaLixo2 <= 5;		
		LinhaLixo3 <= 2;		
		LinhaRobo <= 5;		
		LinhaCursor <= 3;
		
		HabilitaNovaLeitura = 1;
		LEDG <= 8'b00010000;
	end
	
	if (HabilitaNovaLeitura && Flag)
	begin
		HabilitaNovaLeitura <= 0;
		ContadorFrames <= 0;		
		
		// Tratamento de entradas do gamepad
		// Entradas[11] = Saida_Mode
		// Entradas[10] = Saida_Start
		// Entradas[9] = Saida_Z
		// Entradas[8] = Saida_Y
		// Entradas[7] = Saida_X
		// Entradas[6] = Saida_C
		// Entradas[5] = Saida_B
		// Entradas[4] = Saida_A
		// Entradas[3] = Saida_Right
		// Entradas[2] = Saida_Left
		// Entradas[1] = Saida_Down
		// Entradas[0] = Saida_Up 
		
		if (Entradas[4])
		begin
			ColunaRobo <= ColunaCursor;
			LinhaRobo <= LinhaCursor;
		end

		if (Entradas[0])
		begin
			if (LinhaCursor == 1)
			begin
				LinhaCursor <= 5;
			end
			else
			begin
				LinhaCursor <= LinhaCursor - 1;
			end
		end
		
		if (Entradas[1])
		begin
			if (LinhaCursor == 5)
			begin
				LinhaCursor <= 1;
			end
			else
			begin
				LinhaCursor <= LinhaCursor + 1;
			end
		end
		
		if (Entradas[2])
		begin
			if (ColunaCursor == 1)
			begin
				ColunaCursor <= 10;
			end
			else
			begin
				ColunaCursor <= ColunaCursor - 1;
			end
			if (LEDG == 8'b10000000 || LEDG == 8'b00000000)
			begin
				LEDG <= 8'b00000001;
			end
			else 
			begin
				LEDG <= LEDG << 1;
			end
		end
		
		if (Entradas[3])
		begin
			if (ColunaCursor == 10)
			begin
				ColunaCursor <= 1;
			end
			else
			begin
				ColunaCursor <= ColunaCursor + 1;
			end
			if (LEDG == 8'b00000001 || LEDG == 8'b00000000)
			begin
				LEDG <= 8'b10000000;
			end
			else 
			begin
				LEDG <= LEDG >> 1;
			end
		end		
	end
	
	if (Flag)
	begin
		if (ContadorFrames == 4)
		begin
			HabilitaNovaLeitura <= 1;
			ContadorFrames <= 0;
		end
		else
		begin
			ContadorFrames <= ContadorFrames + 1;	
		end	
	end	
end

always @(negedge Clock50)
begin
		ColunasSprites <= {ColunaCelulaPreta, ColunaLixo1, ColunaLixo2, ColunaLixo3, ColunaRobo, ColunaCursor};
		LinhasSprites <= {LinhaCelulaPreta, LinhaLixo1, LinhaLixo2, LinhaLixo3, LinhaRobo, LinhaCursor};
end

endmodule 