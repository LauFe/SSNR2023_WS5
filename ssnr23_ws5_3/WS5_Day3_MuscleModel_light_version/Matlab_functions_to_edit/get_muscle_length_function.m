function l_norm = get_muscle_length_function(lMT,lsT, l0M)
% This function takes as inputs the values at time t of
%   - the muscle-tendon length 'lMT'
% as well as the muscule-specific values of
%   - tendon slack length 'lsT'
%   - optimal fibre length 'l0M'
% to compute the normalized fibre length 'l_norm'

% Don't forget to use ./ rather than /

    l_norm = (lMT - lsT)./l0M;
end