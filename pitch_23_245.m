function [y,x,A,B,C,D] = pitch_23_245(p,u,t,x0,c)
constant = c; %#ok<NASGU>

A = [p(3),0,p(2);...
    0,p(9),p(7);...
    0,1,0];
B = [0;p(10);0];
C = eye(3);
D = zeros(3,1);

[y,x]=lsims(A,B,C,D,u,t,x0);

return