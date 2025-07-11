clear; clc; close all;

%% Pendulum parameters
rho = 1000; L = 0.36; r = 0.02;
vol = pi * r^2 * L; m = rho * vol; g = 9.81;
Jperp = (1/12)*m*(L^2 + 3*r^2) + m*(L/2)^2;
damp = 1.0;

%% Simulation parameters
Tf = 20; tspan = [0 Tf]; x0 = [0; 0];

%% Sweep 1: Torque amplitude K
K_vals = [0.5, 1.0, 2.0];
period = 1.0; duty_cycle = 0.2;

figure('Name','Sweep of Torque Amplitude (Anti-Phase)');
for i = 1:length(K_vals)
    K = K_vals(i);
    torque_fn = @(t) K * (mod(t,period)/period < duty_cycle) .* ...
                      (1 - 2 * mod(floor(t/period), 2));
    [t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0);
    angle = X(:,1); torque = arrayfun(torque_fn, t);

    subplot(3,2,2*i-1);
    plot(t, torque, 'b'); ylabel('Torque'); title(['K = ' num2str(K)]); grid on;
    ylim([-1.2*max(K_vals) 1.2*max(K_vals)]);

    subplot(3,2,2*i);
    plot(t, angle, 'r'); ylabel('Angle'); grid on;
end
sgtitle('Anti-Phase Control: Sweep of Torque Amplitude');

%% Sweep 2: Period
K = 1.0; duty_cycle = 0.2;
period_vals = [0.5, 1.0, 2.0];

figure('Name','Sweep of Pulse Period (Anti-Phase)');
for i = 1:length(period_vals)
    period = period_vals(i);
    torque_fn = @(t) K * (mod(t,period)/period < duty_cycle) .* ...
                      (1 - 2 * mod(floor(t/period), 2));
    [t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0);
    angle = X(:,1); torque = arrayfun(torque_fn, t);

    subplot(3,2,2*i-1);
    plot(t, torque, 'b'); ylabel('Torque'); title(['Period = ' num2str(period)]); grid on;
    ylim([-1.2*K 1.2*K]);

    subplot(3,2,2*i);
    plot(t, angle, 'r'); ylabel('Angle'); grid on;
end
sgtitle('Anti-Phase Control: Sweep of Pulse Period');

%% Sweep 3: Duty Cycle
K = 1.0; period = 1.0;
duty_vals = [0.1, 0.5, 0.8];

figure('Name','Sweep of Duty Cycle (Anti-Phase)');
for i = 1:length(duty_vals)
    duty_cycle = duty_vals(i);
    torque_fn = @(t) K * (mod(t,period)/period < duty_cycle) .* ...
                      (1 - 2 * mod(floor(t/period), 2));
    [t, X] = ode15s(@(t,x) pendulum_ode(t,x,torque_fn,Jperp,damp,m,L,g), tspan, x0);
    angle = X(:,1); torque = arrayfun(torque_fn, t);

    subplot(3,2,2*i-1);
    plot(t, torque, 'b'); ylabel('Torque'); title(['Duty = ' num2str(duty_cycle)]); grid on;
    ylim([-1.2*K 1.2*K]);

    subplot(3,2,2*i);
    plot(t, angle, 'r'); ylabel('Angle'); grid on;
end
sgtitle('Anti-Phase Control: Sweep of Duty Cycle');

%% --- Pendulum ODE ---
function dx = pendulum_ode(t,x,torque_fn,J,damp,m,L,g)
    theta = x(1); dtheta = x(2);
    tau = torque_fn(t);
    dx = [dtheta; (tau - damp*(L/2)*dtheta - m*g*(L/2)*sin(theta)) / J];
end
