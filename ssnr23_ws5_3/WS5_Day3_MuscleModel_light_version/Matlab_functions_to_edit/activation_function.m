function da = activation_function(emg,a,dt)
% This function takes as inputs the values at time t of
%   - the EMG envelope 'emg'
%   - the muscle active state 'a'
%   - the time step dt
% to compute the increment in activation 'da'

% Don't forget to use .* and ./ rather than * and /

    if emg>a
        tau = ................. ;
    else
        tau = 0.040./(0.5+1.5*a);
    end
    
    da = ................;
end