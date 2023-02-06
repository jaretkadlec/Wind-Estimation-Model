function [y_oe,p_oe,RMSE] = roll_oe(filename,model)

    M = csvread(filename,1,2);
    [rows,cols] = size(M);
    if (cols == 8) 
        cols = cols - 1;
    end
    
    % Stepwise Regression Variables
    z = csvread(filename,1,2,[1,2,rows,2]);         % rotational acceleration
    [z_new] = fix_offset(z,0,0); z = z_new;
    dv = csvread(filename,1,3,[1,3,rows,3]);        % translational acceleration
    [dv_new] = fix_offset(dv,0,0); dv = dv_new;
    % zero-center x
    x = csvread(filename,1,4,[1,4,rows,cols+1]);    % regressor matrix
    [pos_fix] = fix_offset(x,1,0);
    [roll_fix] = fix_offset(pos_fix,2,0);
    [vel_fix] = fix_offset(roll_fix,3,0);
    [rate_fix] = fix_offset(vel_fix,4,0);
    [input_fix] = fix_offset(rate_fix,5,1);
    x = input_fix;
    % zero-center x_v
    x_v = csvread(filename,1,4,[1,4,rows,cols]);     % regressor matrix for translational regression
    
    [xv_pos_fix] = fix_offset(x_v,1,0);
    [xv_roll_fix] = fix_offset(xv_pos_fix,2,0);
    [xv_vel_fix] = fix_offset(xv_roll_fix,3,0);
    [xv_rate_fix] = fix_offset(xv_vel_fix,4,0);
    x_v = xv_rate_fix;

    % Translational Regression 
    t=[1:rows]';
    fprintf('\n\nPart 1: Translational Model Regression')
    subplot(4,1,1),plot(t,x_v(:,1),'LineWidth',1.5),grid on;ylabel('y (m)'),title('Regressors');
    subplot(4,1,2),plot(t,x_v(:,2),'LineWidth',1.5),grid on;ylabel('roll (rad)')
    subplot(4,1,3),plot(t,x_v(:,3),'LineWidth',1.5),grid on;ylabel('vy (m/s)')
    subplot(4,1,4),plot(t,x_v(:,4),'LineWidth',1.5),grid on;ylabel('p (rad/s)')
    xlabel('time (s)')
    fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,

    subplot(1,1,1),plot(t,dv),grid on,ylabel('Translational Acceleration'),xlabel('index'),title('Measured Output Vector')
    fprintf('\n\nMeasured Output Plot -- Press any key to continue ... '),pause,

    [~,p_t,~,~,~,~] = swr(x_v,dv,1);
    
    % Rotational Model Regresssion
    fprintf('\n\nPart 2: Rotational Model Regression')
    subplot(5,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('y (m)'),title('Regressors');
    subplot(5,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('roll (rad)')
    subplot(5,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('vy (m/s)')
    subplot(5,1,4),plot(t,x(:,4),'LineWidth',1.5),grid on;ylabel('p (rad/s)')
    subplot(5,1,5),plot(t,x(:,5),'LineWidth',1.5),grid on;ylabel('µ roll (%)')
    xlabel('time (s)')

    fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,

    % Measured Output Plot
    subplot(1,1,1),plot(t,z),grid on,ylabel('Angular/Translational Acceleration'),xlabel('index'),title('Measured Output Vector'),
    fprintf('\n\nMeasured Output Plot -- Press any key to continue ... '),pause,

    % Stepwise Regression Statement
    [~,p_r,~,~,~,~] = swr(x,z,1);
    fprintf('\n\nPress any key to continue ... '),pause,

    % Combining coefficient estimate outputs from translational regression and
    % rotational regression into one array for output error
    p = zeros(size(p_t,1) + size(p_r,1),1);
    for i = 1:(size(p_t,1) + size(p_r,1))
        if i <= size(p_t,1)
            p(i) = p_t(i);
        elseif (i > (size(p_t,1)))
            p(i) = p_r(i-size(p_t,1));
        end
    end

    % Instantiating Output Error Variables
    t_oe = linspace(0,(rows/20)-0.05,rows);
    vel = csvread(filename,1,6,[1,6,rows,6]); [new_vel] = fix_offset(vel,0,0); vel = new_vel;
    rate = csvread(filename,1,7,[1,7,rows,7]); [new_rate] = fix_offset(rate,0,0); rate = new_rate;
    roll_angle = csvread(filename,1,5,[1,5,rows,5]); [new_roll] = fix_offset(roll_angle,0,0); roll_angle = new_roll;
    u = csvread(filename,1,8,[1,8,rows,8]); [new_u] = fix_offset(u,0,0); u = new_u;
    z_oe = [vel,rate,roll_angle];

    % Initial Conditions
    xs=lsmep(z_oe(:,[1:3]));
    x0=xs(1,:)';

    % Output Error Algorithm
    [y_oe,p_oe,crb_oe,~]=oe(model,p,u,t_oe,x0,0,z_oe);

    % Plot results of output error estimation
    subplot(4,1,1),plot(t,z_oe(:,1),t,y_oe(:,1),'--','LineWidth',1.5),title("ROLL: Model vs. Actual"),
    grid on;ylabel('vy (m/s)'),legend('data','model'),
    subplot(4,1,2),plot(t,z_oe(:,2),t,y_oe(:,2),'--','LineWidth',1.5)
    grid on;ylabel('p (rad/s)'),legend('data','model')
    subplot(4,1,3),plot(t,z_oe(:,3),t,y_oe(:,3),'--','LineWidth',1.5)
    grid on;ylabel('roll (rad)'),xlabel('Time (sec)'),legend('data','model')
    subplot(4,1,4),plot(t,u,'LineWidth',1.5)
    grid on;ylabel('RC Input (%)'),xlabel('Time (sec)')
    pnames = ["Yphi","Yv","Yp","Lphi","Lv","Lp","Lm"].';
    indx=[2,3,4,7,8,9,10]';

    serr=sqrt(diag(crb_oe));
    model_disp(p_oe(indx),serr(indx),[],[],pnames);
    fprintf('\n\nPress any key to continue ... '),pause,
    
    % Residuals & RMSE 
    n = zeros(rows);
    for i = 1:rows
        for j = 1:3
            n(i,j) = abs(z_oe(i,j)) - abs(y_oe(i,j));
        end
    end
    
    subplot(3,1,1),plot(t,n(:,1),'--','LineWidth',1.5),ylim([-2 2]),title("Residuals"),
    grid on;ylabel('vy (m/s)')
    subplot(3,1,2),plot(t,n(:,2),'--','LineWidth',1.5),ylim([-2 2])
    grid on;ylabel('p (rad/s)')
    subplot(3,1,3),plot(t,n(:,3),'--','LineWidth',1.5),ylim([-.4 .4])
    grid on;ylabel('roll (rad)'),xlabel('Time (sec)')
    
    RMSE_V = sqrt(mean(n(:,1).^2));
    RMSE_P = sqrt(mean(n(:,2).^2));
    RMSE_R = sqrt(mean(n(:,3).^2));
    RMSE = [RMSE_V,RMSE_P,RMSE_R,"V","P","R"];
    X = sprintf("\n\nRMSE: VY - %.3f ; P - %.3f ; Roll - %.3f",RMSE_V,RMSE_P,RMSE_R);
    disp(X) %#ok<DSPS>
    fprintf('\n\nResidual Plots -- Press any key to continue ... '),pause,
   
end