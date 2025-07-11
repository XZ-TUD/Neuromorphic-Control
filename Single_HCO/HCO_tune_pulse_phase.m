clear; clc;

%% Sinusoidal theta parameters
A = 1;
f_theta = 0.5;
omega = 2*pi*f_theta;
Tf = 10; dt = 0.001;
t_theta = 0:dt:Tf;
theta = A*sin(omega*t_theta);
dot_theta = A*omega*cos(omega*t_theta);

theta_interp = @(tq) interp1(t_theta, theta, tq, 'linear', 'extrap');
dot_theta_interp = @(tq) interp1(t_theta, dot_theta, tq, 'linear', 'extrap');

%% Input pulse parameters
pulse_width = 0.1;   % narrower pulse (~10ms window)
input_strength = 5;   % just enough to cross threshold briefly

input_fn1 = @(t) ( abs(theta_interp(t)) < pulse_width & dot_theta_interp(t) > 0 ) * input_strength;
input_fn2 = @(t) ( abs(theta_interp(t)) < pulse_width & dot_theta_interp(t) < 0 ) * input_strength;

%% Neuromorphic parameters
rho = 1000; L = 0.36; r = 0.02;
vol = pi*r^2*L; m = rho*vol; g = 9.81;
Jperp = (1/12)*m*(L^2 + 3*r^2) + m*(L/2)^2;

damp = 1.0;
omega_n = sqrt((m*g*(L/2))/Jperp);
K = 1; K_ND = K/(m*g*L/2);
alpha = (damp*L/2)/sqrt(Jperp*m*g*L/2);
t_factor = sqrt(m*g*(L/2)/Jperp);

a4 = 2.0;   % slightly lower than before
a2 = 1.5;
a1 = 2;
tau_m = 0.001;

% Sharpen synapse and ultra-slow dynamics for quick pulse
tau_s = 0.2;   % faster synaptic response
tau_us = 2.0;    % faster ultra-slow adaptation

synapse = @(vs,gain) gain./(1 + exp(-2*(vs+1)));
a3_time = @(t) (t>3)*0.7*1.5 + (t<=3)*0.7*1.5;

%% ODE system
neuron_odes = @(t,x) [
    (-x(1) + a1*tanh(x(1)) - a2*tanh(x(2)) + ...
    a3_time(t)*tanh(x(2)+0.9) - a4*tanh(x(3)+0.9) + ...
    synapse(x(5), -0.2) + input_fn1(t))/tau_m;

    (x(1) - x(2))/tau_s;

    (x(1) - x(3))/tau_us;

    (-x(4) + a1*tanh(x(4)) - a2*tanh(x(5)) + ...
    a3_time(t)*tanh(x(5)+0.9) - a4*tanh(x(6)+0.9) + ...
    synapse(x(2), -0.2) + input_fn2(t))/tau_m;

    (x(4) - x(5))/tau_s;

    (x(4) - x(6))/tau_us;
];

x0 = [0 0 -1 0 0 -0.5];
tspan = [0 Tf];
opts = odeset('RelTol',1e-5,'AbsTol',1e-7);

[t,x] = ode15s(neuron_odes, tspan, x0, opts);

v1 = x(:,1);
v2 = x(:,4);

threshold = 4;
torque_pos = double(v1 > threshold);
torque_neg = double(v2 > threshold);

%% Plot results
%% Plot results with your requested layout
figure;

% Subplot 1: theta(t) and torque output over time
subplot(3,1,1);
yyaxis left
plot(t_theta, theta, 'b', 'LineWidth', 1.5);
ylabel('\theta (rad)');
yyaxis right
plot(t, torque_pos - torque_neg, 'k', 'LineWidth', 2);
ylabel('Torque');
xlabel('Time (s)');
title('Sinusoidal Angle \theta(t) and Torque Output');
grid on;
legend('\theta', 'Torque');

% Subplot 2: v1 and v2 with threshold
subplot(3,1,2);
plot(t, v1, 'r', 'LineWidth', 1.5); hold on;
plot(t, v2, 'b', 'LineWidth', 1.5);
yline(threshold, 'k--', 'Threshold');
xlabel('Time (s)');
ylabel('Membrane Voltage');
title('Neuron Membrane Potentials v_1 and v_2');
legend('v_1', 'v_2', 'Threshold');
grid on;

% Subplot 3: Torque output alone
subplot(3,1,3);
plot(t, torque_pos - torque_neg, 'k', 'LineWidth', 2);
xlabel('Time (s)');
ylabel('Torque');
title('Torque Output (positive for v_1, negative for v_2)');
grid on;
