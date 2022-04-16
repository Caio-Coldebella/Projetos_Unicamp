function res = alongamento(x, forcas_pontuais, modulo_cisalhamento, area)
    res = zeros(size(x));

    for i = 1:rows(forcas_pontuais)
        # Para as torques à esquerda do x
        idx = forcas_pontuais(i, 1) > x;
        res(idx) += forcas_pontuais(i, 2) * (x(idx) - forcas_pontuais(i, 1));
    endfor
    res /= modulo_cisalhamento * area;
endfunction
