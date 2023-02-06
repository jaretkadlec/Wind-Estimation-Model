function [avg_wv,avg_spdVD,avg_dir,avg_dirVD,wind_spd_bias,wind_dir_bias,RMSE_SPD,RMSE_DIR] = process_with_validate(tv, Vw, vw_dir, wind_spdV, wind_dirV, cutIN, cutOUT)

    time_split = 5;
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
    
    cut_in = cutIN; cut_out = cutOUT;
    
    avg_wv = mean(avg_v(cut_in:avg_num-cut_out)); avg_dir = mean(avg_d(cut_in:avg_num-cut_out));
    avg_spdVD = mean(avg_spdV(cut_in:avg_num-cut_out)); avg_dirVD = mean(avg_dirV(cut_in:avg_num-cut_out));
    
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
    wind_spd_bias = abs(avg_spdVD-avg_wv);
    wind_dir_bias = abs(avg_dirVD-avg_dir);
    
end