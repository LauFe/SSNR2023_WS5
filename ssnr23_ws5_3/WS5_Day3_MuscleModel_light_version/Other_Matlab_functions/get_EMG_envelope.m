function env = get_EMG_envelope(bemg, fs)


    % 1) filter highpass cutoff 30 Hz

    freqCutOff = 10;
    filterOrder = 4;
    bEMGs_HF = filterEMGsv2(fs, bemg, freqCutOff, filterOrder, 'high');
    freqCutOff = 450;
    filterOrder = 4;
    bEMGs_HF = filterEMGsv2(fs, bEMGs_HF, freqCutOff, filterOrder, 'low');
    
    % 2) demean raw signal and rectified
    rect_data = abs(bEMGs_HF  -  ones(1,size(bEMGs_HF,1)).'*mean(bEMGs_HF)  );

    % 3) filter lowpass
    freqCutOff = 6;
    filterOrder = 4;
    env = filterEMGsv2(fs, rect_data, freqCutOff, filterOrder, 'low');
end