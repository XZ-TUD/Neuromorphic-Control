clear; clc; close all;

%% System Parameters
L = 0.36;               % Pendulum length (m)
m = 1.0;                % Mass (kg)
g = 9.81;               % Gravity (m/s²)
J = m*L^2;              % Moment of inertia
b = 0.1;                % Friction coefficient
target_amp = 0.4;       % Desired amplitude (rad)
omega_n = sqrt(g/L);    % Natural frequency

%% PD Controller Gains (tune as needed)
Kp = 20;
Kd = 5;

%% Desired Trajectory
omega_traj = omega_n;  % Tracking frequency (rad/s)

%% Simulation Setup
dt = 0.001;                    
t = 0:dt:50;                    
theta = zeros(size(t));
dtheta = zeros(size(t));
torque = zeros(size(t));

theta(1) = 0;           % Initial angle
dtheta(1) = 0;          % Initial angular velocity

%% Simulation Loop
for i = 2:length(t)
    % Desired trajectory
    theta_d = target_amp * sin(omega_traj * t(i));
    dtheta_d = target_amp * omega_traj * cos(omega_traj * t(i));
    
    % PD control torque
    error = theta_d - theta(i-1);
    derror = dtheta_d - dtheta(i-1);
    torque(i) = Kp * error + Kd * derror;
    
    % Dynamics
    ddtheta = (torque(i) - b*dtheta(i-1) - m*g*L*sin(theta(i-1))) / J;
    dtheta(i) = dtheta(i-1) + dt * ddtheta;
    theta(i) = theta(i-1) + dt * dtheta(i);
end

%% Plotting
figure('Position', [100 100 900 900]);

subplot(4,1,1); 
plot(t, theta, 'r', t, target_amp*sin(omega_traj*t), '--k');
title('Pendulum Angle vs Desired Trajectory'); 
legend('Actual θ', 'Desired θ'); grid on;

subplot(4,1,2); 
plot(t, dtheta, 'g'); 
ylabel('Velocity (rad/s)'); grid on;

subplot(4,1,3); 
plot(t, torque, 'b'); 
ylabel('Torque (N·m)'); grid on;

subplot(4,1,4); 
E_total = 0.5*J*dtheta.^2 + m*g*L*(1 - cos(theta));
plot(t, E_total, 'm'); 
xlabel('Time (s)'); ylabel('Energy (J)'); grid on;

% Phase portrait
% figure;
% plot(theta, dtheta, 'k', 'LineWidth', 1);
% xlabel('Angle (rad)'); ylabel('Velocity (rad/s)');
% title('Phase Portrait'); grid on; axis equal;
