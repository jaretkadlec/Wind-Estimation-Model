function [yv,uv,tv,tspan,x0,alt] = meas(full_model)

M = csvread(full_model,1,2);
[n,~] = size(M);
% temporary (?)
% tv = csvread(full_model,1,1,[1,1,n,1]); [tv_new] = fix_offset(tv,0,0); tv = tv_new;
tv = csvread(full_model,1,19,[1,19,n,19]); [tv_new] = fix_offset(tv,0,0); tv = tv_new;
tspan = [tv(1),tv(n)];
x = csvread(full_model,1,2,[1,2,n,2]); [x_new] = fix_offset(x,0,0); x = x_new;
y = csvread(full_model,1,3,[1,3,n,3]); [y_new] = fix_offset(y,0,0); y = y_new;
z = csvread(full_model,1,4,[1,4,n,4]); [z_new] = fix_offset(z,0,0); z = z_new;
tht = csvread(full_model,1,5,[1,5,n,5]); [tht_new] = fix_offset(tht,0,0); tht = tht_new.*(180/pi);
phi = csvread(full_model,1,6,[1,6,n,6]); [phi_new] = fix_offset(phi,0,0); phi = phi_new.*(180/pi);
psi = csvread(full_model,1,7,[1,7,n,7]); [psi_new] = fix_offset(psi,0,0); psi = psi_new.*(180/pi);
u = csvread(full_model,1,8,[1,8,n,8]); [u_new] = fix_offset(u,0,0); u = u_new;
v = csvread(full_model,1,9,[1,9,n,9]); [v_new] = fix_offset(v,0,0); v = v_new;
w = csvread(full_model,1,10,[1,10,n,10]); [w_new] = fix_offset(w,0,0); w = w_new;
q = csvread(full_model,1,11,[1,11,n,11]); [q_new] = fix_offset(q,0,0); q = q_new;
p = csvread(full_model,1,12,[1,12,n,12]); [p_new] = fix_offset(p,0,0); p = p_new;
r = csvread(full_model,1,13,[1,13,n,13]); [r_new] = fix_offset(r,0,0); r = r_new;
dm = csvread(full_model,1,14,[1,14,n,14]); [dm_new] = fix_offset(dm,0,0); dm = dm_new;
Mm = csvread(full_model,1,15,[1,15,n,15]); [Mm_new] = fix_offset(Mm,0,0); Mm = Mm_new;
Lm = csvread(full_model,1,16,[1,16,n,16]); [Lm_new] = fix_offset(Lm,0,0); Lm = Lm_new;
Nm = csvread(full_model,1,17,[1,17,n,17]); [Nm_new] = fix_offset(Nm,0,0); Nm = Nm_new;
alt = readmatrix(full_model,Range=[1,18,n,18]);

    % Output Measurements
    yv = [x,y,z,tht,phi,psi,u,v,w,q,p,r];
    
    % Input Measurements
    uv = [dm,Mm,Lm,Nm];
    
    % Initial Conditions
    x0 = zeros(1,15);
    
end
