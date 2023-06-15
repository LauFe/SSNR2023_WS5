function force_length = F_L_function(length,a)
    l0 = 0.15.*(1-a)+1;
    force_length = exp(-((length-l0)./0.45).^2);
end
