clear; clc; close all;

%% System Parameters
L = 0.36;               % Pendulum length (m)
m = 1.0;                % Mass (kg)
g = 9.81;               % Gravity (m/s²)
J = m*L^2;              % Moment of inertia
b = 0.1;                % Friction coefficient
target_amp = 0.4;       % Target amplitude (rad ≈ 23°)
omega_n = sqrt(g/L);    % Natural frequency

%% Energy-Based Pulse Control Parameters
pulse_mag = 4.2;         % Torque magnitude (N·m)
pulse_duration = 0.015;  % Duration of each pulse (s)
rest_time = 0.5;         % Minimum time between pulses (s)

%% Simulation Setup
dt = 0.001;                      % Time step (s)
t = 0:dt:50;                     % Simulation time
theta = zeros(size(t));
dtheta = zeros(size(t));
theta(1) = 0;                   % Zero initial angle
dtheta(1) = 0.1;                % Small initial velocity
torque = zeros(size(t));

% Internal flags for pulse timing
last_pulse_time = -inf;         
pulse_active = false;           

%% Energy Regulation Loop
for i = 2:length(t)
    current_time = t(i);
    
    % Detect zero-crossing or force early pulses
    if ~pulse_active && ...
       (abs(theta(i-1)) < 0.05 || (current_time < 0.1)) && ...  % Kickstart
       (current_time - last_pulse_time) > rest_time

        pulse_active = true;
        last_pulse_time = current_time;
    end

    % Apply pulse if active
    if pulse_active
        torque(i) = sign(dtheta(i-1)) * pulse_mag;
        if (current_time - last_pulse_time) >= pulse_duration
            pulse_active = false;
        end
    end

    % Pendulum dynamics
    ddtheta = (torque(i) - b*dtheta(i-1) - m*g*L*sin(theta(i-1))) / J;
    dtheta(i) = dtheta(i-1) + dt*ddtheta;
    theta(i) = theta(i-1) + dt*dtheta(i);
end

%% Plotting (Same as before)
figure('Position', [100 100 900 900]);
subplot(4,1,1); plot(t, theta, 'r'); 
title(['Pendulum Angle (Started from θ=0)']); 
grid on;

subplot(4,1,2); plot(t, dtheta, 'g'); 
ylabel('Velocity (rad/s)'); grid on;

subplot(4,1,3); plot(t, torque, 'b'); 
ylabel('Torque (N·m)'); grid on;

subplot(4,1,4); 
E_total = 0.5*J*dtheta.^2 + m*g*L*(1-cos(theta));
plot(t, E_total, 'm'); 
xlabel('Time (s)'); ylabel('Energy (J)'); grid on;

% Phase portrait
figure;
plot(theta, dtheta, 'k', 'LineWidth', 1);
xlabel('Angle (rad)'); ylabel('Velocity (rad/s)');
title('Circular Limit Cycle');
grid on; axis equal;
