%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests 3 m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
% ------------------
% main_pitch_30 = 'ARES Tests/Ascent_Tests_4_16/Pitch_Motion_Model_S-1600_E-1612_output.csv';
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p_T,~] = pitch_oe(main_pitch_30,'pitch_23_245');

% fprintf("\nPitch Validation")
% validate_pitch_30 = 'ARES Tests/Ascent_Tests_4_16/Pitch_Motion_Model_S-1719_E-1732_output.csv';
% [RMSEV_p_T] = validate(validate_pitch_30,'Pitch',p_p_T,23245);

% -----------------
% Roll Ascent Test 
% -----------------
% main_roll_30 = 'ARES Tests/Ascent_Tests_4_16/Roll_Motion_Model_S-1871_E-1884_output.csv';
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T,~] = roll_oe(main_roll_30,'roll_23_245');

% fprintf("\nRoll Validation")
% validate_roll_30 = 'ARES Tests/Ascent_Tests_4_16/Roll_Motion_Model_S-1827_E-1843_output.csv';
% [RMSEV_r_T] = validate(validate_roll_30,'Roll',p_r_T,23245);

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
% p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
% p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
%param_T = readFromFile("ARES Tests/initial_3ms_model_params.txt").';
%obsv_chk(param_T);
%-------------------------------------------------------------------------%