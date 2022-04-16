function r = tensao_de_cisalhamento_maxima_absoluta(sx, sy, sxy)
    r = sqrt(((sx - sy) / 2) .^ 2 + sxy .^ 2);
endfunction
