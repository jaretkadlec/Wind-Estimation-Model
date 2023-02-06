%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests 5 m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
% ------------------
% main_pitch_05 = 'ARES Tests/7_7_22_halfms/Pitch_Motion_Model_S-13501080_E-13502080_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_2,~] = pitch_oe(main_pitch_05,'pitch_2_245');
% 
% main_pitch_05 = 'ARES Tests/Ascent_Tests_HalfNOneMS/Pitch_Motion_Model_S-590_E-610_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_3,~] = pitch_oe(main_pitch_05,'pitch_2_2345');
% 
% main_pitch_05 = 'ARES Tests/Ascent_Tests_HalfNOneMS/Pitch_Motion_Model_S-612_E-625_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_4,~] = pitch_oe(main_pitch_05,'pitch_2_2345');
% 
% param_array = { p_p_T_2, p_p_T_3, p_p_T_4 };
% p_p = average_parameters(param_array);

% fprintf("\nPitch Validation")
% 
% validation_file = "ARES Tests/Ascent_Tests_HalfNOneMS/Pitch_Motion_Model_S-523_E-540_output.csv";
% [RMSEV_p_T] = validate(validation_file,'Pitch',p_p,22345);

% -----------------
% Roll Ascent Test 
% -----------------
% main_roll_05 = 'ARES Tests/7_7_22_halfms/Roll_Motion_Model_S-13501080_E-13502080_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T,~] = roll_oe(main_roll_05,'roll_2_245');
% 
% main_roll_05 = 'ARES Tests/Ascent_Tests_HalfNOneMS/Roll_Motion_Model_S-672_E-685_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T_2,~] = roll_oe(main_roll_05,'roll_23_245');
% 
% main_roll_05 = 'ARES Tests/Ascent_Tests_HalfNOneMS/Roll_Motion_Model_S-685_E-700_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T_3,~] = roll_oe(main_roll_05,'roll_23_245');
% 
% param_array = { p_r_T, p_r_T_2, p_r_T_3 };
% p_r = average_parameters(param_array);

% fprintf("\nRoll Validation")
% 
% [RMSEV_r_T] = validate(validate_roll_50,'Roll',p_r_T,23245);

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
param_T = coefficients(p_p_T_2,p_r_T,p_y_T,p_pl_T);
% windspd(full_model_file, validation_file,param_T);
obsv_chk(param_T);
%-------------------------------------------------------------------------%