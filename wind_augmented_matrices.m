function [Awa, Bwa, Cwa] = wind_augmented_matrices(param)

    % Creates matrices for observability check as well as wind estimation

    % Model Parameters
    % ----------------
    Xtht = param(1); Xu = param(2); Xq = param(3);
    Mtht = param(4); Mu = param(5); Mq = param(6); Mm = param(7);
    Yphi = param(8); Yv = param(9); Yp = param(10);
    Lphi = param(11); Lv = param(12); Lp = param(13); Lm = param(14);
    Npsi = param(15); Nr = param(16); Nm = param(17);
    dw = param(18); dm = param(19);
    
    % Initial & Wind Augmented Matrices
    % ---------------------------------
    A = [zeros(6),eye(6);...
        0,0,0,Xtht,0,0,Xu,0,0,Xq,0,0;...
        0,0,0,0,Yphi,0,0,Yv,0,0,Yp,0;...
        0,0,0,0,0,0,0,0,dw,0,0,0;...
        0,0,0,Mtht,0,0,Mu,0,0,Mq,0,0;...
        0,0,0,0,Lphi,0,0,Lv,0,0,Lp,0;...
        0,0,0,0,0,Npsi,0,0,0,0,0,Nr];
    
    B = [zeros(8,4); diag([dm Mm Lm Nm])];
    C = eye(12);
    
    Awa = [A,eye(12,3);zeros(3,15)];   
    Bwa = [B; zeros(3,4)];
    Cwa = [C,[zeros(6,3);eye(3);zeros(3)]];
    
end