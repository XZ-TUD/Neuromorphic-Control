% Neuromorphic Pendulum Stabilization without Friction using Phase-Based Anti-Pulses
clear; clc; close all;

%% System Parameters
L = 0.36;       % Pendulum length (m)
m = 1.0;        % Mass (kg)
g = 9.81;       % Gravity (m/s²)
J = m * L^2;    % Moment of inertia
b = 0;          % No friction

%% Control Parameters
pulse_magnitude = 10.0;      % Torque magnitude (N·m)
pulse_duration = 0.015;      % Active pulse width (s)
deadzone_theta = 0.01;       % Stop if angle below this (rad)
deadzone_dtheta = 0.01;      % Stop if velocity below this (rad/s)
dt = 0.001;                  % Time step
t = 0:dt:20;                 % Simulation time

%% Initial Conditions
theta = -0.4 * ones(size(t));  % Start away from 0
dtheta = zeros(size(t));
torque_log = zeros(size(t));

%% Internal Flags
pulse_timer = 0;
pulse_active = false;

%% Phase-Based Neuromorphic Control Loop
for i = 2:length(t)
    % Detect zero-crossing of angle with matching velocity direction
    if ~pulse_active && ...
       abs(theta(i-1)) < 0.01 && abs(dtheta(i-1)) > 0.01
        pulse_active = true;
        pulse_timer = 0;
    end

    % Apply anti-phase pulse (oppose motion)
    if pulse_active
        torque = -sign(dtheta(i-1)) * pulse_magnitude;
        pulse_timer = pulse_timer + dt;
        if pulse_timer >= pulse_duration
            pulse_active = false;
        end
    else
        torque = 0;
    end

    torque_log(i) = torque;

    % Pendulum Dynamics (no friction)
    ddtheta = (torque - m * g * L * sin(theta(i-1))) / J;
    dtheta(i) = dtheta(i-1) + dt * ddtheta;
    theta(i) = theta(i-1) + dt * dtheta(i);

    % Stop condition: near zero energy
    if abs(theta(i)) < deadzone_theta && abs(dtheta(i)) < deadzone_dtheta
        theta(i+1:end) = theta(i);
        dtheta(i+1:end) = 0;
        torque_log(i+1:end) = 0;
        break;
    end
end

%% Visualization
figure('Position', [100 100 900 700]);

subplot(3,1,1);
plot(t, rad2deg(theta), 'r', 'LineWidth', 1.5);
ylabel('Angle (°)'); title('Stabilization at θ = 0');
grid on; yline(0, '--k');

subplot(3,1,2);
plot(t, dtheta, 'g', 'LineWidth', 1.5);
ylabel('Velocity (rad/s)');
grid on; yline(0, '--k');

subplot(3,1,3);
stairs(t, torque_log, 'b', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Torque (N·m)');
title('Anti-phase Energy-Removal Pulses');
grid on; ylim([-1.1*pulse_magnitude, 1.1*pulse_magnitude]);

%% Energy Plot
KE = 0.5 * J * dtheta.^2;
PE = m * g * L * (1 - cos(theta));
figure;
plot(t, KE + PE, 'k', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Energy (J)');
title('Energy Dissipation Toward Zero Without Friction');
grid on;
