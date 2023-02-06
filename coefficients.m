function [data] = coefficients(p_p,p_r,p_y,p_pl)

    % Pitch Coefficients
    Xtht = p_p(2); Xu = p_p(3); Xq = p_p(4);
    Mtht = p_p(7); Mu = p_p(8); Mq = p_p(9); Mm = p_p(10);
    
    % Roll Coefficients
    Yphi = p_r(2); Yv = p_r(3); Yp = p_r(4);
    Lphi = p_r(7); Lv = p_r(8); Lp = p_r(9); Lm = p_r(10);
    
    % Yaw Coefficients
    Npsi = p_y(1); Nr = p_y(3); Nm = p_y(4);
    
    % Plunge Coefficients
    dw = p_pl(2); dm = p_pl(3);
    
    data = [Xtht,Xu,Xq,Mtht,Mu,Mq,Mm,Yphi,Yv,Yp,Lphi,Lv,Lp,Lm,Npsi,Nr,Nm,dw,dm];
    
    return