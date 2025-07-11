% Pendulum Stabilization from Large Angles to Equilibrium (0°)
clear; clc; 
%close all;

%% Pendulum Parameters
L = 0.36;       % Length (m)
m = 1.0;        % Mass (kg)
g = 9.81;       % Gravity (m/s²)
Jperp = m*L^2;  % Moment of inertia (simplified)
damp = 0;     % Natural damping

%% Simulation Parameters
Tf = 20;                       % Extended simulation time
tspan = [0 Tf];
x0 = [-0.4; 0];              % Initial: -1500° (≈ -26.18 rad), zero velocity

%% Anti-Phase PD Controller (Proportional-Derivative)
Kp = 15.0;                     % Position gain (stiffness)
Kd = 8.0;                      % Velocity gain (damping)

torque_fn = @(t,x) -Kp * wrapToPi(x(1)) - Kd * x(2);  % PD control law

%% Solve ODE
options = odeset('RelTol',1e-6);
[t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0, options);

%% Post-Processing
angle_rad = X(:,1);
angle_deg = rad2deg(angle_rad);
d_angle = X(:,2);

% Calculate torque
torque = -Kp * wrapToPi(angle_rad) - Kd * d_angle;

%% Plot Results
figure('Position', [100 100 900 700]);

% Angle (degrees)
subplot(3,1,1);
plot(t, angle_deg, 'r', 'LineWidth', 1.5);
ylabel('Angle (°)');
% title('Pendulum Stabilization (-1500° → 0°)');
grid on; ylim([-50 10]); yline(0, 'k--');

% Angular Velocity
subplot(3,1,2);
plot(t, d_angle, 'g', 'LineWidth', 1.5);
ylabel('Velocity (rad/s)');
grid on; yline(0, 'k--');

% Torque
subplot(3,1,3);
plot(t, torque, 'b', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Torque (N·m)');
grid on;

%% Energy Analysis
PE = m*g*L*(1 - cos(angle_rad));
KE = 0.5*Jperp*d_angle.^2;
figure;
plot(t, PE+KE, 'k', 'LineWidth', 1.5);
xlabel('Time (s)'); ylabel('Energy (J)');
title('Energy Dissipation');
grid on;

%% Pendulum ODE (Corrected Dynamics)
function dx = pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g)
    theta = wrapToPi(x(1));     % Wrap angle to [-π, π]
    dtheta = x(2);
    
    % Control torque (PD)
    tau = torque_fn(t, [theta; dtheta]);
    
    % Dynamics (corrected sign convention)
    dx = zeros(2,1);
    dx(1) = dtheta;
    dx(2) = (tau - damp*L^2*dtheta - m*g*L*sin(theta)) / Jperp;
end
