function EMG_envelopes = get_EMG_envelopes(fs)

    % The EMG signals were recorded with C EMG cells
    % fs = 2048; %sampling frequency in Hz
    EMG_MVC_flexion = load('.\Input_data\FlexionMVC.mat'); %.xC matrix of the EMGs recorded at MVC in flexion
    EMG_MVC_flexion = EMG_MVC_flexion.RecInfo.EMGraw;
    EMG_MVC_extension = load('.\Input_data\ExtensionMVC.mat'); %.xC matrix of the EMGs recorded at MVC in extension
    EMG_MVC_extension = EMG_MVC_extension.RecInfo.EMGraw;
    EMG_raw = importdata('.\Input_data\Raw_EMG.mat');%NxC matrix of the EMGs recorded during the contraction
    EMG_raw = EMG_raw.EMGraw;

  

    %fill the 'get_EMG_envelope' function to compute the EMG envelopes
    EMG_MVC_flexion_envelope = get_EMG_envelope(EMG_MVC_flexion, fs);
    EMG_MVC_extension_envelope = get_EMG_envelope(EMG_MVC_extension, fs);
    all_EMG_envelopes = get_EMG_envelope(EMG_raw, fs); %Representative EMGs of the 'top' extensor muscles

    %Compute representative EMG envelopes for the 'top' and 'bottom' muscles by averaging the recorded EMG envelopes 
    EMG_MVC_flexion_envelope = mean(EMG_MVC_flexion_envelope(:,[3 4 5 6]),2);
    EMG_MVC_extension_envelope = mean(EMG_MVC_extension_envelope(:,[1 2 8 9 10 11 12]),2);
    EMG_envelopes(:,1) = mean(all_EMG_envelopes(:,[3 4 5 6]),2); % flexor muscles
    EMG_envelopes(:,2) = mean(all_EMG_envelopes(:,[1 2 8 9 10 11 12]),2); % extensor muscles

    %extensors: 1 2 8-12
    %7 out
    % 3-6 flexors
    
    %Normalize the EMG envelopes by the recorded MVC
    EMG_envelopes(:,1) = EMG_envelopes(:,1)./max(EMG_MVC_flexion_envelope);
    EMG_envelopes(:,2) = EMG_envelopes(:,2)./max(EMG_MVC_extension_envelope);


end