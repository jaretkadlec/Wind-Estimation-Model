%-------------------------------------------------------------------------%
%---------------------- Hover Oscillation Tests ---------------------%
%-------------------------------------------------------------------------%
main_roll_tuned = 'ARES Tests/dji/Roll_Model_output.csv';
fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
[~,p_r_T,~] = roll_oe(main_roll_tuned,'roll_23_2345'); 

% main_roll_tuned = 'ARES Tests/Tests_Tuned_Oscillation_Test_1/Roll_Motion_Model_S-256_E-276_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T,~] = roll_oe(main_roll_tuned,'roll_23_245'); 

% main_pitch_tuned = 'ARES Tests/dji/Pitch_Model_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_tuned,'pitch_23_2345');

% main_pitch_tuned = 'ARES Tests/Tests_Tuned_Oscillation_Test_1/Pitch_Motion_Model_S-236_E-256_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_tuned,'pitch_23_245');

% main_yaw_tuned = 'ARES Tests/dji/Yaw_Model_output.csv';
% fprintf("\nYaw Stepwise Regression, Output Error and Observability Analysis")
% [~,p_y_T,~] = yaw_oe(main_yaw_tuned,'yaw');

% main_yaw_tuned = 'ARES Tests/Tests_Tuned_Oscillation_Test_1/Yaw_Motion_Model_S-218_E-238_output.csv';
% fprintf("\nYaw Stepwise Regression, Output Error and Observability Analysis")
% [~,p_y_T,~] = yaw_oe(main_yaw_tuned,'yaw');

% main_plunge_tuned = 'ARES Tests/dji/Plunge_Model_output.csv';
% fprintf("\nPlunge Stepwise Regression, Output Error and Observability Analysis")
% [~,p_pl_T,~] = plunge_oe(main_plunge_tuned,'plunge');
% p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
% p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");

% main_plunge_tuned = 'ARES Tests/Tests_Main_Oscillation_Test/Plunge_Motion_Model_S-135_E-150_output.csv';
% fprintf("\nPlunge Stepwise Regression, Output Error and Observability Analysis")
% [~,p_pl_T,~] = plunge_oe(main_plunge_tuned,'plunge');

%-------------------------------------------------------------------------%
%--------------------------- Validation Tests ----------------------------%
%-------------------------------------------------------------------------%
validate_roll_tuned = 'ARES Tests/Tests_Validation_Test/Roll_Motion_Model_S-123_E-142_output.csv';
%fprintf("\nRoll Validation")
%[RMSEV_r_T] = validate(validate_roll_tuned,'Roll',p_r_T,1);

validate_pitch_tuned = 'ARES Tests/Tests_Validation_Test/Pitch_Motion_Model_S-105_E-125_output.csv';
%fprintf("\nPitch Validation")
%[RMSEV_p_T] = validate(validate_pitch_tuned,'Pitch',p_p_T,1);

validate_yaw_tuned = 'ARES Tests/Tests_Validation_Test/Yaw_Motion_Model_S-90_E-105_output.csv';
%fprintf("\nYaw Validation")
%[RMSEV_y_T] = validate(validate_yaw_tuned,'Yaw',p_y_T,1);

validate_plunge_tuned = 'ARES Tests/Tests_Validation_Test/Plunge_Motion_Model_S-68_E-84_output.csv';
%fprintf("\nPlunge Validation")
%[RMSEV_pl_T] = validate(validate_plunge_tuned,'Plunge',p_pl_T,1);

%-------------------------------------------------------------------------%
%---------------------------- Wind Estimation ----------------------------%
%-------------------------------------------------------------------------%
% Wind Validation 1
% -----------------
full_model_tuned = 'ARES Tests/New_Hover_Model/Full_Model_S-10364920_E-10382920_output.csv'; 
validation_file = 'ARES Tests/New_Hover_Model/Luft_Wind_Data_S-10364920_E-10382915_output.csv'; 

% Wind Validation 2
% -----------------
%full_model_tuned = 'ARES Tests/Wind_Validation_Tests_H2/Full_Model_output.csv'; 
%validation_file = 'ARES Tests/Wind_Validation_Tests_H2/Luft_Wind_Data_S-104432_E-105002_output.csv'; 

% param = readFromFile("ARES Tests/.txt");
param_T = coefficients(p_p_T,p_r_T,p_y_T,p_pl_T);
obsv_chk(param_T);
% [twa_T,ywa_T,Vw_T] = windspd(full_model_tuned,validation_file,param_T);
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%