%__________________________________________________________________________
% Author: Luca Modenese, January 2015
% email: l.modenese@griffith.edu.au
%__________________________________________________________________________
%
% v2 does not require acq
% v1 of the function is commented at the bottom
function EMGs_filtered = filterEMGsv2(EMG_sample_freq, EMGs, freqCutOff, filterOrder, filtertype)

%%%%%%%%% filter parameters %%%%%%%%
% sample_freq = btkGetAnalogFrequency(acq);

% parameters
[b,a] = butter(filterOrder/2,  freqCutOff/(EMG_sample_freq/2),  filtertype );
%%%%%%%%%%%%%%%%%%%%%%%%%%

EMGs_filtered = filtfilt(b,a, EMGs);

%---------------------- KEPT FOR COMPARISON -------------------------------
% function EMGs_filtered = filterEMGs(acq, EMGs, freqCutOff, filterOrder, filtertype)
% %%%%%%%%% filter parameters %%%%%%%%
% sample_freq = btkGetAnalogFrequency(acq);
% % parameters
% [b,a] = butter(filterOrder/2,  freqCutOff/(sample_freq/2),  filtertype );
% %%%%%%%%%%%%%%%%%%%%%%%%%%
% EMGs_filtered = filtfilt(b,a, EMGs);
% end
%--------------------------------------------------------------------------
end