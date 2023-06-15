function l = get_muscle_length_function(lMT,lsT, l0M)
    % Very simply, when the tendon is assumed rigid, it is assumed that it
    % remains at constant length equalling lsT. 
    % Therefore, the muscle-tendon length lMT(t) is the sum of the constant
    % tendon length lsT and of the varying muscle length lM(t)
    l = (lMT - lsT)./l0M;
end