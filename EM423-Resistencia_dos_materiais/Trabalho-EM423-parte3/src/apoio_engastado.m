function apoio_engastado(comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, forcas_pontuais, carregamentos_dist, torque_x, momento_z, d, D)
    apoio_forca = [0, 0];
    apoio_torque_x = 0;
    apoio_momento_z = 0;

    for i = 1:rows(forcas_pontuais)
        apoio_forca -= forcas_pontuais(i, 2:end);
        apoio_momento_z -= forcas_pontuais(i, 3) * forcas_pontuais(i, 1);
    endfor

    for i = 1:size(carregamentos_dist)
        [forca, pos] = carga_distribuida(carregamentos_dist{i}(1), carregamentos_dist{i}(2), carregamentos_dist{i}(3:end));
        apoio_forca(2) += forca;
        apoio_momento_z += forca * pos;
    endfor

    for i = 1:rows(torque_x)
        apoio_torque_x -= torque_x(i, 2);
    endfor

    for i = 1:rows(momento_z)
        apoio_forca(2) += momento_z(i, 2) / comprimento;
        apoio_momento_z -= momento_z(i, 2);
    endfor

    forcas_pontuais_2 = [forcas_pontuais; 0, apoio_forca];
    torque_x_2 = [torque_x; 0, apoio_torque_x];
    momento_z_2 = [momento_z; 0, apoio_momento_z];

    # Calcular constante de integração, considerando que no apoio t = 0
    c3 = -inclinacao(0, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z_2);
    # Calcular constante de integração, considerando que no apoio v = 0
    c4 = -deflexao(0, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z_2, c3);

    while true
        clc;

        fprintf("Reacoes de apoio:\n");
        fprintf("\tForca em X: %f N\n", apoio_forca(1));
        fprintf("\tForca em Y: %f N\n", apoio_forca(2));
        fprintf("\tTorque em X: %f Nm\n", apoio_torque_x);
        fprintf("\tMomento em Z: %f Nm\n", apoio_momento_z);

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
            plot(x, momento_fletor(x, forcas_pontuais_2, carregamentos_dist, momento_z_2));
            axis("ij");
        case 4
            figure;
            plot(x, momento_torsor(x, torque_x_2));
        case 5
            figure;
            t = inclinacao(x, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z_2) + c3;
            plot(x, t);
        case 6
            figure;
            v = deflexao(x, modulo_young, iz, forcas_pontuais_2, carregamentos_dist, momento_z_2, c3) + c4;
            plot(x, v);
        case 7
            c5 = -angulo_de_torcao(0, torque_x_2, modulo_cisalhamento, iz, iy);
            T = angulo_de_torcao(x, torque_x_2, modulo_cisalhamento, iz, iy) + c5;
            plot(x, T);
        case 8
            c6 = -alongamento(0, forcas_pontuais_2, modulo_cisalhamento, area);
            L = alongamento(x, forcas_pontuais_2, modulo_cisalhamento, area) + c6;
            plot(x, L);
        case 9
            obter_tensoes(iz, iy, area, forcas_pontuais_2, carregamentos_dist, torque_x_2, momento_z_2, d / 2, D / 2, modulo_young, modulo_cisalhamento);
        endswitch
    endwhile
endfunction
