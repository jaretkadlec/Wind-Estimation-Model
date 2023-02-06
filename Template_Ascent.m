%-------------------------------------------------------------------------%
%-------------------- Ascent Oscillation Tests # m/s ---------------------%
%-------------------------------------------------------------------------%
% Pitch Ascent Test 
% ------------------
% main_pitch = "File Path";
% fprintf("\nPitch Stepwise Regression, Output Error and Observability Analysis")
% [~,p_p,~] = pitch_oe(main_pitch, MODEL FORMAT STRING ex.'pitch_23_2345');

% -----------------
% Roll Ascent Test 
% -----------------
% main_roll = "File Path";
% fprintf("\nRoll Stepwise Regression, Output Error and Observability Analysis")
% [~,p_r_T_1,~] = roll_oe(main_roll, MODEL FORMAT STRING ex. 'roll_23_245');

% ---------------------------------------
% Yaw & Plunge Identifications From Hover
% ---------------------------------------
% p_y_T = readFromFile("ARES Tests/hover_yaw_parameters.txt");
% p_pl_T = readFromFile("ARES Tests/hover_plunge_parameters.txt");

%-------------------------------------------------------------------------%
% Wind Estimation
% ---------------
% full_model = "File Path";
% luft_file = "File Path";

% param_T = readFromFile("File Path");
% Ascent_Validation_Flight(full_model, param_T);
% Ascent_Validaiton_Luft(full_model, luft_file, param_T);
% obsv_chk(param_T);
%-------------------------------------------------------------------------%