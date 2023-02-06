%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests 5 m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
%------------------
% main_pitch_50 = 'ARES Tests/New_5ms_Model/Pitch_Motion_Model_S-11274060_E-11280060_output.csv';
% % main_pitch_50 = 'ARES Tests/Ascent_Tests_5ms_Validation/Pitch_Motion_Model_S-13341780_E-13342780_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis");
% % [~,p_p_T,~] = pitch_oe(main_pitch_50,'pitch_2_245');
% [~,p_p_T,~] = pitch_oe(main_pitch_50,'pitch_2_245');

% main_pitch_50_53_11am = 'ARES Tests/balloon_11am/Pitch_Motion_Model_S-11154700_E-11155000_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_50_53_11am,'pitch_2_245');

% main_pitch_660_665 = 'ARES Tests/7_7_22_5ms/Pitch_Motion_Model_S-13584580_E-13585080_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T_2,~] = pitch_oe(main_pitch_660_665,'pitch_2_245');
% 
% main_pitch_660_663 = 'ARES Tests/7_7_22_5ms/Pitch_Motion_Model_S-13584580_E-13584880_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_660_663,'pitch_2_245');

%  param_array = { p_p_T_1, p_p_T_2, p_p_T_3 };
%  p_p = average_parameters(param_array);

% fprintf("\nPitch Validation")
% validate_pitch_50 = 'ARES Tests/Ascent_Tests_6_02_Pitch_5ms/Pitch_Motion_Model_S-285_E-293_output.csv';
% validate_pitch_50 = 'ARES Tests/Ascent_Tests_6_02_Pitch_5ms/Pitch_Motion_Model_S-320_E-329_output.csv';
% validate_pitch_50 = 'ARES Tests/Ascent_Tests_6_02_Pitch_5ms/Pitch_Motion_Model_S-354_E-362_output.csv';
% validate_pitch_50 = 'ARES Tests/Ascent_Tests_6_02_Pitch_5ms/Pitch_Motion_Model_S-604_E-612_output.csv';
% 
% [RMSEV_p_T] = validate(validate_pitch_50,'Pitch',p_p_T,22345);

% -----------------
% Roll Ascent Test 
% -----------------
% main_roll_50 = 'ARES Tests/New_5ms_Model/Roll_Motion_Model_S-93525000_E-93530600_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis");
% [~,p_r_T,~] = roll_oe(main_roll_50,'roll_2_245');

% main_yaw_50 = 'ARES Tests/New_5ms_Model/Yaw_Motion_Model_S-93532500_E-93534000_output.csv';
% fprintf("\nYaw Stepwise Regression, Output Error and Observability Analysis");
% [~,p_y_T,~] = yaw_oe(main_yaw_50,'yaw2');


% fprintf("\nRoll Validation")
% validate_roll_50 = 'ARES Tests/Ascent_Tests_5_27/Roll_Motion_Model_S-2234_E-2244_output.csv';
% validate_roll_50 = 'ARES Tests/Ascent_Tests_6_02_5ms/Roll_Motion_Model_S-588_E-598_output.csv';
% validate_roll_50 = 'ARES Tests/Wind_Validation_Tests/Roll_Motion_Model_S-91870000_E-91870500_output.csv';
% % 
% [RMSEV_r_T] = validate(validate_roll_50,'Roll',p_r_T,22345);

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
% main_plunge_50 = 'ARES Tests/New_5ms_Model/Plunge_Motion_Model_S-93543300_E-93544700_output.csv';
% fprintf("\nPlunge Stepwise Regression, Output Error and Observability Analysis");
% [~,p_pl_T,~] = plunge_oe(main_plunge_50,'plunge2');
%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
% 
% full_model_file = 'ARES Tests/Ascent_Tests_5ms_Validation/Full_Model_S-502_E-555_output.csv';
% validation_file = 'ARES Tests/Ascent_Tests_5ms_Validation/Luft_Wind_Data_S-11280200_E-11285500_output.csv';
% param_T = coefficients(p_p_T,p_r_T,p_y_T,p_pl_T);
% param_T = readFromFile("ARES Tests/initial_5ms_model_params.txt");
% obsv_chk(param_T);

% 5ms ascent from 7/13/21
param = readFromFile("ARES Tests/initial_5ms_model_params.txt");
% param = readFromFile("ARES Tests/9am_balloon_5ms_model_params.txt");
% obsv_chk(param);
full_model = 'ARES Tests/7_7_22_5ms/Full_Model_S-13584080_E-13585580_output.csv';
luft_file = 'ARES Tests/7_7_22_5ms/luft_7_7_22_655_670.csv'; 
% ---

% full_model = 'ARES Tests/balloon_9am/Full_Model_S-91862500_E-91871500_output.csv';
% luft_file = 'ARES Tests/balloon_9am/9am_radiosonde_25_75_data.csv';
 
% ST_file = 'ARES Tests/Ascent_Tests_5ms_Validation/Luft_Wind_Data_S-131218_E-131248_output_ST.csv';
% Ascent_Luft_ST_Validation(full_model, luft_file, ST_file, param_T);

% full_model = 'ARES Tests/Ascent_Tests_2018_Flights/Full_Model_S-112_E-420_output_09.csv';
% ST_file = 'ARES Tests/Ascent_Tests_2018_Flights/Luft_Wind_Data_S-9172100_E-9263650_output.csv';

% Ascent_Validation_Flight(full_model, param);
Ascent_Validation_Luft(full_model, luft_file, param);
% Automated_Model(full_model,luft_file,param);
% Ascent_Validation_Luft_ST(full_model, luft_file, ST_file, param);
%-------------------------------------------------------------------------%