# Calcula a deflexão sem constante de integração
# Baseado em inclinacao, c3 é a constante de integração da inclinação.
function res = deflexao(x, modulo_young, iz, forcas_pontuais, carregamentos_dist, momento_z, c3)
    res = x * c3;

    # ∫ inclinacao dx
    for i = 1:rows(forcas_pontuais)
        # Para as forças à esquerda de x
        idx = forcas_pontuais(i, 1) < x;
        # t = (x - x0)² * Fy / 2
        # ∫ t dx = ∫ t d(x - x0) = (x - x0)³ * Fy / 6
        res(idx) += ((x(idx) - forcas_pontuais(i, 1)) .^ 3) .* forcas_pontuais(i, 3) ./ 6;
    endfor
    for i = 1:rows(momento_z)
        # Para os momentos à esquerda de x
        idx = momento_z(i, 1) < x;
        res(momento_z(i, 1) < x) -= momento_z(i, 2) .* (x(idx) .^ 2) ./ 2;
    endfor
    for i = 1:size(carregamentos_dist)
        # Carregamentos distribuidos
        # Para as forças totalmente à esquerda de x
        idx = carregamentos_dist{i}(2) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), carregamentos_dist{i}(2), carregamentos_dist{i}(3:end));
        # t = (x - x0)² * F / 2
        # ∫ t dx = (x - x0)³ * F / 6
        res(idx) -= ((x(idx) - posicao_res) .^ 3) .* forca_res ./ 6;

        # Para os x no intervalo do carregamento
        idx = carregamentos_dist{i}(2) >= x & carregamentos_dist{i}(1) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), x(idx), carregamentos_dist{i}(3:end));
        res(idx) -= ((x(idx) - posicao_res) .^ 3) .* forca_res ./ 6;
    endfor

    res /= modulo_young * iz;
endfunction
