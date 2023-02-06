function [y_oe,p_oe,RMSE] = yaw_oe(filename,model)
    
    M = csvread(filename,1,2);
    [rows,cols] = size(M);
    if (cols == 7) 
        cols = cols - 1;
    end
    
    % Stepwise Regression Variables
    z = csvread(filename,1,2,[1,2,rows,2]);         % rotational acceleration
    [z_fix] = fix_offset(z,0,0); z = z_fix;
    x = csvread(filename,1,4,[1,4,rows,cols+1]);    % regressor matrix
    [psi_fix] = fix_offset(x,1,0);
    [vel_fix] = fix_offset(psi_fix,2,0);
    [rate_fix] = fix_offset(vel_fix,3,0);
    [u_fix] = fix_offset(rate_fix,4,1);
    x = u_fix;                                       % centered reg. matrix
  
    % Rotational Model Regresssion
    t=[1:rows]';
    fprintf('\n\nPart 1: Rotational Model Regression')
    subplot(4,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('yaw (rad)'),ylim([-1 1]),title('Regressors');
    subplot(4,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('v (m/s)')
    subplot(4,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('r (rad/s)'),ylim([-2 2])
    subplot(4,1,4),plot(t,x(:,4),'LineWidth',1.5),grid on;ylabel('µ yaw (%)')%,ylim([-.4 .4])
    xlabel('time (s)')
    fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,

    % Measured Output Plot
    subplot(1,1,1),plot(t,z),grid on,ylabel('Angular/Translational Acceleration'),xlabel('index'),title('Measured Output Vector'),
    fprintf('\n\n Measured Output Plot -- Press any key to continue ... '),pause,
    
    % Stepwise Regression Statement
    [~,p_r,~,~,~,~] = swr(x,z,1);
    fprintf('\n\nPress any key to continue ... '),pause,
    
    obs = p_r;   %Parameter Estimnates for Output Error
    
    % Instantiating Output Error Variables
    t_oe = linspace(0,(rows/20)-0.05,rows);
    psi = csvread(filename,1,4,[1,4,rows,4]); [psi_new] = fix_offset(psi,0,0); psi = psi_new;
    r = csvread(filename,1,6,[1,6,rows,6]); [r_new] = fix_offset(r,0,0); r = r_new;
    u = csvread(filename,1,7,[1,7,rows,7]); [u_new] = fix_offset(u,0,0); u = u_new;
    z_oe = [psi,r];
    
    % Initial Conditions
    xs=lsmep(z_oe(:,[1:2]));
    x0=xs(1,:)';
    
    % Ouput Error Algorithm
    [y_oe,p_oe,crb_oe,~]=oe(model,obs,u,t_oe,x0,0,z_oe);
    
    % Plot results of output error estimation
    subplot(3,1,1),plot(t,z_oe(:,1),t,y_oe(:,1),'--','LineWidth',1.5),ylim([-1 1]),title("YAW: Model vs. Actual"),
    grid on;ylabel('yaw (rad)'),legend('data','model'),
    subplot(3,1,2),plot(t,z_oe(:,2),t,y_oe(:,2),'--','LineWidth',1.5),ylim([-2 2])
    grid on;ylabel('r (rad/s)'),legend('data','model'),
    subplot(3,1,3),plot(t,-u,'LineWidth',1.5),ylim([-0.4 0.4])
    grid on;ylabel('RC Input (%)'),xlabel('Time (sec)')
    pnames = ["Ny","Nr","Nm"].';
    indx=[1,3,4]';
    
    serr=sqrt(diag(crb_oe));
    model_disp(p_oe(indx),serr(indx),[],[],pnames);
    fprintf('\n\nPress any key to continue ... '),pause,

    % Residuals & RMSE 
    n = zeros(rows,2);
    for i = 1:rows
        for j = 1:2
            n(i,j) = abs(z_oe(i,j)) - abs(y_oe(i,j));
        end
    end
    
    subplot(2,1,1),plot(t,n(:,1),'--','LineWidth',1.5),ylim([-1 1]),title("Residuals"),
    grid on;ylabel('yaw (rad)')
    subplot(2,1,2),plot(t,n(:,2),'--','LineWidth',1.5),ylim([-2 2])
    grid on;ylabel('r (rad/s)');xlabel('Time (sec')
    
    RMSE_Y = sqrt(mean(n(:,1).^2));
    RMSE_R = sqrt(mean(n(:,2).^2));
    RMSE = [RMSE_Y,RMSE_R,"Y","R"];
    X = sprintf("\n\nRMSE: Yaw - %.3f ; R - %.3f",RMSE_Y,RMSE_R);
    disp(X) %#ok<DSPS>
    fprintf('\n\nResidual Plots -- Press any key to continue ... '),pause,

end