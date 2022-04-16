function res = esforco_cortante(x, forcas_pontuais, carregamentos_dist)
    res = zeros(size(x));

    for i = 1:rows(forcas_pontuais)
        # Para as forças à esquerda de x
        idx = forcas_pontuais(i, 1) < x;
        res(idx) += forcas_pontuais(i, 3);
    endfor

    # Carregamentos distribuidos
    for i = 1:size(carregamentos_dist)
        # Para as forças totalmente à esquerda de x
        idx = carregamentos_dist{i}(2) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), carregamentos_dist{i}(2), carregamentos_dist{i}(3:end));
        res(idx) -= forca_res;

        # Para os x no intervalo do carregamento
        idx = carregamentos_dist{i}(2) >= x & carregamentos_dist{i}(1) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), x(idx), carregamentos_dist{i}(3:end));
        res(idx) -= forca_res;
    endfor
endfunction
