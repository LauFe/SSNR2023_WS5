function [Muscle_list, F0M_list, l0M_list, lsT_list, time_list, LMT_list, L_flexion, L_deviation] = load_MSK_data()
% The list of the 43 muscles...
Muscle_list = load('.\Input_data\Muscle_list.mat');
Muscle_list = Muscle_list.Muscle_list;
% Their physiological properties F0M, l0M, lsT...
Muscle_properties = load('.\Input_data\Muscle_properties.mat');
F0M_list = Muscle_properties.Muscle_properties(1,:); %1x43 vector of maximum muscle forces
l0M_list = Muscle_properties.Muscle_properties(2,:); %1x43 vector of optimal fibre lengths
lsT_list = Muscle_properties.Muscle_properties(3,:); %1x43 vector of tendon slack lengths

%time list
time = load('.\Input_data\time.mat');
time_list = time.time;


% Their muscle-tendon lengths lMT measured during the wrist motion...
LMT = load('.\Input_data\lMT.mat');
LMT_list = LMT.LMT_lengths; %Nx43 matrix of the time-histories of the muscle-tendon lengths LMT(t) obtained with the motion-driven MSK model
% Their moment arm with the wrist joint for flexion (+) /extension (-)
L_flexion = load('.\Input_data\L_flex.mat');
L_flexion = L_flexion.L_flex;
% Their moment arm with the wrist joint for abduction (inward, +) /adduction (-)
L_deviation = load('.\Input_data\L_dev.mat');
L_deviation = L_deviation.L_dev;
end