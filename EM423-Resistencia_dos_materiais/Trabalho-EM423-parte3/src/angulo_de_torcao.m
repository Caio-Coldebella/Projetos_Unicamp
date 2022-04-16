function res = angulo_de_torcao(x, torque_x)
    res = zeros(size(x));

    for i = 1:rows(torque_x)
        # Para as torques à esquerda do x
        idx = torque_x(i, 1) > x;
        res(idx) -= torque_x(i, 2) * x(idx);
    endfor
endfunction