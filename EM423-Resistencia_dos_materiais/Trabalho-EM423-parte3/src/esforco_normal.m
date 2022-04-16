function res = esforco_normal(x, forcas_pontuais)
    res = zeros(size(x));

    for i = 1:rows(forcas_pontuais)
        # Para as forças à esquerda de x
        idx = forcas_pontuais(i, 1) < x;
        res(idx) -= forcas_pontuais(i, 2);
    endfor
endfunction
