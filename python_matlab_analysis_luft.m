function [tv,Vw,vw_dir,wind_spdV,wind_dirV,avg_wv,avg_spdVD,avg_dir,avg_dirVD,wind_spd_bias,wind_dir_bias,RMSE_SPD,RMSE_DIR,alt] = python_matlab_analysis_luft(model_param_file,tuning_param_file,full_model,validation_file,cut_in,cut_out)

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
    [yv,uv,tv,tspan,x0,alt] = meas(full_model);
    
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
    
    % Read in Validation File
    [wind_spdV, wind_dirV] = process_validation_file(validation_file,tv);
    
    [avg_wv,avg_spdVD,avg_dir,avg_dirVD,wind_spd_bias,wind_dir_bias,RMSE_SPD,RMSE_DIR] = process_with_validate(tv, Vw, vw_dir, wind_spdV, wind_dirV, cut_in, cut_out);
    
return