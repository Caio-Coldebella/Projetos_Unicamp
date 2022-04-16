clear;
clc;

[comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, d, D] = propriedades_barra();
forcas_pontuais = []; # Cada linha tem formato [x, Fx, Fy]
carregamentos_dist = {}; # Cada linha tem formato [x_min, x_max, polinomial]
torque_x = []; # Cada linha tem formato [x, T]
momento_z = []; # Cada linha tem formato [x, M]

while true
    clc;

    fprintf("Qual operacao realizar?\n"); # o programa dá opções de escolha ao usuário
    fprintf("\t0 - Reiniciar\n");
    fprintf("\t1 - Finalizar\n");
    fprintf("-----------------------------------------------\n");
    fprintf("\t2 - Adicionar forca pontual\n");
    fprintf("\t3 - Adicionar carregamento distribuido\n");
    fprintf("\t4 - Adicionar torque em X\n");
    fprintf("\t5 - Adicionar momento em Z\n");
    fprintf("\t6 - Calcular apoio engastado (apoio em x = 0)\n");
    fprintf("\t7 - Calcular apoio pino e rolete\n");
    fprintf("\t8 - Calcular dois roletes\n");
    fprintf("\t9 - Alterar propriedades da barra\n");
 
    switch input("")
    case 0 # Reiniciar
        [comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, d, D] = propriedades_barra();
        forcas_pontuais = [];
        carregamentos_dist = {};
        torque_x = [];
        momento_z = [];
    case 1 # Finalizar
        break;
    case 2 # Adicionar forca pontual
        clc;
        x = input("Insira a posicao em m: ");
        fx = input("Insira a componente X em N: ");
        fy = input("Insira a componente Y em N (use valores negativos para cargas): ");
        forcas_pontuais = [forcas_pontuais; x, fx, fy];
    case 3 # Adicionar carregamento distribuido
        clc;
        mini = input("Insira minimo em X do intervalo: ");
        maxi = input("Insira maximo em X do intervalo: ");

        polinomial = input("Insira os coeficientes do carregamento ([1 2 3] se torna x^2 + 2x + 3): ");

        carregamentos_dist{end + 1} = [mini, maxi, polinomial];
    case 4 # Adicionar torque em X
        clc;
        x = input("Insira a posicao em m: ");
        t = input("Insira o torque em Nm: ");

        torque_x = [torque_x; x, t];
    case 5 # adicionar momento em Z
        clc;
        x = input("Insira a posicao em m: ");
        m = input("Insira o momento em Nm: ");

        momento_z = [momento_z; x, m];
    case 6
        apoio_engastado(comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, forcas_pontuais, carregamentos_dist, torque_x, momento_z, d, D);
    case 7
        pospino = input("Insira a posicao do apoio pino: ");
        posrolete = input("Insira a posicao do apoio rolete: ");
        apoio_pino(comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, forcas_pontuais, carregamentos_dist, torque_x, momento_z, pospino, posrolete, d, D);
    case 8
        posrolete1 = input("Insira a posicao do primeiro apoio rolete: ");
        posrolete2 = input("Insira a posicao do segundo apoio rolete: ");
        apoio_roletes(comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, forcas_pontuais, carregamentos_dist, torque_x, momento_z, posrolete1, posrolete2, d, D);
    case 9
        [comprimento, modulo_young, modulo_cisalhamento, iz, iy, area] = propriedades_barra();
    endswitch
    
endwhile
