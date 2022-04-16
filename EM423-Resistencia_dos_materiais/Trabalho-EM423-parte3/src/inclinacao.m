# Calcula a inclinação sem constante de integração
# Baseado em momento_fletor
function res = inclinacao(x, modulo_young, iz, forcas_pontuais, carregamentos_dist, momento_z)
    res = zeros(size(x));

    # ∫ momento_fletor dx
    for i = 1:rows(forcas_pontuais)
        # Para as forças à esquerda de x
        idx = forcas_pontuais(i, 1) < x;
        # M = (x(idx) - forcas_pontuais(i, 1)) .* forcas_pontuais(i, 3) = (x - x0) * Fy
        # ∫ M dx = ∫ M d(x - x0) = (x - x0)² * Fy / 2
        res(idx) -= ((x(idx) - forcas_pontuais(i, 1)) .^ 2) .* forcas_pontuais(i, 3) ./ 2;
    endfor
    for i = 1:rows(momento_z)
        # Para os momentos à esquerda de x
        idx = momento_z(i, 1) < x;
        res(momento_z(i, 1) < x) += momento_z(i, 2) * x(idx);
    endfor
    for i = 1:size(carregamentos_dist)
        # Carregamentos distribuidos
        # Para as forças totalmente à esquerda de x
        idx = carregamentos_dist{i}(2) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), carregamentos_dist{i}(2), carregamentos_dist{i}(3:end));
        # M = (x(idx) - posicao_res) * forca_res = (x - x0) * F
        # ∫ M dx = ∫ M d(x - x0) = (x - x0)² * F / 2
        res(idx) += ((x(idx) - posicao_res) .^ 2) .* forca_res ./ 2;

        # Para os x no intervalo do carregamento
        idx = carregamentos_dist{i}(2) >= x & carregamentos_dist{i}(1) < x;
        [forca_res, posicao_res] = carga_distribuida(carregamentos_dist{i}(1), x(idx), carregamentos_dist{i}(3:end));
        res(idx) += ((x(idx) - posicao_res) .^ 2) .* forca_res ./ 2;
    endfor

    # Dividir tudo por modulo_young * iz
    res /= modulo_young * iz;
endfunction
