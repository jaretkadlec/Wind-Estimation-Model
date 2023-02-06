%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests 1 m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
% ------------------
% main_pitch_1 = 'ARES Tests/7_7_22_1ms/Pitch_Motion_Model_S-13515080_E-13515580_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p,~] = pitch_oe(main_pitch_1,'pitch_2_245');

% -----------------
% Roll Ascent Test 
% -----------------
% main_roll = 'ARES Tests/Ascent_Tests_4_16/Roll_Motion_Model_S-694_E-711_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r,~] = roll_oe(main_roll,'roll_23_245');

% main_roll = 'ARES Tests/7_7_22_1ms/Roll_Motion_Model_S-13515080_E-13515580_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r,~] = roll_oe(main_roll,'roll_23_245');

% param_array = { p_r_T_1, p_r_T_2 };
% p_r = average_parameters(param_array);

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
% param_T = readFromFile("ARES Tests/initial_1ms_model_params.txt");
param_T = coefficients(p_p,p_r,p_y_T,p_pl_T);
full_model = "ARES Tests/Wind_Validation_Tests/Full_Model_output.csv";
luft_file = "ARES Tests/Wind_Validation_Tests/Luft_Wind_Data_S-134822_E-135310_output.csv";
Ascent_Validation_Luft(full_model, luft_file, param_T);
% windspd(full_model_file, validation_file,param_T);
% obsv_chk(param_T);
%-------------------------------------------------------------------------%