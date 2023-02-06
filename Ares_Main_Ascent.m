%-------------------------------------------------------------------------%
%----------------------- Ascent Oscillation Tests ------------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Tests
% -------------------
% 4 m/s
% -----
%
% Need New 4 m/s data
%main_pitch_2 = 'Ascent_Test_7_09_4ms/Pitch_Motion_Model_S-457_E-465_output.csv';
%fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
%[~,p_p_T_1,~] = pitch_oe(main_pitch_2,'pitch_2_2345');

%-------------------------------------------------------------------------%
% Roll Ascent Tests
% ------------------
% 4 m/s
%
% Need new 4 m/s data

main_roll_10 = 'Ascent_Tests_7_09_4ms/Roll_Motion_Model_S-696_E-708_output.csv';
fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
[~,p_r_T,~] = roll_oe(main_roll_10,'roll_23_245');
%-------------------------------------------------------------------------%
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
% p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
% p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");
%-------------------------------------------------------------------------%
% Wind Estimation 
% ---------------
% param_T = coefficients(p_p, p_r, p_y_T, p_pl_T);
% writeToFile(param_T,"ARES Tests/initial_half_ms_model_params.txt");
% obsv_chk(param_T);
%-------------------------------------------------------------------------%
%-------------------------------------------------------------------------%