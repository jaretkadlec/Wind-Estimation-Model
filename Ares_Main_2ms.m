%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests 2 m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
% ------------------
% main_pitch_20 = 'ARES Tests/Ascent_Tests_3_12/Pitch_Motion_Model_S-1764_E-1780_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_20,'pitch_23_245');

% fprintf("\nPitch Validation")
% validate_pitch_20 = 'ARES Tests/Ascent_Tests_4_16/Pitch_Motion_Model_S-1237_E-1252_output.csv';
% [RMSEV_p_T] = validate(validate_pitch_30,'Pitch',p_p_T,23245);

% -----------------
% Roll Ascent Test 
% -----------------
% main_roll_20 = 'ARES Tests/Ascent_Tests_4_16/Roll_Motion_Model_S-1413_E-1427_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T,~] = roll_oe(main_roll_20,'roll_23_245');

% fprintf("\nRoll Validation")
% validate_roll_20 = 'ARES Tests/Ascent_Tests_4_16/Roll_Motion_Model_S-1325_E-1336_output.csv';
% [RMSEV_r_T] = validate(validate_roll_10,'Roll',p_r_T,23245);

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
% p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
% p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
param_T = readFromFile("ARES Tests/initial_2ms_model_params.txt").';
full_model_file = "ARES Tests/Wind_Validation_Tests/Full_Model_output.csv";
validation_file = "ARES Tests/Wind_Validation_Tests/Luft_Wind_Data_S-134822_E-135310_output.csv";
windspd(full_model_file, validation_file,param_T);
%obsv_chk(param_T);
%-------------------------------------------------------------------------%