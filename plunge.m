function [y,x,A,B,C,D] = plunge(p,u,t,x0,c)
constant = c; %#ok<NASGU>

A = [p(2)];
B = [p(3)];
C = eye(1);
D = [0];

[y,x]=lsims(A,B,C,D,u,t,x0);

return