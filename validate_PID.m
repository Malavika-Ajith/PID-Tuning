run('init_parameters.m');

% Setting baseline PID gains
Kp_base = 2;
Ki_base = 1;
Kd_base = 0.5;

load_system('Simulink_PID');

% Assign baseline PID gains in Simulink
set_param('Simulink_PID/PID', 'P', num2str(Kp_base));
set_param('Simulink_PID/PID', 'I', num2str(Ki_base));
set_param('Simulink_PID/PID', 'D', num2str(Kd_base));
simOut_base = sim('Simulink_PID', 'ReturnWorkspaceOutputs', 'on');
y_base = simOut_base.get('y');

load('optimized_PID_results.mat');

% Assign Optimized PID gains in simulink
set_param('Simulink_PID/PID', 'P', num2str(Kp_opt));
set_param('Simulink_PID/PID', 'I', num2str(Ki_opt));
set_param('Simulink_PID/PID', 'D', num2str(Kd_opt));
simOut_opt = sim('Simulink_PID', 'ReturnWorkspaceOutputs', 'on');
y_opt = simOut_opt.get('y');

% Plot the baseline vs optimized PID gains
figure;
plot(y_base.Time, y_base.Data, 'r--', 'LineWidth', 1.5); hold on;
plot(y_opt.Time, y_opt.Data, 'b-', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('System Output');
legend('Baseline PID', 'Optimized PID');
title('System Response: Baseline vs Optimized PID');
grid on;