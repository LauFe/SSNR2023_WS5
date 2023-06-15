%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Developing a simple computational model of muscle
% to predict human wrist torques 
% from experimental EMGs and joint angles

% Workshop proposed by Dr. Arnault Caillet, Imperial College London
% Workshop 5 - SSNR2023, Baiona

% Development a computational model of muscle to predict
% wrist torques during flexion/extension and abduction/adduction
% contractions

% Before this model runs:
% (1) Kinematics data, i.e., joint angles, were obtained and transformed  
% into muscle-tendon lengths lMT for the 43 muscles of the forearm and
% hand, using a musculoskeletal (MSK) model in opensim
% (2) EMG data was recorded from the muscles during the task

% For the model to run, you must edit the 4 functions that are
% identified in this code with %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% You can comment/uncomment some sections of the code introduced by 'figure' 
% to plot some variables

%%
clear all
clc
close all

%% 0.LOAD ALL THE INPUTS OBTAINED FROM MSK MODELLING
% Muscle_list : 1x43 list of the 43 muscle names
% Muscle properties:
%   F0M_list: 1x43 vector of maximum muscle forces
%   l0M_list: 1x43 vector of optimal fibre lengths
%   lsT_list: 1x43 vector of tendon slack lengths
% Motion outputs:
%   time_list: Nx1 vector of time data points
%   LMT_list: Nx43 matrix of the time-histories of the muscle-tendon lengths LMT(t)
%   L_flexion: Nx43 matrix of muscle's moment arm with the wrist joint, for flexion (+) /extension (-)
%   L_deviation: Nx43 matrix of muscle's moment arm with the wrist joint, for abduction (inward, +) /adduction (-)

[Muscle_list, F0M_list, l0M_list, lsT_list, time_list, lMT_list, L_FlexExt, L_deviation] = load_MSK_data();
figure
scatter(1:length(Muscle_list),F0M_list);
xlabel('Muscles')
ylabel('F0M (N)')
title('Distribution of Muscle Max Iso Forces in the forearm (N)')
L_FlexExt(abs(L_FlexExt)<10^-15)=0;
L_deviation(abs(L_deviation)<10^-15)=0;

%% 1.1.PRODUCE THE NORMALIZED EMG ENVELOPES FROM THE RAW EMG DATA
% There is nothing to edit in Section 1.1.
%
fs = 1000; %sampling frequency (Hz)
EMG_envelopes = get_EMG_envelopes(fs); %Time-histories of EMG envelopes 

figure
plot(time_list, EMG_envelopes(:,1), 'blue');
hold on
plot(time_list, EMG_envelopes(:,2), 'red');
title('Normalized EMG envelopes for the flexor and extensors muscles');
xlabel('Time(s)')
legend('flexor','extensor' );

%% 1.2.COMPUTE THE MUSCLES' ACTIVE STATE FROM THE EMG ENVELOPES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit the 'activation_function.m' function to define the ODE that
% describes the muscles' activation dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
% initial state with 0 activation
a=[0.01,0.01];
%Solving the activation dynamics (first-order ODE) with the Euler method
dt_list = diff(time_list); %list of step size
for i = 2:size(EMG_envelopes,1) %looping through the time steps
    da = activation_function(EMG_envelopes(i-1,:),a(i-1,:),dt_list(i-1)) ;
    a(i,:) = a(i-1,:)+ da;
end
act = map_representative_activations_to_muscles(a, Muscle_list);

figure
plot(time_list, a(:,1), 'blue');
hold on
plot(time_list, a(:,2), 'red');
title('Active state of the flexor and extensor muscles');
xlabel('Time(s)')
ylabel('Active state')
ylim([0 1.05])
legend('flexor','extensor' );


%% 2.COMPUTE THE MUSCLE LENGTHS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit the 'get_muscle_length_function.m' function to get the 
% time-histories of the normalized fibre lengths l_norm(t)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lM_norm = get_muscle_length_function(lMT_list, lsT_list, l0M_list); %Nx43 matrix of normalized muscle lengths

figure
plot(time_list, lM_norm(:,18));
title('Normalized fibre length of the EDCL muscle');
xlabel('Time(s)')
ylabel('Normalized length')
ylim([0.5 1.5])

%% 3.COMPUTING THE FORCE-LENGTH FACTOR
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit the 'F_L_function.m' function to compute the Force-Length factor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FL_factor = F_L_function(lM_norm,act);

%% 4.COMPUTING THE MUSCLE FORCES 
FM = F0M_list.*act.*FL_factor;

figure
plot(time_list, FM(:,21));
title('EDM muscle force in N');
xlabel('Time(s)')
ylabel('Muscle Force (N)')

%% 5.COMPUTING THE JOINT TORQUES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% edit the 'get_Torque_function' function to compute a joint torque from 
% muscle forces and moment arms L 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Let's compute the torques in flexion (+)
T_muscles_FlexExt = get_Torque_function(L_FlexExt, FM);

extensor_muscles = ["ECRL" 'ECRB' 'ECU' 'EDCL' 'EDCR' 'EDCM' 'EDCI' 'EDM' 'EIP' 'EPL' 'EPB' 'APL'];
flexor_muscles = ["FCR" 'FCU' 'PL' 'FDSL' 'FDSR' 'FDSM' 'FDSI' 'FDPL' 'FDPR' 'FDPM' 'FDPI' 'FPL'];
figure
for i = 1:size(T_muscles_FlexExt,2)
    if ismember(Muscle_list(i),flexor_muscles) 
        plot(time_list, T_muscles_FlexExt(:,i), 'blue')    
    elseif ismember(Muscle_list(i),extensor_muscles) 
        plot(time_list, T_muscles_FlexExt(:,i), 'red')
    end
    hold on
end
title('Muscle-induced torques in FlexExt in N (+: flexion)')

T_flexion = sum(T_muscles_FlexExt,2); % sum the muscle contributions to torque over time

figure
plot(time_list, T_flexion);
title('Total Torque in FlexExt in Nm (+: flexion)');
xlabel('Time(s)')

% Let's compute the torques in abduction (+)
T_muscles_deviation = get_Torque_function(L_deviation, FM);
T_deviation = sum(T_muscles_deviation,2);

figure
plot(time_list, T_deviation);
title('Total Torque in deviation in Nm (+: abduction)');
xlabel('Time(s)')

%% 6. COMPUTING THE MUSCLE STIFFNESSES
K = get_muscle_stiffness_function(FM, lM_norm);

%% 7. COMPUTING THE NET STIFFNESS ABOUT THE JOINT DOF
K_T_muscles_FlexExt = get_Torque_stiffness_function(L_FlexExt, K);
T_stiffness_FlexExt = nansum(K_T_muscles_FlexExt,2);
figure
plot(time_list(1:end-1), T_stiffness_FlexExt)
title('Estimation of the net stiffness about the joint in FlexExt')

