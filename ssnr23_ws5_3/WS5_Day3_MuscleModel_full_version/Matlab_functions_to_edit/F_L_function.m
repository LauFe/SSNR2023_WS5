function FL_factor = F_L_function(l_norm,a)
% This function takes as inputs the values at time t of
%   - the muscle active state 'a'
%   - the normalized fibre length 'l_norm'
% to compute the FL scaling factor 'FL_factor'

% Don't forget to use .*, *^, and ./ rather than *, ^, and /

    l0 = 0.15.*(1-a)+1;
    FL_factor = exp(-((l_norm-l0)./0.45).^2);
end
