function [tv,Vw,vw_dir,avg_wv,avg_dir] = python_matlab_analysis(model_param_file,tuning_param_file,full_model_file,cutIN,cutOUT)

    % Model Parameters & Observability Check
    param = readFromFile(model_param_file);   
    obsv_chk(param);
    
    % Wind Augmented Matrices
    [Awa,Bwa,Cwa] = wind_augmented_matrices(param);
   
    % Weighting Matrices Q & R
    t_h = readFromFile(tuning_param_file).';
    Q = diag([[t_h(1) t_h(2) t_h(3)]*t_h(4),[t_h(5) t_h(6) t_h(7)]*t_h(8),[t_h(9) t_h(10) t_h(11)]*t_h(12),[t_h(13) t_h(14) t_h(15)]*t_h(16),[t_h(17) t_h(18) t_h(19)]*t_h(20)]);
    R = diag([[t_h(21) t_h(22) t_h(23)]*t_h(24),[t_h(25) t_h(26) t_h(27)]*t_h(28),[t_h(29) t_h(30) t_h(31)]*t_h(32),[t_h(33) t_h(34) t_h(35)]*t_h(36)]);

    % Determine Observability Matrix 'Go'
    [Go,~,~] = lqr(Awa',Cwa',Q,R);
    
    % [Measured Outputs, Inputs, Time Array, Timespan, Initial Conditions]
    [yv,uv,tv,tspan,x0,~] = meas(full_model_file);
    
    % Wind Estimation
    [twa,ywa] = ode45(@(t,x) wind_model(t,x,Awa,Bwa,Cwa,Go',tv,uv,yv),tspan,x0);
    
    % Extract wind vector
    wv = ywa(:,[14,13,15]);
    Wv = interp1(twa,wv,tv);        % Interpolated to fit other data
    Wvu = Wv(:,1); Wvv = Wv(:,2);
    
    % Correct heading by rotating to inertial frame about yaw
    [n,~] = size(Wvu);
    Wvu_new = zeros(n,1); Wvv_new = zeros(n,1);
    for i = 1:n
        Wvu_new(i) = Wvu(i)*cosd(psi(i)) - Wvv(i)*sind(psi(i));
        Wvv_new(i) = Wvu(i)*sind(psi(i)) + Wvv(i)*cosd(psi(i));
    end
    Wvu = Wvu_new; Wvv = Wvv_new;
    
    % Wind Speed
    Vw = (Wvu.^2 + Wvv.^2).^0.5;
    vw_dir = wrapTo360(wrapTo360(atan2d(Wvu,Wvv))+180);
    
    % Compute Averages
    time_split = 5;
    avg_num = round(max(tv)/time_split);
    dist_num = round(length(Vw)/avg_num);
    avg_v = zeros(avg_num,1); avg_d = zeros(avg_num,1);
    j = 1; index = 1;
    for i = 1:avg_num
        if (dist_num*j < length(Vw))
            avg_v(i) = mean(Vw(index:(dist_num*j)));
            avg_d(i) = mean(vw_dir(index:(dist_num*j)));
            index = dist_num*j;
            j = j+1;
        end
    end
    
    cut_in = cutIN;cut_out = cutOUT;
    
    avg_wv = mean(avg_v(cut_in:avg_num-cut_out)); avg_dir = mean(avg_d(cut_in:avg_num-cut_out));
        
end