%-------------------------------------------------------------------------%
%---------------------- Hover Oscillation Tests ---------------------%
%-------------------------------------------------------------------------%
% roll_file = "file path"
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T,~] = roll_oe(roll_file, MODEL STRING ex. 'roll_23_245');

% pitch_file = "file path"
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(pitch_file, MODEL STRING ex. 'pitch_23_245');

% yaw_file = "file path"
% fprintf("\nYaw Stepwise Regression, Output Error and Observability Analysis")
% [~,p_y_T,~] = yaw_oe(yaw_file,MODEL STRING ex. 'yaw2');

% plunge_file = "file path"
% fprintf("\nPlunge Stepwise Regression, Output Error and Observability Analysis")
% [~,p_pl_T,~] = plunge_oe(plunge_file,MODEL STRING ex. 'plunge');

%-------------------------------------------------------------------------%
%--------------------------- Validation Tests ----------------------------%
%-------------------------------------------------------------------------%
% validate_roll = "file path"
% fprintf("\nRoll Validation")
% [RMSEV_r_T] = validate(validate_roll,'Roll',p_r_T,1);

% validate_pitch = "file path"
% fprintf("\nPitch Validation")
% [RMSEV_p_T] = validate(validate_pitch,'Pitch',p_p_T,1);

% validate_yaw = "file path"
% fprintf("\nYaw Validation")
% [RMSEV_y_T] = validate(validate_yaw,'Yaw',p_y_T,1);

% validate_plunge = "file path"
% fprintf("\nPlunge Validation")
% [RMSEV_pl_T] = validate(validate_plunge,'Plunge',p_pl_T,1);

%-------------------------------------------------------------------------%
%---------------------------- Wind Estimation ----------------------------%
%-------------------------------------------------------------------------%
% Wind Validation 1
% -----------------
% full_model = "file path"
% validation_file = "file path"

% Parameter Array Options: Created After Analysis or Read From File
% param_T = coefficients(p_p_T,p_r_T,p_y_T,p_pl_T);
% param_T = readFromFile("file path").';

% [twa_T,ywa_T,Vw_T] = windspd(full_model,validation_file,param_T);
% Hover_Validation_Flight(full_model,param_T);
% Hover_Validation_Luft(full_model,validation_file,param_T);
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%