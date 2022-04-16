function [comprimento, modulo_young, modulo_cisalhamento, iz, iy, area, d, D] = propriedades_barra()
    comprimento = input("Digite o comprimento da barra em m: "); # Inserir o comprimento da barra
    modulo_young = input("Modulo de Young: (em Pa)"); # Inserir o comprimento da barra
    modulo_cisalhamento = input("Modulo de cisalhamento: (em Pa)"); # Inserir o comprimento da barra

    d = 0;
    D = 0;

    clc;
    fprintf("Qual seccao se aplica?\n");
    fprintf("\t1 - Oco\n");
    fprintf("\t2 - Retangular\n");
    fprintf("\t3 - Circular\n");
    switch input("")
    case 1
        clc;
        d = input("Diametro menor: (em m)");
        D = input("Diametro maior: (em m)");
        iz = pi * (D.^4 - d.^4)/64;
        iy = iz;
        area = pi * ((D / 2).^2 - (d / 2).^2);
    case 2
        clc;
        h = input("Altura: (em m)");
        b = input("Comprimento: (em m)");
        iz = (b*h.^3)/12;
        iy = (h*b.^3)/12;
        area = b * h;
    case 3
        clc;
        D = input("Diametro: (em m)");
        iz = (pi * D.^4)/64;
        iy = iz;
        area = pi * (D / 2) .^ 2;
    endswitch
endfunction
