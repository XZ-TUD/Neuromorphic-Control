clear; clc; close all;

%% Pendulum parameters
rho = 1000; L = 0.36; r = 0.02;
vol = pi * r^2 * L; m = rho * vol; g = 9.81;
Jperp = (1/12)*m*(L^2 + 3*r^2) + m*(L/2)^2;
damp = 1.0;  % friction

%% Simulation time
Tf = 20; tspan = [0 Tf]; x0 = [0; 0];

%% Sweep one parameter at a time

% === Sweep 1: Torque amplitude ===
K_vals = [0.5, 1.0, 2.0];
period = 1.0; duty = 0.5;
figure('Name', 'Effect of Torque Amplitude'); 

for i = 1:length(K_vals)
    K = K_vals(i);
    torque_fn = @(t) K * (mod(t,period)/period < duty);
    [t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0);
    angle = X(:,1); torque = arrayfun(torque_fn, t);
    
    subplot(3,2,2*i-1); plot(t, torque, 'b'); ylabel('Torque'); title(['K = ' num2str(K)]); grid on;
    subplot(3,2,2*i); plot(t, angle, 'r'); ylabel('Angle'); grid on;
end
sgtitle('Sweep of Torque Amplitude');

% === Sweep 2: Period ===
K = 1.0; duty = 0.5;
period_vals = [0.5, 1.0, 2.0];
figure('Name', 'Effect of Pulse Period');

for i = 1:length(period_vals)
    period = period_vals(i);
    torque_fn = @(t) K * (mod(t,period)/period < duty);
    [t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0);
    angle = X(:,1); torque = arrayfun(torque_fn, t);
    
    subplot(3,2,2*i-1); plot(t, torque, 'b'); ylabel('Torque'); title(['Period = ' num2str(period)]); grid on;
    subplot(3,2,2*i); plot(t, angle, 'r'); ylabel('Angle'); grid on;
end
sgtitle('Sweep of Pulse Period');

% === Sweep 3: Duty Cycle ===
K = 1.0; period = 1.0;
duty_vals = [0.2, 0.5, 0.8];
figure('Name', 'Effect of Duty Cycle');

for i = 1:length(duty_vals)
    duty = duty_vals(i);
    torque_fn = @(t) K * (mod(t,period)/period < duty);
    [t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0);
    angle = X(:,1); torque = arrayfun(torque_fn, t);
    
    subplot(3,2,2*i-1); plot(t, torque, 'b'); ylabel('Torque'); title(['Duty = ' num2str(duty)]); grid on;
    subplot(3,2,2*i); plot(t, angle, 'r'); ylabel('Angle'); grid on;
end
sgtitle('Sweep of Duty Cycle');

%% ODE Function
function dx = pendulum_ode(t,x,torque_fn,J,damp,m,L,g)
    theta = x(1); dtheta = x(2);
    tau = torque_fn(t);
    dx = [dtheta; (tau - damp*(L/2)*dtheta - m*g*(L/2)*sin(theta)) / J];
end
