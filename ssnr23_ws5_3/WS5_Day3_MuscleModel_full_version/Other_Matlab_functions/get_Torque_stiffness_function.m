function K_T = get_Torque_function(L, K)
% This function takes as inputs the values at time t of
%   - the muscle stiffness 'K'
%   - the wrist-tendon moment arm 'L'
% to compute the joint stiffness 'K_T'

% Don't forget to use .* rather than *
    L = L(2:end,:);
    K_T = (L.^2).*K;
end
