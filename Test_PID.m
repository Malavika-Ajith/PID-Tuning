
load_system('Simulink_PID');

% Set the stop time
set_param('Simulink_PID', 'StopTime', '10'); 

% Setting the optimized PID Gains

load('optimized_PID_results.mat');

% Set the optimized PID gains in Simulink
set_param('Simulink_PID/PID', 'P', num2str(Kp_opt));
set_param('Simulink_PID/PID', 'I', num2str(Ki_opt));
set_param('Simulink_PID/PID', 'D', num2str(Kd_opt));

% Conditions for testing where setpoints and disturbances are changed 
setpoints = [1, 2, 3];  % Setpoints to test
disturbances = [0, 1];  % 0 = No disturbance, 1 = Apply disturbance
disturbance_time = 5;    % Apply disturbance at 5 sec

% Arrays to store results
simResults = cell(length(setpoints), length(disturbances));

% Varying the conditions in loop
for i = 1:length(setpoints)  
    for j = 1:length(disturbances) 

        step_value = setpoints(i);
        enable_disturbance = disturbances(j); 
        
        set_param('Simulink_PID/Step', 'Time', '1', 'Before', '0', 'After', num2str(step_value));
        
        if enable_disturbance
            set_param('Simulink_PID/Disturbance', 'Time', num2str(disturbance_time), 'Value', '1');
        else
            set_param('Simulink_PID/Disturbance', 'Time', '0', 'Value', '0');  % No disturbance
        end
        
        % Results 
        disp(['Running Test for Setpoint = ', num2str(step_value), ' and Disturbance = ', num2str(enable_disturbance)]);
        simOut = sim('Simulink_PID', 'ReturnWorkspaceOutputs', 'on');
        
        % Storing the results
        simResults{i, j} = simOut.get('y');  % Store results for each combination
        
    end
end

% Plot the results
figure;
hold on;

% Loop through the results and plotting
colors = ['b', 'g', 'r', 'c', 'm', 'y']; 
lineStyle = {'-', '--', ':', '-.', '--', ':'};

for i = 1:length(setpoints)
    for j = 1:length(disturbances)
        y = simResults{i, j};
        
        plot(y.Time, y.Data, 'LineWidth', 2, ...
            'DisplayName', ['Setpoint = ' num2str(setpoints(i)) ', Disturbance = ' num2str(disturbances(j))]);
    end
end