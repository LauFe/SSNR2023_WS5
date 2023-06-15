function da = activation_function(emg,a,dt)
    if emg>a
        tau = 0.010.*(0.5+1.5*a);
    else
        tau = 0.040./(0.5+1.5*a);
    end
    da = (emg-a)./tau.*dt;
end