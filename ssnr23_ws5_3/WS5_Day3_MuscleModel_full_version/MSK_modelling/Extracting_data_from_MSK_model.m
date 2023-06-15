% This code opens an Opensim MSK model and 
% (1) fetches the muscles' properties F0M, lsT, and l0M. 
% (2) moves the joints of the MSK model according to the .mot file
% (3) computes the muscles' lMT(t) and L(t) values

clear all
clc

import org.opensim.modeling.* 

Opensim_Wrist_model = Model('Wrist_Model.osim');

%There are 43 muscles in this model
Musclelist_not_ordered=Opensim_Wrist_model.getMuscleList();
for i = 1:43
    if i==1
       iter = Musclelist_not_ordered.begin(); 
    else
       iter.next();     
    end
    Muscle_list_not_ordered(i,1) = string(iter.getName ()) ;
    Muscle_properties_not_ordered(i,1) = iter.getMaxIsometricForce () ;
    Muscle_properties_not_ordered(i,2) = iter.getOptimalFiberLength ();
    Muscle_properties_not_ordered(i,3) = iter.getTendonSlackLength ();
end

% Re-ordering the muscles alphabetically
Muscle_list = ["1stDI_MC1",'1stDI_MC2','1stPI','2ndDI','2ndPI','3rdDI','3rdPI','4thDI','ADM','ADPo','ADPt','APB','APL','ECRB','ECRL','ECU','EDCI','EDCL','EDCM','EDCR','EDM','EIP','EPB','EPL','FCR','FCU','FDM','FDPI','FDPL','FDPM','FDPR','FDSI','FDSL','FDSM','FDSR','FPB','FPL','LUMI','LUML','LUMM','LUMR','OPP','PL'];
for i = 1:length(Muscle_list)
    muscle_name = Muscle_list(i);
    k = find(Muscle_list_not_ordered(:,1) == muscle_name);
    Muscle_properties(1,i)=Muscle_properties_not_ordered(k,1);
    Muscle_properties(2,i) = Muscle_properties_not_ordered(k,2);
    Muscle_properties(3,i) = Muscle_properties_not_ordered(k,3);
end

% Loading the experimental motion and applying it to the MSK model's joints
motion_file_mat = load('Raw_EMG.mat');
time_length = length(motion_file_mat.RecInfo.EMGraw);
fs=1000;
time = ([0:time_length-1]./fs).';
xlswrite('Wrist_motion.xlsx',time, 'wrist_motion','A2');
flexion_angles = motion_file_mat.RecInfo.Labels(:,2);
flexion_angles=flexion_angles./max(flexion_angles).*1.2;
% deviation_angles = motion_file_mat.RecInfo.Labels(:,1);
% deviation_angles=deviation_angles./max(deviation_angles).*0.17;
angle_length = length(flexion_angles);
% deviation_angles_interpolated = resample(deviation_angles,time_length,angle_length);
xlswrite('Wrist_motion.xlsx',zeros(time_length,1), 'wrist_motion','B2');
flexion_angles_interpolated = resample(flexion_angles,time_length,angle_length);
xlswrite('Wrist_motion.xlsx',flexion_angles_interpolated, 'wrist_motion','C2');
xlswrite('Wrist_motion.xlsx',zeros(time_length,24), 'wrist_motion','D2');

motion_file=importdata('Wrist_motion.xlsx');
time = motion_file.data(:,1);
motion = motion_file.data(:,2:end);
coordinates = motion_file.colheaders(1,2:end);

dev = Opensim_Wrist_model.updCoordinateSet().get('deviation');
flex = Opensim_Wrist_model.updCoordinateSet().get('flexion');
state = Opensim_Wrist_model.initSystem();

for i = 1:length(time)
    disp(i);
    for j = 1:length(coordinates)
        dof = coordinates(1,j);
        dof = dof{1,1};
        coordinate = motion(i,j);
        if ~isequal(dof, 'deviation') && ~isequal(dof, 'flexion')
            coordinate = deg2rad(coordinate);
        end
        Opensim_Wrist_model.updCoordinateSet().get(dof).setValue(state, coordinate);
    end

    for k = 1:length(Muscle_list)
        LMT_lengths(i,k)=Opensim_Wrist_model.getMuscles().get(Muscle_list(k)).getLength(state);
        L_flex(i,k) = Opensim_Wrist_model.getMuscles().get(Muscle_list(k)).computeMomentArm(state,flex);
        L_dev(i,k) = Opensim_Wrist_model.getMuscles().get(Muscle_list(k)).computeMomentArm(state,dev);
    end
end

% z=18;
% % GUI = importdata('C:\Users\caill\Desktop\Baiona\Workshop\Input_data\MLT_lengths.sto');
% GUI = importdata('C:\Users\caill\Desktop\Baiona\Workshop\Input_data\Mmt_arm_Flexion.sto');
% GUI_data = GUI.data(:,3:end);
% m = Muscle_list(z);
% m2 = GUI.colheaders(z+2);
% plot(L_flex(:,z));
% hold on
% plot(GUI_data(:,z), '--');


save('..\Input_data\Muscle_list.mat', 'Muscle_list' );
save('..\Input_data\Muscle_properties.mat',  'Muscle_properties');
save('..\Input_data\lMT.mat', 'LMT_lengths' );
save('..\Input_data\L_flex.mat',  'L_flex');
save('..\Input_data\L_dev.mat',  'L_dev');
save('..\Input_data\time.mat',  'time');





