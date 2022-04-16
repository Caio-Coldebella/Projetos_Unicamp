function res = tensao_de_cisalhamento(x, y, z, forcas_pontuais, carregamentos_dist, torque_x, area, iz, iy, R, r)
    res_cortante = - 4 / 3 * esforco_cortante(x, forcas_pontuais, carregamentos_dist) / area * (R * R + R * r + r * r) / (R * R + r * r);
    res_torcao = momento_torsor(x, torque_x) * R / (iz + iy);

    if z == R
        res = res_cortante - res_torcao;
    elseif z == -R
        res = res_cortante + res_torcao;
    elseif y == R
        res = res_torcao;
    elseif y == -R
        res = - res_torcao;
    else
        error("Nao podemos calcular tensao de cisalhamento fora de extremos");
    endif
endfunction
