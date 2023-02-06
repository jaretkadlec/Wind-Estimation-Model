function [y_oe,p_oe,RMSE] = plunge_oe(filename,model)

    M = csvread(filename,1,2);
    [rows,cols] = size(M);
    if (cols == 5) 
        cols = cols - 1;
    end
    
    % Stepwise Regression Variables
    z = csvread(filename,1,2,[1,2,rows,2]);         % translational acceleration
    [z_new] = fix_offset(z,0,0); z = z_new;
    x = csvread(filename,1,3,[1,3,rows,cols+1]);    % regressor matrix
    [x_pos] = fix_offset(x,1,0);
    [x_vel] = fix_offset(x_pos,2,0);
    [x_input] = fix_offset(x_vel,3,1);
    x = x_input;

    % Translational Model Regresssion
    t=[1:rows]';
    fprintf('\n\nPart 1: Translational Model Regression')
    subplot(3,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('z (m)'),ylim([-3 3]),title('Regressors');
    subplot(3,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('w (m/s)'),ylim([-3 3])
    subplot(3,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('µ plunge (%)'),ylim([-.4 .4])
    xlabel('time (s)'),
    fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,
    
    % Measured Output Plot
    subplot(1,1,1),plot(t,z),grid on,ylabel('Translational Acceleration'),xlabel('index'),ylim([-4 4]),title('Measured Output Vector'),
    fprintf('\n\n Measured Output Plot -- Press any key to continue ... '),pause,

    % Stepwise Regression Statement
    [~,p_r,~,~,~,~] = swr(x,z,1);
    fprintf('\n\nPress any key to continue ... '),pause,
    
    % Instatiating parameter estimate variable (only dependent on p_r)
    p = p_r;
    
    % Instantiating Output Error Variables
    t_oe = linspace(0,(rows/20)-0.05,rows);
    z_oe = csvread(filename,1,4,[1,4,rows,4]);[z_oe_new] = fix_offset(z_oe,0,0); z_oe = z_oe_new;
    u = csvread(filename,1,5,[1,5,rows,5]);[u_new] = fix_offset(u,0,1); u = u_new;
    
    % Initial Conditions
    xs=lsmep(z_oe(:,[1:1]));
    x0=xs(1,:)';
    
    % Output Error Algorithm
    [y_oe,p_oe,crb_oe,~]=oe(model,p,u,t_oe,x0,0,z_oe);
    
    % Plot results of output error estimation
    subplot(2,1,1),plot(t,z_oe(:,1),t,y_oe(:,1),'--','LineWidth',1.5),ylim([-4 4]),title("PLUNGE: Model vs. Actual"),
    grid on;ylabel('vz (m/s)'),xlabel('Time (sec)'),legend('data','model'),
    subplot(2,1,2),plot(t,u,'LineWidth',1.5),ylim([-.4 .4])
    grid on;ylabel('RC Input (%)'),xlabel('Time (sec)')
    pnames = ["dw","dm"].';
    indx=[2,3]';
    
    serr=sqrt(diag(crb_oe));
    model_disp(p_oe(indx),serr(indx),[],[],pnames);
    fprintf('\n\nPress any key to continue ... '),pause,
    
    % Residuals & RMSE 
    n = zeros(rows);
    for i = 1:rows
        n(i) = abs(z_oe(i)) - abs(y_oe(i));
    end
    
    % Model Result Plots
    subplot(2,1,1),plot(t,n(:,1),'--','LineWidth',1.5),ylim([-4 4]),title("Residuals"),
    grid on;ylabel('vz (m/s)'),xlabel('Time (sec)')
    subplot(2,1,2),plot(t,u,'LineWidth',1.5),ylim([-.4 .4])
    grid on;ylabel('RC Input (%)'),xlabel('Time (sec)')
    
    % RMSE & Residuals
    RMSE_V = sqrt(mean(n(:,1).^2));
    RMSE = [RMSE_V,"W"];
    X = sprintf("\n\nRMSE: VZ - %.3f",RMSE_V);
    disp(X) %#ok<DSPS>
    fprintf('\n\nResidual Plots -- Press any key to continue ... '),pause,

end