function [forca_res, posicao_res] = carga_distribuida(inicio, fim, carregamento)
    # integral de w(x)
    integral = polyint(carregamento); #Transformando o vetor em espaço vetorial polinomial
    forca_res = polyval(integral, fim) - polyval(integral, inicio); # Fazendo a integral entre os limites desejados a partir da função recebida

    # integral w(x) * x
    integral = polyint([carregamento 0]); # Adiciona zero a lista, de modo que cada elemento seja x^n+1 no array
    frx = polyval(integral, fim) - polyval(integral, inicio);
    posicao_res = frx ./ forca_res;
endfunction
