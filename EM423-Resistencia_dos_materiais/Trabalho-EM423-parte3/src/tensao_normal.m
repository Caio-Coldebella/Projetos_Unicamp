function res = tensao_normal(x, y, forcas_pontuais, carregamentos_dist, momento_z, area, iz, iy)
    res = esforco_normal(x, forcas_pontuais) / area - momento_fletor(x, forcas_pontuais, carregamentos_dist, momento_z) * y / ((iz + iy) / 2);
endfunction
