function apoio_pino(comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, forcas_pontuais, carregamentos_dist, torque_x, momento_z, pospino, posrolete, d, D)
    apoio1_forca = [0, 0]; #apoio pino
    apoio1_torque_x = 0;
    apoio2_forca_y = 0; #apoio rolete

    soma_fy = 0;
    soma_mz = 0;
    for i = 1:rows(forcas_pontuais)
        soma_fy += forcas_pontuais(i, 3);
        soma_mz += forcas_pontuais(i, 3) * forcas_pontuais(i, 1);
        apoio1_forca -= [forcas_pontuais(i, 2), 0];
    endfor

    for i = 1:size(carregamentos_dist)
        [forca, pos] = carga_distribuida(carregamentos_dist{i}(1), carregamentos_dist{i}(2), carregamentos_dist{i}(3:end));
        soma_fy -= forca;
        soma_mz -= forca * pos;
    endfor

    for i = 1:rows(torque_x)
        apoio1_torque_x -= torque_x(i, 2);
    endfor

    for i = 1:rows(momento_z)
        soma_fy += momento_z(i, 2) / comprimento;
        soma_mz += momento_z(i, 2);
    endfor

    apoio2_forca_y = ((soma_fy * pospino) - soma_mz) / (posrolete - pospino);
    apoio1_forca(2) = -(soma_fy + apoio2_forca_y);

    forcas_pontuais_2 = [forcas_pontuais; pospino, apoio1_forca; posrolete, 0, apoio2_forca_y];
    torque_x_2 = [torque_x; pospino, apoio1_torque_x];

    # Calcular constantes de integração, considerando que nos apoios v = 0
    # r0 = c4 + posrolete * c3 e r1 = c4 + pospino * c3
    r0 = -deflexao(posrolete, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z, 0);
    r1 = -deflexao(pospino, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z, 0);
    c3 = (r0 - r1) / (pospino - posrolete);
    c4 = r0 - posrolete * c3;

    while true
        clc;

        fprintf("Reacoes de apoio:\n");
        fprintf("\tForca em X no apoio pino: %f N\n", apoio1_forca(1));
        fprintf("\tForca em Y no apoio pino: %f N\n", apoio1_forca(2));
        fprintf("\tForca em Y no apoio rolete: %f N\n", apoio2_forca_y);
        fprintf("\tTorque em X no apoio pino: %f Nm\n", apoio1_torque_x);

        fprintf("\nQual operacao realizar?\n"); # o programa dá opções de escolha ao usuário
        fprintf("\t0 - Voltar\n");
        fprintf("\t1 - Diagrama de esforco normal\n");
        fprintf("\t2 - Diagrama de esforco cortante\n");
        fprintf("\t3 - Diagrama de momento fletor\n");
        fprintf("\t4 - Diagrama de torque torsor\n");
        fprintf("\t5 - Grafico de inclinacao\n");
        fprintf("\t6 - Grafico de deflexao\n");
        fprintf("\t7 - Grafico do angulo de torcao\n");
        fprintf("\t8 - Grafico do alongamento\n");
        fprintf("\t9 - Obter tensoes\n");

        x = 0:(comprimento / 1000):comprimento;
        switch input("")
        case 0
            return
        case 1
            figure;
            plot(x, esforco_normal(x, forcas_pontuais_2));
        case 2
            figure;
            plot(x, esforco_cortante(x, forcas_pontuais_2, carregamentos_dist));
        case 3
            figure;
            plot(x, momento_fletor(x, forcas_pontuais_2, carregamentos_dist, momento_z));
            axis("ij");
        case 4
            figure;
            plot(x, momento_torsor(x, torque_x_2));
        case 5
            figure;
            t = inclinacao(x, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z) + c3;
            plot(x, t);
        case 6
            figure;
            v = deflexao(x, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z, c3) + c4;
            plot(x, v);
        case 7
            c5 = -angulo_de_torcao(pospino, torque_x_2, modulo_cisalhamento, iz, iy);
            T = angulo_de_torcao(x, torque_x_2, modulo_cisalhamento, iz, iy) + c5;
            plot(x, T);
        case 8
            c6 = -alongamento(pospino, forcas_pontuais_2, modulo_cisalhamento, area);
            L = alongamento(x, forcas_pontuais_2, modulo_cisalhamento, area) + c6;
            plot(x, L);
        case 9
            obter_tensoes(iz, iy, area, forcas_pontuais_2, carregamentos_dist, torque_x_2, momento_z, d / 2, D / 2, modulo_young, modulo_cisalhamento);
        endswitch
    endwhile
endfunction
