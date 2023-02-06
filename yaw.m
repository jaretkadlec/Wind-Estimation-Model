function [y,x,A,B,C,D] = yaw(p,u,t,x0,c)
constant = c; %#ok<NASGU>

A = [0,1;...
    0,p(3)];
B = [0;p(4)];
C = eye(2);
D = zeros(2,1);

[y,x]=lsims(A,B,C,D,u,t,x0);

return