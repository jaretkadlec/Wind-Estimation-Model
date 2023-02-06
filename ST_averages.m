function [avg_ws,avg_dir, avg_alt, windSpd, windDir, alt] = ST_averages(ST_File)

    M = csvread(ST_File,1,2);
    [n,~] = size(M);
    windSpd = csvread(ST_File,1,2,[1,2,n,2]);
    windDir = csvread(ST_File,1,3,[1,3,n,3]);
    alt = csvread(ST_File,1,4,[1,4,n,4]);
    
    avg_ws = mean(windSpd);
    avg_dir = mean(windDir);
    avg_alt = mean(alt);
    