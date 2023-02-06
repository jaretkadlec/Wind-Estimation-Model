
function [RMSE] = validate(filename,motion,p_oe,option)
    
    M = csvread(filename,1,2);
    [rows,cols] = size(M);
    t = linspace(0,(rows/20)-0.05,rows);
    
    if (strcmp(motion,'Roll'))
        x = csvread(filename,1,4,[1,4,rows,cols+1]);    % regressor matrix
        [pos_fix] = fix_offset(x,1,0);
        [roll_fix] = fix_offset(pos_fix,2,0);
        [vel_fix] = fix_offset(roll_fix,3,0);
        [rate_fix] = fix_offset(vel_fix,4,0);
        [input_fix] = fix_offset(rate_fix,5,1);
        x = input_fix;
        
        subplot(5,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('y (m)'),title('Regressors');
        subplot(5,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('roll (rad)')
        subplot(5,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('v (m/s)')
        subplot(5,1,4),plot(t,x(:,4),'LineWidth',1.5),grid on;ylabel('p (rad/s)')
        subplot(5,1,5),plot(t,x(:,5),'LineWidth',1.5),grid on;ylabel('µ roll (%)'),ylim([-.4 .4])
        xlabel('time (s)')
        fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,
        
        vel = csvread(filename,1,6,[1,6,rows,6]);
        [new_vel] = fix_offset(vel,0,0);
        vel = new_vel;
        rate = csvread(filename,1,7,[1,7,rows,7]);
        [new_rate] = fix_offset(rate,0,0);
        rate = new_rate;
        roll_angle = csvread(filename,1,5,[1,5,rows,5]);
        [new_roll] = fix_offset(roll_angle,0,0);
        roll_angle = new_roll;
        z = [vel,rate,roll_angle];
        u = csvread(filename,1,8,[1,8,rows,8]);
        [new_u] = fix_offset(u,0,0);
        u = new_u;
        xs=lsmep(z(:,[1:3]));
        x0=xs(1,:)';
        
        if (option == 0)
            [y,~,~,~,~,~] = roll(p_oe,u,t,x0,0);
        elseif (option == 1)
            [y,~,~,~,~,~] = roll2(p_oe,u,t,x0,0);
        elseif (option == 2245)
            [y,~,~,~,~,~] = roll_2_245(p_oe,u,t,x0,0);
        elseif (option == 22345)
            [y,~,~,~,~,~] = roll_2_2345(p_oe,u,t,x0,0);
        elseif (option == 23245)
            [y,~,~,~,~,~] = roll_23_245(p_oe,u,t,x0,0);
        elseif (option == 232345)
            [y,~,~,~,~,~] = roll_23_2345(p_oe,u,t,x0,0);
        end
        
        subplot(3,1,1),plot(t,z(:,1),t,y(:,1),'--','LineWidth',1.5),title("ROLL VALIDATION: Model vs. Actual"),
        grid on;ylabel('vy (m/s)'),legend('data','model'),
        subplot(3,1,2),plot(t,z(:,2),t,y(:,2),'--','LineWidth',1.5)
        grid on;ylabel('p (rad/s)'),legend('data','model'),
        subplot(3,1,3),plot(t,z(:,3),t,y(:,3),'--','LineWidth',1.5)
        grid on;ylabel('roll (rad)'),xlabel('Time (sec)'),legend('data','model'),
        fprintf('\n\nValidation Plots -- Press any key to continue ... \n'),pause,
        
        n = zeros(rows);
        for i = 1:rows
            for j = 1:3
                n(i,j) = abs(z(i,j)) - abs(y(i,j));
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
        
    elseif (strcmp(motion,'Pitch'))
        x = csvread(filename,1,4,[1,4,rows,cols+1]);    % regressor matrix
        [pos_fix] = fix_offset(x,1,0);
        [pitch_fix] = fix_offset(pos_fix,2,0);
        [vel_fix] = fix_offset(pitch_fix,3,0);
        [rate_fix] = fix_offset(vel_fix,4,0);
        [input_fix] = fix_offset(rate_fix,5,1);
        x = input_fix;
        
        subplot(5,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('x (m)'),title('Regressors');
        subplot(5,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('pitch (rad)')
        subplot(5,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('u (m/s)')
        subplot(5,1,4),plot(t,x(:,4),'LineWidth',1.5),grid on;ylabel('q (rad/s)')
        subplot(5,1,5),plot(t,x(:,5),'LineWidth',1.5),grid on;ylabel('µ pitch (%)'),ylim([-.4 .4])
        xlabel('time (s)')
        fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,
    
        vel = csvread(filename,1,6,[1,6,rows,6]);
        [new_vel] = fix_offset(vel,0,0);
        vel = new_vel;
        rate = csvread(filename,1,7,[1,7,rows,7]);
        [new_rate] = fix_offset(rate,0,0);
        rate = new_rate;
        pitch_angle = csvread(filename,1,5,[1,5,rows,5]);
        [new_pitch] = fix_offset(pitch_angle,0,0);
        pitch_angle = new_pitch;
        z = [vel,rate,pitch_angle];
        u = csvread(filename,1,8,[1,8,rows,8]);
        [new_u] = fix_offset(u,0,0);
        u = new_u;
        xs=lsmep(z(:,[1:3]));
        x0=xs(1,:)';
        
        if (option == 0)
            [y,~,~,~,~,~] = pitch(p_oe,u,t,x0,0);
        elseif (option == 1)
            [y,~,~,~,~,~] = pitch2(p_oe,u,t,x0,0);
        elseif(option == 2245)
            [y,~,~,~,~,~] = pitch_2_245(p_oe,u,t,x0,0);
        elseif(option == 22345)
            [y,~,~,~,~,~] = pitch_2_2345(p_oe,u,t,x0,0);
        elseif(option == 23245)
            [y,~,~,~,~,~] = pitch_23_245(p_oe,u,t,x0,0);
        elseif(option == 232345)
            [y,~,~,~,~,~] = pitch_23_2345(p_oe,u,t,x0,0);
        end
        
        subplot(3,1,1),plot(t,z(:,1),t,y(:,1),'--','LineWidth',1.5),title("PITCH VALIDATION: Model vs. Actual"),
        grid on;ylabel('u (m/s)'),legend('data','model'),
        subplot(3,1,2),plot(t,z(:,2),t,y(:,2),'--','LineWidth',1.5)
        grid on;ylabel('q (rad/s)'),legend('data','model'),
        subplot(3,1,3),plot(t,z(:,3),t,y(:,3),'--','LineWidth',1.5)
        grid on;ylabel('pitch (rad)'),xlabel('Time (sec)'),legend('data','model'),  
        fprintf('\n\nValidation Plots -- Press any key to continue ... \n'),pause,
        
        n = zeros(rows);
        for i = 1:rows
            for j = 1:3
                n(i,j) = abs(z(i,j)) - abs(y(i,j));
            end
        end

        subplot(3,1,1),plot(t,n(:,1),'--','LineWidth',1.5),ylim([-2 2]),title("Residuals"),
        grid on;ylabel('u (m/s)')
        subplot(3,1,2),plot(t,n(:,2),'--','LineWidth',1.5),ylim([-2 2])
        grid on;ylabel('q (rad/s)')
        subplot(3,1,3),plot(t,n(:,3),'--','LineWidth',1.5),ylim([-.4 .4])
        grid on;ylabel('pitch (rad)'),xlabel('Time (sec)')

        RMSE_U = sqrt(mean(n(:,1).^2));
        RMSE_Q = sqrt(mean(n(:,2).^2));
        RMSE_P = sqrt(mean(n(:,3).^2));
        RMSE = [RMSE_U,RMSE_Q,RMSE_P,"U","Q","P"];
        X = sprintf("\n\nRMSE: U - %.3f ; Q - %.3f ; Pitch - %.3f",RMSE_U,RMSE_Q,RMSE_P);
        disp(X) %#ok<DSPS>
    
    elseif (strcmp(motion,'Yaw'))
        x = csvread(filename,1,4,[1,4,rows,cols+1]);    % regressor matrix
        [psi_fix] = fix_offset(x,1,0);
        [vel_fix] = fix_offset(psi_fix,2,0);
        [rate_fix] = fix_offset(vel_fix,3,0);
        [u_fix] = fix_offset(rate_fix,4,1);
        x = u_fix;
        
        subplot(4,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('yaw (rad)'),ylim([-1 1]),title('Regressors');
        subplot(4,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('v (m/s)')
        subplot(4,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('r (rad/s)'),ylim([-2 2])
        subplot(4,1,4),plot(t,x(:,4),'LineWidth',1.5),grid on;ylabel('µ yaw (%)'),ylim([-.4 .4])
        xlabel('time (s)')
        fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,
        
        psi = csvread(filename,1,4,[1,4,rows,4]);
        [psi_new] = fix_offset(psi,0,0);
        psi = psi_new;
        r = csvread(filename,1,6,[1,6,rows,6]);
        [r_new] = fix_offset(r,0,0);
        r = r_new;
        z = [psi,r];
        u = csvread(filename,1,7,[1,7,rows,7]);
        [u_new] = fix_offset(u,0,0);
        u = u_new;
        xs=lsmep(z(:,[1:2]));
        x0=xs(1,:)';
        
        if (option == 0)
            [y,~,~,~,~,~] = yaw(p_oe,u,t,x0,0);
        elseif (option == 1)
            [y,~,~,~,~,~] = yaw2(p_oe,u,t,x0,0);
        end
        
        subplot(2,1,1),plot(t,z(:,1),t,y(:,1),'--','LineWidth',1.5),title("YAW VALIDATION: Model vs. Actual"),
        grid on;ylabel('yaw (rad)'),legend('data','model'),
        subplot(2,1,2),plot(t,z(:,2),t,y(:,2),'--','LineWidth',1.5)
        grid on;ylabel('r (rad/s)'),xlabel('Time (sec)'),legend('data','model'),
        fprintf('\n\nValidation Plots -- Press any key to continue ... \n'),pause,
        
        n = zeros(rows,2);
        for i = 1:rows
            for j = 1:2
                n(i,j) = abs(z(i,j)) - abs(y(i,j));
            end
        end

        subplot(2,1,1),plot(t,n(:,1),'--','LineWidth',1.5),ylim([-1 1]),title("Residuals"),
        grid on;ylabel('yaw (rad)')
        subplot(2,1,2),plot(t,n(:,2),'--','LineWidth',1.5),ylim([-2 2])
        grid on;ylabel('r (rad/s)'),xlabel('Time (sec)')

        RMSE_Y = sqrt(mean(n(:,1).^2));
        RMSE_R = sqrt(mean(n(:,2).^2));
        RMSE = [RMSE_Y,RMSE_R,"Y","R"];
        X = sprintf("\n\nRMSE: Yaw - %.3f ; R - %.3f",RMSE_Y,RMSE_R);
        disp(X) %#ok<DSPS>
        fprintf('\n\nResidual Plots -- Press any key to continue ... '),pause,
        
    elseif (strcmp(motion,'Plunge'))
        x = csvread(filename,1,3,[1,3,rows,cols+1]);    % regressor matrix
        [x_pos] = fix_offset(x,1,0);
        [x_vel] = fix_offset(x_pos,2,0);
        [x_input] = fix_offset(x_vel,3,1);
        x = x_input;
        
        subplot(3,1,1),plot(t,x(:,1),'LineWidth',1.5),grid on;ylabel('z (m)'),ylim([-3 3]),title('Regressors');
        subplot(3,1,2),plot(t,x(:,2),'LineWidth',1.5),grid on;ylabel('w (m/s)'),ylim([-3 3])
        subplot(3,1,3),plot(t,x(:,3),'LineWidth',1.5),grid on;ylabel('µ plunge (%)'),ylim([-.4 .4])
        xlabel('time (s)'),
        fprintf('\n\nRegressor Plot -- Press any key to continue ... '),pause,
        
        z = csvread(filename,1,4,[1,4,rows,4]);
        [z_new] = fix_offset(z,0,0);
        z = z_new;
        u = csvread(filename,1,5,[1,5,rows,5]);
        [u_new] = fix_offset(u,0,1);
        u = u_new;
        xs=lsmep(z(:,[1:1]));
        x0=xs(1,:)';
        [y,~,~,~,~,~] = plunge(p_oe,u,t,x0,0);
        
        subplot(1,1,1),plot(t,z(:,1),t,y(:,1),'--','LineWidth',1.5),ylim([-4 4]),title("PLUNGE VALIDATION: Model vs. Actual"),
        grid on;ylabel('vz (m/s)'),xlabel('Time (sec)'),legend('data','model'),
        fprintf('\n\nValidation Plots -- Press any key to continue ... \n'),pause,
        
        n = zeros(rows);
        for i = 1:rows
            n(i) = abs(z(i)) - abs(y(i));
        end

        subplot(1,1,1),plot(t,n(:,1),'--','LineWidth',1.5),ylim([-4 4]),title("Residuals"),
        grid on;ylabel('vz (m/s)'),xlabel('Time (sec)')

        RMSE_V = sqrt(mean(n(:,1).^2));
        RMSE = [RMSE_V,"W"];
        X = sprintf("\n\nRMSE: VZ - %.3f",RMSE_V);
        disp(X) %#ok<DSPS>
        fprintf('\n\nResidual Plots -- Press any key to continue ... '),pause,
    
    fprintf("\n")
    end
    
    return
    
