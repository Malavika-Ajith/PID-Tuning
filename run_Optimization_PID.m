% run_Optimization_PID.m


% Taking parameters for spring mass system
run('init_parameters.m');

% Set the bounds for the PID parameters 
lb = [0.1, 0.01, 0.01];   % Lower bounds: [Kp, Ki, Kd]
ub = [100, 10, 20];       % Upper bounds: [Kp, Ki, Kd]

% Setting the Genetic Algorithm
options = optimoptions("ga", MaxGenerations=100, ConstraintTolerance=1e-6,MaxStallGenerations=20,Display="iter");

% Running the Genetic Algorithm

[optimal_PID_gains, fval] = ga(@objective_optimization_PID, 3, [], [], [], [], lb, ub, [], options);

% Extracting the optimized PID gains
Kp_opt = optimal_PID_gains(1);
Ki_opt = optimal_PID_gains(2);
Kd_opt = optimal_PID_gains(3);

% Displaying the optimized PID gains
disp(['Optimized Kp: ', num2str(Kp_opt)]);
disp(['Optimized Ki: ', num2str(Ki_opt)]);
disp(['Optimized Kd: ', num2str(Kd_opt)]);

load_system('Simulink_PID');

% Assign these optimized PID gains to the Simulink PID controller
set_param('Simulink_PID/PID', 'P', num2str(Kp_opt));
set_param('Simulink_PID/PID', 'I', num2str(Ki_opt));
set_param('Simulink_PID/PID', 'D', num2str(Kd_opt));

% Re-run the Simulink model with the optimized PID parameters
simOut = sim('Simulink_PID', 'ReturnWorkspaceOutputs', 'on');

% Saving the optimized gains
save('optimized_PID_gains.mat', 'Kp_opt', 'Ki_opt', 'Kd_opt');