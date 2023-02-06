function [twa,ywa,Vw] = extra(full_model,valid_file,param,option)

    % Parameter Estimates (Passed In)
    Xtht = param(1); Xu = param(2); Xq = param(3);
    Mtht = param(4); Mu = param(5); Mq = param(6); Mm = param(7);
    Yphi = param(8); Yv = param(9); Yp = param(10);
    Lphi = param(11); Lv = param(12); Lp = param(13); Lm = param(14);
    Npsi = param(15); Nr = param(16); Nm = param(17);
    dw = param(18); dm = param(19);
    
    % State Estimator & Wind Augmented Matrices
    % Usage Note: zeros(rows,cols) ; eye(rows,cols)

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
    
    % Observability Check
    if (rank(obsv(Awa,Cwa)) == length(Awa))
        fprintf("\nSystem is observable!\n\n")
    else
        fprintf("\nSystem is not observable!\n\n")
    end

    % Weighting Matrices Q & R
    if (option == 0)
        q = 1; p = 0.001; % Weightings for Original Models
        Q = diag([[1 1 1]*p,[1 4 1]*q,[0.1 10 1]*q,[100 100 1]*q,[1 2.6 1]*0.01]);
        R = diag([[1 1 1]*p,[1 1.80 1]*q,[1 1 1]*p,[1 1 1]*p]);
    elseif (option == 1)
        %q = 1; p = 0.001; % Weightings for Tuned Models for main hover test
        %Q = diag([[1 1 1]*p,[1 1 1]*p,[1 10 1]*0.1,[100 100 1]*q,[0.3 0.3 1]*0.01]);
        %R = diag([[1 1 1]*p,[6 1.6 1]*0.1,[1 1 1]*p,[1 1 1]*p]);
        
        % Weightings for tuned hover models for validation file 1 (Luft S-134822_E-135310)
        t_h = readFromFile('ARES Tests/tuning_parameters_hover.txt').';
        Q = diag([[t_h(1) t_h(2) t_h(3)]*t_h(4),[t_h(5) t_h(6) t_h(7)]*t_h(8),[t_h(9) t_h(10) t_h(11)]*t_h(12),[t_h(13) t_h(14) t_h(15)]*t_h(16),[t_h(17) t_h(18) t_h(19)]*t_h(20)]);
        R = diag([[t_h(21) t_h(22) t_h(23)]*t_h(24),[t_h(25) t_h(26) t_h(27)]*t_h(28),[t_h(29) t_h(30) t_h(31)]*t_h(32),[t_h(33) t_h(34) t_h(35)]*t_h(36)]);
        
        %q = 1; p = 0.001; % Weightings for Tuned Models for validation file 2
        %Q = diag([[1 1 1]*p,[100 0.01 1]*q,[1 1 1]*p,[1 1 1]*p,[1 1 1]*0.1]);
        %R = diag([[1 1 1]*p,[0.7 10 0.01]*q,[1 1 1]*p,[1 0.5 1]*q]);
        %[N,Y,N,N,L][N,Y,N,Y]
        
        %q = 1; p = 0.1;
        %Q = diag([[1 1 1]*q,[1 1 1]*q,[1 1 1]*q,[1 1 1]*q,[1 1 1]*q]);
        %R = diag([[1 1 1]*q,[1 1 1]*q,[1 1 1]*q,[1 1 1]*q]);
    end
    
    % Determine Observability Matrix 'Go'
    [Go,~,S] = lqr(Awa',Cwa',Q,R);
    
    % Display for Convergence Check
    %disp(S)
    
    % [Measured Outputs, Inputs, Time Array, Timespan, Initial Conditions]
    [yv,uv,tv,tspan,x0] = meas(full_model);
    %tht = yv(:,4); phi = yv(:,5); psi = yv(:,6);
    %u = yv(:,7); v = yv(:,8);
    %q = yv(:,10); p = yv(:,11);
    
    % Estimation
    [twa,ywa] = ode45(@(t,x) wind_model(t,x,Awa,Bwa,Cwa,Go',tv,uv,yv),tspan,x0);
    
    % Extract wind vector
    wv = ywa(:,[14,13,15]);
    Wv = interp1(twa,wv,tv);        % Interpolated to fit other data
    Wvu = Wv(:,1); Wvv = Wv(:,2);
    
    % Read in Validation File
    M = csvread(valid_file,1,2);
    [rowsV,~] = size(M);
    
    timestamp = csvread(valid_file,1,1,[1,1,rowsV,1]);
    timestamp_new = fix_offset(timestamp,0,0); timestamp = timestamp_new;
    wind_spd_V = csvread(valid_file,1,2,[1,2,rowsV,2]); 
    wind_dir_V = csvread(valid_file,1,3,[1,3,rowsV,3]); 
    
    wind_spdV = interp1(timestamp,wind_spd_V,tv);
    wind_dirV = interp1(timestamp,wind_dir_V,tv);
    
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
    avg_spdV = zeros(avg_num,1); avg_dirV = zeros(avg_num,1);
    %time = linspace(1,round(max(tv)),avg_num);
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
    cut_in = 8;cut_out = 11;
    avg_wv = mean(avg_v(cut_in:avg_num-cut_out)); avg_dir = mean(avg_d(cut_in:avg_num-cut_out));
    avg_spdVD = mean(avg_spdV(cut_in:avg_num-cut_out)); avg_dirVD = mean(avg_dirV(cut_in:avg_num-cut_out));
    
    % Plots  
    subplot(1,2,1); plot(Vw,tv,'.',wind_spdV,tv,'.'); xlim([0 6]);
    xlabel('Wind Speed (m/s)'); ylabel('Time (s)'); title("Wind Speed"); legend('Model','Luft')
    subplot(1,2,2); plot(vw_dir,tv,'.',wind_dirV,tv,'.'); xlim([0 360]); ylabel('Time (s)') 
    xlabel('Wind Direction (Degrees)'); title("Wind Direction"); legend('Model','Luft')
    fprintf('Wind Results -- Press any key to continue ... \n\n'),pause,
    %avg_v(cut_in:avg_num-cut_out),time(cut_in:avg_num-cut_out),'g -s' plot
    %to see average line and start and finish
    
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
    
%     subplot(1,4,1); plot(Vw,tv,'.',wind_spdV,tv,'.'); xlim([0 10]);
%     xlabel('Wind Speed (m/s)'); ylabel('Time (s)'); title("Wind Speed"); legend('Model','Luft')
%     subplot(1,4,2); plot(vw_dir,tv,'.',wind_dirV,tv,'.'); xlim([0 360]); ylabel('Time (s)') 
%     xlabel('Wind Direction (Degrees)'); title("Wind Direction"); legend('Model','Luft')
%     subplot(1,4,3),plot(n_spd,tv(start_index:end_index),'--','LineWidth',1.5),title("Residuals: Wind Speed"),
%     grid on; xlabel('Wind Speed (m/s)'), ylabel('Time (sec)'),xlim([-3 3])
%     subplot(1,4,4),plot(n_dir,tv(start_index:end_index),'--','LineWidth',1.5),title("Residuals: Wind Direction"),
%     grid on; xlabel('Wind Direction (Degrees)'),ylabel('Time (sec)'),xlim([-40 40])
    
    RMSE_SPD = sqrt(mean(n_spd.^2));
    RMSE_DIR = sqrt(mean(n_dir.^2));
    fprintf("Average Wind Velocity Model = %.2f\n",avg_wv);
    fprintf("Average Wind Velocity Luft = %.2f\n",avg_spdVD);
    fprintf("Average Wind Direction Model = %.2f\n",avg_dir);
    fprintf("Average Wind Direction Luft = %.2f\n\n",avg_dirVD);
    
    fprintf("Wind Speed Bias = %.2f\n",abs(avg_spdVD-avg_wv));
    fprintf("Wind Direction Bias = %.2f\n\n",abs(avg_dirVD-avg_dir));
    X = sprintf("RMSE: SPD - %.2f ; DIR - %.2f\n",RMSE_SPD,RMSE_DIR);
    disp(X) %#ok<DSPS>
    fprintf('Residual Plots -- Press any key to continue ... \n'),pause,
    fprintf("-------------------------------------------------\n")
        
return
        