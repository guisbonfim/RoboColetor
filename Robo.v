module Robo(input clock, input reset, input head, input left, input under, input barrier, output reg forward, output reg turn, output reg remove);

    // Registrador de estado
    reg [6:0] estado_atual = 7'b1000000;
    reg [6:0] estado_futuro = 7'b0000001;
    
    // Codificacao dos estados    
    parameter inicial = 7'b0000001,
              avancando = 7'b0000010,
              removendo = 7'b0000100,
              rotacionando_um = 7'b0001000,
              rotacionando_dois = 7'b0010000,
              standby = 7'b0100000,
              state_fetch = 7'b1000000;
    
    // Primeiro procedimento - Decodificador de próximo estado
    always @(negedge clock, negedge reset) begin
        if (reset) begin
            estado_atual = inicial; // Se o reset for igual a zero volta para o estado inicial
        end 
        else begin
            estado_atual = estado_futuro;
        end
    end
    
    // Segundo Procedimento - Atualização das saídas
    always @(estado_atual, head, left, under, barrier) begin
        case (estado_atual)
            inicial: begin
                case ({head, left, under, barrier})
                    4'b0010: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
			            estado_futuro = rotacionando_dois;
                    end
                    4'b0011: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0110: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0111: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b1010: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_dois;
                    end
                    4'b1110: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end

                    default: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = standby;
                    end

                endcase
            end

            avancando: begin
                case ({head, left, under, barrier})
                    4'b0000: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_dois;
                    end
                    4'b0001: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0100: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0101: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b1000: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_dois;
                    end
                    4'b1100: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end

                    default: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = standby;
                    end
                endcase
            end

            removendo: begin
                case ({head, left, under, barrier})
                    4'b0000: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0001: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0010:begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0011: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0100: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0101: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0110: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0111: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end

                    default: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = standby;
                    end
                endcase
            end

            rotacionando_um: begin
                case ({head, left, under, barrier})
                    4'b0000: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end
                    4'b0001: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0100: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0101: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b1000: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end
                    4'b0010: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end
                    4'b1100: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end
                    4'b1110: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end
                    4'b1010: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = rotacionando_um;
                    end
                    4'b0110: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end

                    default: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = standby;
                    end
                endcase
            end

            rotacionando_dois: begin
                case ({head, left, under, barrier})
                    4'b0000: begin
                        forward = 1'b0;
                        turn = 1'b1;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end
                    4'b0001: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b1;
                        estado_futuro = removendo;
                    end
                    4'b0010: begin
                        forward = 1'b1;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = avancando;
                    end

                    default: begin
                        forward = 1'b0;
                        turn = 1'b0;
                        remove = 1'b0;
                        estado_futuro = standby;
                    end
                endcase
            end

            standby: begin
                forward = 1'b0;
                turn = 1'b0;
                remove = 1'b0;
                estado_futuro = standby;
            end
        endcase
    end
    
endmodule
