function res = momento_fletor(x, forcas_pontuais, carregamentos_dist, momento_z)
    res = zeros(size(x));

    for i = 1:rows(forcas_pontuais)
        # Para as forças à esquerda de x
        idx = forcas_pontuais(i, 1) < x;
        res(idx) += (x(idx) - forcas_pontuais(i, 1)) .* forcas_pontuais(i, 3);
    endfor
    for i = 1:rows(momento_z)
        # para os momentos à esquerda de x
        res(momento_z(i, 1) < x) -= momento_z(i, 2);
    endfor

    # Carregamentos distribuidos
    for i = 1:size(carregamentos_dist)
        # Para as forças totalmente à esquerda de x
        idx = carregamentos_dist{i}(2) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), carregamentos_dist{i}(2), carregamentos_dist{i}(3:end));
        res(idx) -= (x(idx) - posicao_res) * forca_res;

        # Para os x no intervalo do carregamento
        idx = carregamentos_dist{i}(2) >= x & carregamentos_dist{i}(1) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), x(idx), carregamentos_dist{i}(3:end));
        res(idx) -= (x(idx) - posicao_res) .* forca_res;
    endfor
endfunction
