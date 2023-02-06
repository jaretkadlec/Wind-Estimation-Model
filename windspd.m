function [twa,ywa,Vw] = windspd(full_model,valid_file,param)

    [Awa,Bwa,Cwa] = wind_augmented_matrices(param);
    
    % Observability Check
    if (rank(obsv(Awa,Cwa)) == length(Awa))
        fprintf("\nSystem is observable!\n\n")
    else
        fprintf("\nSystem is not observable!\n\n")
    end

    % Weighting Matrices Q & R
    % ------------------------
%     Weights for tuned hover models for validation file (Luft S-134822_E-135310)
%     t_h = readFromFile('ARES Tests/tuning_parameters_hover.txt').';
%     Q = diag([[t_h(1) t_h(2) t_h(3)]*t_h(4),[t_h(5) t_h(6) t_h(7)]*t_h(8),[t_h(9) t_h(10) t_h(11)]*t_h(12),[t_h(13) t_h(14) t_h(15)]*t_h(16),[t_h(17) t_h(18) t_h(19)]*t_h(20)]);
%     R = diag([[t_h(21) t_h(22) t_h(23)]*t_h(24),[t_h(25) t_h(26) t_h(27)]*t_h(28),[t_h(29) t_h(30) t_h(31)]*t_h(32),[t_h(33) t_h(34) t_h(35)]*t_h(36)]);

%     Weighting for 5 m/s model
%     t_h = readFromFile('ARES Tests/tuning_parameters_5ms.txt').';
%     Q = diag([[t_h(1) t_h(2) t_h(3)]*t_h(4),[t_h(5) t_h(6) t_h(7)]*t_h(8),[t_h(9) t_h(10) t_h(11)]*t_h(12),[t_h(13) t_h(14) t_h(15)]*t_h(16),[t_h(17) t_h(18) t_h(19)]*t_h(20)]);
%     R = diag([[t_h(21) t_h(22) t_h(23)]*t_h(24),[t_h(25) t_h(26) t_h(27)]*t_h(28),[t_h(29) t_h(30) t_h(31)]*t_h(32),[t_h(33) t_h(34) t_h(35)]*t_h(36)]);
    
    % 07-13-21 5ms Validation_File (2&3) Tuning
%     q = 1; p = 0.001;
%     Q = diag([[100 100 1]*p,[0.1 1.4 1]*p,[80 1 1]*p,[1 0.1 1]*p,[0.1 0.1 1]*q]);
%     R = diag([[100 100 1]*p,[15 5 1]*p,[.5 10 1]*q,[0.01 0.01 1]*p]);
    
%     Initial Weighting Matrices
    q = 1; p = 0.001;
    Q = diag([[1 10 1]*p,[5 1 1]*q,[1 1 1]*p,[100 1 1]*q,[1 100 1]*q]);
    R = diag([[1 1 1]*p,[1 1 1]*q,[1 1 1]*p,[1 1 100]*q]);
    % RMSE using params from txt file
    % Speed - 1.48
    % Direction - 19.31

    % Determine Observability Matrix 'Go'
    [Go,~,~] = lqr(Awa',Cwa',Q,R);
    
    % Display for Convergence Check (Enable third returned variable from lqr() to get S
    % disp(S)
    
    % [Measured Outputs, Inputs, Time Array, Timespan, Initial Conditions]
    [yv,uv,tv,tspan,x0] = meas(full_model);
    
    % Wind Estimation
    [twa,ywa] = ode45(@(t,x) wind_model(t,x,Awa,Bwa,Cwa,Go',tv,uv,yv),tspan,x0);
    
    % Extract wind vector
    wv = ywa(:,[14,13,15]);
    Wv = interp1(twa,wv,tv);        % Interpolated to fit other data
    Wvu = Wv(:,1); Wvv = Wv(:,2);
    
    % Read in Validation File
    [wind_spdV, wind_dirV] = process_validation_file(valid_file,tv);
    
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
    time_split = 3;
    avg_num = round(max(tv)/time_split);
    dist_num = round(length(Vw)/avg_num);
    avg_v = zeros(avg_num,1); avg_d = zeros(avg_num,1);
    avg_spdV = zeros(avg_num,1); avg_dirV = zeros(avg_num,1);
    j = 1; index = 1;
    for i = 1:avg_num
        if (dist_num*j < length(Vw))
            avg_v(i) = mean(Vw(index:(dist_num*j)));
            avg_d(i) = mean(vw_dir(index:(dist_num*j)));
            avg_spdV(i) = mean(wind_spdV(index:(dist_num*j)));
            avg_dirV(i) = mean(wind_dirV(index:(dist_num*j)));
            index = dist_num*j;
            j = j+1;
        end
    end
    
    % End cut values to limit averaging in area of proper flight
    % Tuned hover model cuts
    cut_in = 2;cut_out = 1;
    
    % Plots  
    subplot(1,2,1); plot(Vw,tv,'.',wind_spdV,tv,'.'); xlim([0 6]);
    xlabel('Wind Speed (m/s)'); ylabel('Time (s)'); title("Wind Speed"); legend('Model','Luft')
    subplot(1,2,2); plot(vw_dir,tv,'.',wind_dirV,tv,'.'); xlim([0 360]); ylabel('Time (s)') 
    xlabel('Wind Direction (Degrees)'); title("Wind Direction"); legend('Model','Luft')
    
    % Residuals & RMSE 
    start_index = 0; end_index = 0;
    start_found = 0; end_found = 0;
    for i = 1:size(tv)
        if (round(tv(i)) == time_split*cut_in && start_found == 0)
            start_index = i;
            start_found = 1;
        elseif (round(tv(i)) == round(max(tv))-time_split*cut_out && end_found == 0)
            end_index = i;
            end_found = 1;
        end
    end
    
    n_spd = zeros(size(tv(start_index:end_index)));
    n_dir = zeros(size(tv(start_index:end_index)));
    for i = 1:size(tv(start_index:end_index)) 
        n_spd(i) = Vw(start_index-1+i) - wind_spdV(start_index-1+i);
        n_dir(i) = vw_dir(start_index-1+i) - wind_dirV(start_index-1+i);
    end
    
    RMSE_SPD = sqrt(mean(n_spd.^2));
    RMSE_DIR = sqrt(mean(n_dir.^2));
%     fprintf("Average Wind Velocity Model = %.2f\n",avg_v);
%     fprintf("Average Wind Velocity Luft = %.2f\n",avg_spdV);
%     fprintf("Average Wind Direction Model = %.2f\n",avg_d);
%     fprintf("Average Wind Direction Luft = %.2f\n\n",avg_dirV);
%     
%     fprintf("Wind Speed Bias = %.2f\n",abs(avg_spdV-avg_v));
%     fprintf("Wind Direction Bias = %.2f\n\n",abs(avg_dirV-avg_d));
    X = sprintf("RMSE: SPD - %.2f ; DIR - %.2f\n",RMSE_SPD,RMSE_DIR);
    disp(X) %#ok<DSPS>
    fprintf("-------------------------------------------------\n")
        
return
        