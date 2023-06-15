function K = get_muscle_stiffness_function(FM, lM_norm)
    dFM = diff(FM);
    dlM_norm = diff(lM_norm);
    dlM_norm(abs(dlM_norm)<6*10^-6)=NaN;
    K = dFM./dlM_norm;
end