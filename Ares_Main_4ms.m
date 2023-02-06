%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests 1 m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
% ------------------
% main_pitch_1 = 'ARES Tests/Ascent_Tests_7_09_4ms/Pitch_Motion_Model_S-457_E-468_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_1,'pitch_2_2345');

% main_pitch_2 = 'ARES Tests/Ascent_Tests_7_09_4ms/Pitch_Motion_Model_S-480_E-495_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_1,~] = pitch_oe(main_pitch_2,'pitch_23_245');
% 
% main_pitch_3 = 'ARES Tests/Ascent_Tests_7_09_4ms/Pitch_Motion_Model_S-517_E-525_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_2,~] = pitch_oe(main_pitch_3,'pitch_23_245');
% 
% main_pitch_4 = 'ARES Tests/Ascent_Tests_7_09_4ms/Pitch_Motion_Model_S-555_E-565_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_3,~] = pitch_oe(main_pitch_4,'pitch_23_245');

% param_array = { p_p_T, p_p_T_2, p_p_T_3 };
% p_p = average_parameters(param_array);

% -----------------
% Roll Ascent Test 
% -----------------
main_roll_1 = 'ARES Tests/Ascent_Tests_7_09_4ms/Roll_Motion_Model_S-10390800_E-10391200_output.csv';
fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
[~,p_r_T_1,~] = roll_oe(main_roll_1,'roll_23_2345');
% 
% main_roll_2 = 'ARES Tests/Ascent_Tests_7_09_4ms/Roll_Motion_Model_S-782_E-790_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T,~] = roll_oe(main_roll_2,'roll_23_245');

% param_array = { p_r_T, p_r_T_1 };
% p_r = average_parameters(param_array);

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
% p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
% p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
% param_T = coefficients(p_p,p_r_T,p_y_T,p_pl_T);
% param_T = readFromFile("ARES Tests/initial_4ms_model_params.txt").';
% windspd(full_model_file, validation_file,param_T);
% obsv_chk(param_T);
%-------------------------------------------------------------------------%