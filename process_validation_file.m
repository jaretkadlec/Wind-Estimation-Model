function [wind_spdV, wind_dirV] = process_validation_file(valid_file,tv)

    M = csvread(valid_file,1,2);
    [rowsV,~] = size(M);
    
    timestamp = csvread(valid_file,1,1,[1,1,rowsV,1]);
%     timestamp_new = fix_offset(timestamp,0,0); timestamp = timestamp_new;
    wind_spd_V = csvread(valid_file,1,2,[1,2,rowsV,2]); 
    wind_dir_V = csvread(valid_file,1,3,[1,3,rowsV,3]); 
%     fails with radiosonde data
%     wind_spdV = interp1(timestamp,wind_spd_V,tv);
%     wind_dirV = interp1(timestamp,wind_dir_V,tv);
    wind_spdV = wind_spd_V;
    wind_dirV = wind_dir_V;
    
end