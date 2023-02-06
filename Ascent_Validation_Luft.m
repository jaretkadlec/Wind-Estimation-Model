function Ascent_Validation_Luft(full_model, luft_file, param)

    [Awa,Bwa,Cwa] = wind_augmented_matrices(param);
    
    % Observability Check
    if (rank(obsv(Awa,Cwa)) == length(Awa))
        fprintf("\nSystem is observable!\n\n")
    else
        fprintf("\nSystem is not observable!\n\n")
    end
    
    % Weighting Matrices Q & R
    % ------------------------
%     5ms Tuning
    q = 1; p = 0.1;
    Q = diag([[1 1 1]*q,[1 1 1]*q,[1 100 1]*p,[0.1 100 1]*p,[1 1 1]*q]);
    R = diag([[1 1 1]*q,[1 1.3 1]*p,[1 1 1]*q,[1 0.1 1]*p]);   

%     Initial tuning;
%     q = 1; p = 0.1;
%     Q = diag([[1 1 1]*q,[1 1 1]*q,[1 1 1]*q,[1 1 1]*q,[1 1 1]*q]);
%     R = diag([[1 1 1]*q,[1 1 1]*q,[1 1 1]*q,[1 1 1]*q]);

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
    
    % Read in Validation File
    [wind_spdV, wind_dirV] = process_validation_file(luft_file,tv);
%     disp(wind_spdV);
%     disp(wind_dirv);
    
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
    
    avg_wv = mean(avg_v); avg_dir = mean(avg_d(cut_in:avg_num-cut_out));
    avg_spdVD = mean(avg_spdV(cut_in:avg_num-cut_out)); avg_dirVD = mean(avg_dirV(cut_in:avg_num-cut_out));
%     avg_wv = mean(Vw); avg_dir = mean(vw_dir);
%     avg_spdVD = mean(wind_spdV); avg_dirVD = mean(wind_dirV);
    
     % Plots  
    subplot(1,4,1); plot(Vw,tv,'.',wind_spdV,tv,'.');
    xlabel('Wind Speed (m/s)'); ylabel('Time (s)'); title("Wind Speed");
    subplot(1,4,2); plot(vw_dir,tv,'.',wind_dirV,tv,'.'); xlim([0 360]); ylabel('Time (s)') 
    xlabel('Wind Direction (Degrees)'); title("Wind Direction");
    xticks([0 180 360])
    xticklabels({'0','180','360'})
%     subplot(1,4,3); plot(Vw,alt,"."); xlabel('Wind Speed (m/s)'); ylabel('Altitude (m)'); 
%     title('Wind Speed vs. Altitude');
%     subplot(1,4,4); plot(vw_dir,alt,"."); xlabel('Wind Direction (m/s)'); ylabel('Altitude (m)'); 
%     title('Wind Direction vs. Altitude'); xlim([0 360]);
    
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
    fprintf("Average Wind Velocity Model = %.2f\n",avg_wv);
    fprintf("Average Wind Velocity Luft = %.2f\n",avg_spdVD);
    fprintf("Average Wind Direction Model = %.2f\n",avg_dir);
    fprintf("Average Wind Direction Luft = %.2f\n\n",avg_dirVD);
    
    fprintf("Wind Speed Bias = %.2f\n",abs(avg_spdVD-avg_wv));
    fprintf("Wind Direction Bias = %.2f\n\n",abs(avg_dirVD-avg_dir));
    X = sprintf("RMSE: SPD - %.2f ; DIR - %.2f\n",RMSE_SPD,RMSE_DIR);
    disp(X) %#ok<DSPS>
    fprintf("-------------------------------------------------\n")
    
return