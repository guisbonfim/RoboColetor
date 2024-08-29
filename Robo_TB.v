`timescale 1ns/1ns

module Robo_TB;

parameter N = 2'b00, S = 2'b01, L = 2'b10, O = 2'b11;

reg clock, reset, head, left, under, barrier;
wire forward, turn, remove;

reg [0:59] Mapa [0:10]; // linha 0 reservada para posicao do robo e quantidade de movimentos
reg [0:59] Linha_Mapa;
reg [0:59] Linha_Atual;
reg [0:14] Linha_Robo;
reg [0:14] Coluna_Robo;
reg [0:5] Orientacao_Robo; 
reg [0:23] Qtd_Movimentos;
reg [0:47] String_Orientacao_Robo;
reg [0:0] primeiro_bit;
reg [0:0] segundo_bit;
reg [0:0] terceiro_bit;

integer i;

Robo DUV (.clock(clock), .reset(reset), .head(head), .left(left), .under(under), .barrier(barrier), .forward(forward), .turn(turn), .remove(remove));

always
	#50 clock = !clock;

initial
begin
	clock = 0;
	reset = 0;
	head = 0;
	left = 1;
	under = 1;
	barrier = 0;

	Mapa[0]  = 60'b000000000001010000000000000001000000000000000000000100000000;
	Mapa[1]  = 60'b001001001001001001001001001000000100000000000001001001001001;
	Mapa[2]  = 60'b001001001001001001001001001000001001001001000001001001001001;
	Mapa[3]  = 60'b001001001001001000001001001000001001001001000000000000000000;
	Mapa[4]  = 60'b001001001001001000000000000000001001001001001001001001001001;
	Mapa[5]  = 60'b001001001001001000001001001000001001001001001001000000000000;
	Mapa[6]  = 60'b001001001001001011001001001000001001001000000000000001001001;
	Mapa[7]  = 60'b000000000000000000001001001000000000000000001001001001001001;
	Mapa[8]  = 60'b000001001001001000000000001001001001001000001010000000010000;
	Mapa[9]  = 60'b000001001001001001001100001001001001001000001001001000001001;
	Mapa[10]  = 60'b111001001001001000000000000000000000001000000000000000001001;

	Linha_Mapa = Mapa[0];
	Linha_Robo = Linha_Mapa[0:14];
	Coluna_Robo = Linha_Mapa[15:29];
	Orientacao_Robo = Linha_Mapa[30:35];
	Qtd_Movimentos = Linha_Mapa[36:59];
	$display ("Linha = %d Coluna = %d Orientacao = %s Movimentos = %d", Linha_Robo, Coluna_Robo, String_Orientacao_Robo, Qtd_Movimentos);

    // Mapa fica salvo no reg mapa, depois que remover alterar valor dele pode fazer uma funcao

	if (Situacoes_Anomalas(1)) $stop;
	
	for (i = 0; i < Qtd_Movimentos; i = i + 1)
	begin
		@ (negedge clock);
		Define_Sensores;
		$display ("H = %b L = %b U = %b B = %b", head, left, under, barrier);
		#1;
		Atualiza_Posicao_Robo;
		case (Orientacao_Robo)
			N: begin
				String_Orientacao_Robo = "Norte";
				Linha_Mapa = Mapa[Linha_Robo - 1];				
					
				primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
				segundo_bit = Linha_Mapa[Coluna_Robo];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

				Muda_Codigo_Entulho (primeiro_bit, segundo_bit, terceiro_bit);
			end

			S: begin
				String_Orientacao_Robo = "Sul  ";
				Linha_Mapa = Mapa[Linha_Robo + 1];
										
				primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
				segundo_bit = Linha_Mapa[Coluna_Robo];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

				Muda_Codigo_Entulho (primeiro_bit, segundo_bit, terceiro_bit);
			end

			L: begin
				String_Orientacao_Robo = "Leste";
				Linha_Mapa = Mapa[Linha_Robo];
					
				primeiro_bit = Linha_Mapa[Coluna_Robo + 2];
				segundo_bit = Linha_Mapa[Coluna_Robo + 3];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 4];

				Muda_Codigo_Entulho (primeiro_bit, segundo_bit, terceiro_bit);
			end

			O: begin
				String_Orientacao_Robo = "Oeste";
				Linha_Mapa = Mapa[Linha_Robo];
					
				primeiro_bit = Linha_Mapa[Coluna_Robo - 4];
				segundo_bit = Linha_Mapa[Coluna_Robo - 3];
				terceiro_bit = Linha_Mapa[Coluna_Robo - 2];
			
				Muda_Codigo_Entulho (primeiro_bit, segundo_bit, terceiro_bit);
			end
		endcase
		$display ("Linha = %d Coluna = %d Orientacao = %s", Linha_Robo, Coluna_Robo, String_Orientacao_Robo);
		if (Situacoes_Anomalas(1)) $stop;
	end

	#50 $stop;
end


task Muda_Codigo_Entulho (input bit_um, input bit_dois, input bit_tres);
begin
	if (Orientacao_Robo == N)
	begin
		if ((bit_um == 1) && ( bit_dois == 0) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 011
			Mapa[Linha_Robo - 1][Coluna_Robo - 1] = 0;
			Mapa[Linha_Robo - 1][Coluna_Robo] = 1;
			Mapa[Linha_Robo - 1][Coluna_Robo + 1] = 1;

		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 1))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 010
			Mapa[Linha_Robo - 1][Coluna_Robo - 1] = 0;
			Mapa[Linha_Robo - 1][Coluna_Robo] = 1;
			Mapa[Linha_Robo - 1][Coluna_Robo + 1] = 0;
		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 000
			Mapa[Linha_Robo - 1][Coluna_Robo - 1] = 0;
			Mapa[Linha_Robo - 1][Coluna_Robo] = 0;
			Mapa[Linha_Robo - 1][Coluna_Robo + 1] = 0;
		end
	end
	
	else if (Orientacao_Robo == S)
	begin
		if ((bit_um == 1) && ( bit_dois == 0) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 011
			Mapa[Linha_Robo + 1][Coluna_Robo - 1] = 0;
			Mapa[Linha_Robo + 1][Coluna_Robo] = 1;
			Mapa[Linha_Robo + 1][Coluna_Robo + 1] = 1;

		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 1))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 010
			Mapa[Linha_Robo + 1][Coluna_Robo - 1] = 0;
			Mapa[Linha_Robo + 1][Coluna_Robo] = 1;
			Mapa[Linha_Robo + 1][Coluna_Robo + 1] = 0;
		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 000
			Mapa[Linha_Robo + 1][Coluna_Robo - 1] = 0;
			Mapa[Linha_Robo + 1][Coluna_Robo] = 0;
			Mapa[Linha_Robo + 1][Coluna_Robo + 1] = 0;
		end
	end

	else if (Orientacao_Robo == L)
	begin
		if ((bit_um == 1) && ( bit_dois == 0) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 011
			Mapa[Linha_Robo][Coluna_Robo + 2] = 0;
			Mapa[Linha_Robo][Coluna_Robo + 3] = 1;
			Mapa[Linha_Robo][Coluna_Robo + 4] = 1;

		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 1))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 010
			Mapa[Linha_Robo][Coluna_Robo + 2] = 0;
			Mapa[Linha_Robo][Coluna_Robo + 3] = 1;
			Mapa[Linha_Robo][Coluna_Robo + 4] = 0;
		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 000
			Mapa[Linha_Robo][Coluna_Robo + 2] = 0;
			Mapa[Linha_Robo][Coluna_Robo + 3] = 0;
			Mapa[Linha_Robo][Coluna_Robo + 4] = 0;
		end
	end

	else
	begin
		if ((bit_um == 1) && ( bit_dois == 0) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 011
			Mapa[Linha_Robo][Coluna_Robo - 2] = 0;
			Mapa[Linha_Robo][Coluna_Robo - 3] = 1;
			Mapa[Linha_Robo][Coluna_Robo - 4] = 1;

		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 1))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 010
			Mapa[Linha_Robo][Coluna_Robo - 2] = 0;
			Mapa[Linha_Robo][Coluna_Robo - 3] = 1;
			Mapa[Linha_Robo][Coluna_Robo - 4] = 0;
		end
		else if ((bit_um == 0) && ( bit_dois == 1) && (bit_tres == 0))
		begin
			// Mudar mapa Mapa[x][y] para prox codigo -> 000
			Mapa[Linha_Robo][Coluna_Robo - 2] = 0;
			Mapa[Linha_Robo][Coluna_Robo - 3] = 0;
			Mapa[Linha_Robo][Coluna_Robo - 4] = 0;
		end
	end	
end
endtask


function Situacoes_Anomalas (input X);
begin
	Situacoes_Anomalas = 0;
	if ( (Linha_Robo < 1) || (Linha_Robo > 10) || (Coluna_Robo < 1) || (Coluna_Robo > 58) ) // O tb percorre o mapa de 3 em 3
		Situacoes_Anomalas = 1;
end
endfunction

task Define_Sensores;
begin
	case (Orientacao_Robo)
		N:	begin
				// definicao de head
				if (Linha_Robo == 1) // Se igual a um quer dizer que ele tá no mais em cima possível, por isso é 1 no head
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo - 1]; // Pega a linha que tá acima da cabeça do robo					
					
					primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
					segundo_bit = Linha_Mapa[Coluna_Robo];
					terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

					$display ("Linha = %b", Linha_Mapa);

                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        head = 1;
                    end
                    else
                    begin
                        head = 0;
                    end

                    if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
					else if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 1))
                    begin
                        barrier = 1;
                    end
                    else if ((primeiro_bit == 1) && ( segundo_bit == 0) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
                    else
                    begin
                        barrier = 0;
                    end
				end				

				// definicao de left
				if (Coluna_Robo == 1)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					
					primeiro_bit = Linha_Mapa[Coluna_Robo - 4];
					segundo_bit = Linha_Mapa[Coluna_Robo - 3];
					terceiro_bit = Linha_Mapa[Coluna_Robo - 2];
					
					$display ("Linha = %b", Linha_Mapa);

					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        left = 1;
                    end
                    else
                    begin
                        left = 0;
                    end
				end

				// definicao do under
				Linha_Mapa = Mapa[Linha_Robo]; // -1 N deveria ta ai, mas funcionou assim

				primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
				segundo_bit = Linha_Mapa[Coluna_Robo];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

				if ((primeiro_bit == 1) && ( segundo_bit == 1) && (terceiro_bit == 1))
					under = 1;
				else
				begin
					under = 0;
				end

			end
		S:	begin
				// definicao de head
				if (Linha_Robo == 10)// Se igual a 10 quer dizer que ele tá no mais em baixo possível, por isso é 1 no head
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo + 1];
										
					primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
					segundo_bit = Linha_Mapa[Coluna_Robo];
					terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

					$display ("Linha = %b", Linha_Mapa);
					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        head = 1;
                    end
                    else
                    begin
                        head = 0;
                    end

                    if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
					else if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 1))
                    begin
                        barrier = 1;
                    end
                    else if ((primeiro_bit == 1) && ( segundo_bit == 0) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
                    else
                    begin
                        barrier = 0;
                    end                    
				end

				// definicao de left
				if (Coluna_Robo == 58)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					
					primeiro_bit = Linha_Mapa[Coluna_Robo + 2];
					segundo_bit = Linha_Mapa[Coluna_Robo + 3];
					terceiro_bit = Linha_Mapa[Coluna_Robo + 4];
					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        left = 1;
                    end
                    else
                    begin
                        left = 0;
                    end
				end

				// definicao do under
				Linha_Mapa = Mapa[Linha_Robo];

				primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
				segundo_bit = Linha_Mapa[Coluna_Robo];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

				if ((primeiro_bit == 1) && ( segundo_bit == 1) && (terceiro_bit == 1))
                begin
					under = 1;
                end
				else
				begin
					under = 0;
				end
			end
		L:	begin
				// definicao de head
				if (Coluna_Robo == 58)
					head = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					
					primeiro_bit = Linha_Mapa[Coluna_Robo + 2];
					segundo_bit = Linha_Mapa[Coluna_Robo + 3];
					terceiro_bit = Linha_Mapa[Coluna_Robo + 4];

					$display ("Linha = %b", Linha_Mapa);
					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        head = 1;
                    end
                    else
                    begin
                        head = 0;
                    end					
                    if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
					else if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 1))
                    begin
                        barrier = 1;
                    end
                    else if ((primeiro_bit == 1) && ( segundo_bit == 0) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
                    else
                    begin
                        barrier = 0;
                    end            
				end

				// definicao de left
				if (Linha_Robo == 1)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo - 1];
					
					primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
					segundo_bit = Linha_Mapa[Coluna_Robo];
					terceiro_bit = Linha_Mapa[Coluna_Robo + 1];
					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        left = 1;
                    end
                    else
                    begin
                        left = 0;
                    end
				end

				// definicao do under
				Linha_Mapa = Mapa[Linha_Robo];

				primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
				segundo_bit = Linha_Mapa[Coluna_Robo];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

				if ((primeiro_bit == 1) && ( segundo_bit == 1) && (terceiro_bit == 1))
                begin
					under = 1;
                end
				else
				begin
					under = 0;
				end
			end
		O:	begin
				// definicao de head
				if (Coluna_Robo == 1)
					begin
					head = 1;
					Linha_Mapa = Mapa[Linha_Robo];
					$display ("Linha = %b", Linha_Mapa);
					end
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo];
					
					primeiro_bit = Linha_Mapa[Coluna_Robo - 4];
					segundo_bit = Linha_Mapa[Coluna_Robo - 3];
					terceiro_bit = Linha_Mapa[Coluna_Robo - 2];

					$display ("Linha = %b", Linha_Mapa);
					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        head = 1;
                    end
                    else
                    begin
                        head = 0;
                    end

                    if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
					else if ((primeiro_bit == 0) && ( segundo_bit == 1) && (terceiro_bit == 1))
                    begin
                        barrier = 1;
                    end
                    else if ((primeiro_bit == 1) && ( segundo_bit == 0) && (terceiro_bit == 0))
                    begin
                        barrier = 1;
                    end
                    else
                    begin
                        barrier = 0;
                    end             
				end

				// definicao de left
				if (Linha_Robo == 10)
					left = 1;
				else
				begin
					Linha_Mapa = Mapa[Linha_Robo + 1]; // Pega a linha que tá acima da cabeça do robo
					
					primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
					segundo_bit = Linha_Mapa[Coluna_Robo];
					terceiro_bit = Linha_Mapa[Coluna_Robo + 1];
					
                    if ((primeiro_bit == 0) && ( segundo_bit == 0) && (terceiro_bit == 1))
                    begin
                        left = 1;
                    end
                    else
                    begin
                        left = 0;
                    end
				end

				// definicao do under
				Linha_Mapa = Mapa[Linha_Robo];

				primeiro_bit = Linha_Mapa[Coluna_Robo - 1];
				segundo_bit = Linha_Mapa[Coluna_Robo];
				terceiro_bit = Linha_Mapa[Coluna_Robo + 1];

				if ((primeiro_bit == 1) && ( segundo_bit == 1) && (terceiro_bit == 1))
                begin
					under = 1;
                end
				else
				begin
					under = 0;
				end
			end
	endcase
end
endtask

task Atualiza_Posicao_Robo;
begin
	case (Orientacao_Robo)
		N:	begin
				// definicao de orientacao / linha / coluna
				if (forward)
				begin
					Linha_Robo = Linha_Robo - 1;
				end
				else if (turn)
				begin
					Orientacao_Robo = O;
				end
				else if (remove)
				begin
					Orientacao_Robo = N;					
				end
			end
		S:	begin
				// definicao de orientacao / linha / coluna
				if (forward)
				begin
					Linha_Robo = Linha_Robo + 1;
				end
				else if (turn)
				begin
					Orientacao_Robo = L;
				end
				else if (remove)
				begin
					Orientacao_Robo = S;					
				end
			end
		L:	begin
				// definicao de orientacao / linha / coluna
				if (forward)
				begin
					Coluna_Robo = Coluna_Robo + 3;
				end
				else if (turn)
				begin
					Orientacao_Robo = N;
				end
				else if (remove)
				begin
					Orientacao_Robo = L;					
				end
			end
		O:	begin
				// definicao de orientacao / linha / coluna
				if (forward)
				begin
					Coluna_Robo = Coluna_Robo - 3;
				end
				else if (turn)
				begin
					Orientacao_Robo = S;
				end
				else if (remove)
				begin
					Orientacao_Robo = O;					
				end
			end
	endcase
end
endtask

endmodule



