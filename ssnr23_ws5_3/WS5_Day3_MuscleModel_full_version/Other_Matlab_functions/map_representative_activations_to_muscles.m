function act = map_representative_activations_to_muscles(a, muscle_list)
    % And mapping those two representative active states to the 43 muscles,
    % whether they are 'top' or 'bottom' muscles
    extensor_muscles = ["ECRL" 'ECRB' 'ECU' 'EDCL' 'EDCR' 'EDCM' 'EDCI' 'EDM' 'EIP' 'EPL' 'EPB' 'APL'];
    flexor_muscles = ["FCR" 'FCU' 'PL' 'FDSL' 'FDSR' 'FDSM' 'FDSI' 'FDPL' 'FDPR' 'FDPM' 'FDPI' 'FPL'];
    digit_muscles = ["APB" 'FPB' 'OPP' 'ADPt' 'ADPo' 'ADM' 'FDM' '1stPI' '2ndPI' '3rdPI' '1stDI_MC1' '1stDI_MC2' '2ndDI' '3rdDI' '4thDI' 'LUML' 'LUMR' 'LUMM' 'LUMI'];
    for i = 1:length(muscle_list)
        muscle_name = muscle_list(i);
        if ismember(muscle_name,flexor_muscles) 
            act(:,i) = a(:,1);
        elseif ismember(muscle_name,extensor_muscles)
            act(:,i) = a(:,2);
        else
            act(:,i) = zeros(length(a(:,1)),1);
        end
end