function r = tensoes_principais(sx, sy, sxy)
    x = tensao_de_cisalhamento_maxima_absoluta(sx, sy, sxy);
    r = sort([0, (sx + sy) / 2 + x, (sx + sy) / 2 - x]);
endfunction
