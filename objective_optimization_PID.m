function cost = objective_optimization_PID(PID_gains)
    load_system('Simulink_PID');

    % Setting the PID gains in the workspace
    Kp = PID_gains(1);
    Ki = PID_gains(2);
    Kd = PID_gains(3);

    % Setting the Simulink model's PID controller to these values
    set_param('Simulink_PID/PID', 'P', num2str(Kp));
    set_param('Simulink_PID/PID', 'I', num2str(Ki));
    set_param('Simulink_PID/PID', 'D', num2str(Kd));

    % Run the Simulink simulation
    simOut = sim('Simulink_PID', 'ReturnWorkspaceOutputs', 'on');


    % Extracting results from simulink
    y = simOut.get('y');  % Replace 'y' with the name of your output variable
    
    % Desired Set-point
    setpoint = 1;  % Example setpoint, modify based on your application

    % Error calculation
    error = setpoint - y.Data;

    %  Errors

    % Integral of Squared Error (IAE)
    IAE = trapz(y.Time, error);  

    % Settling Time (Ts)
    tolerance = 0.02; %assumed tolerance
    final_value = y.Data(end); % formulas from literature
    lower_band = final_value * (1 - tolerance);
    upper_band = final_value * (1 + tolerance);
    settling_index = find(y.Data >= lower_band & y.Data <= upper_band, 1, 'first');
    settling_time = y.Time(settling_index);

    % Overshoot 
    maximum_value = max(y.Data);
    overshoot = (maximum_value - final_value) / final_value * 100;

    % Steady-State Error (ess)
    steady_state_error = setpoint - final_value;

    % Weights for each metric
    weight_IAE = 2;        % Weight for Integral of Squared Error
    weight_settling_time = 5;       % Weight for Settling Time
    weight_overshoot = 1; % Weight for Overshoot
    weight_steady_state_error = 3;        % Weight for Steady-State Error

    % Calculating the cost
    cost = (weight_IAE * IAE) + (weight_settling_time * settling_time) + (weight_overshoot * overshoot) + (weight_steady_state_error * steady_state_error);
    
    close_system('Simulink_PID', 0);
end