% single_HCO.m
% MATLAB implementation of a 2-neuron Half-Center Oscillator (HCO) model
% Simulates neural dynamics and torque generation using a system of ODEs
% Fig.2 in [Schmetterling, Raphael, et al. "Neuromorphic control of a
% pendulum." IEEE Control Systems Letters (2024).]

clear; clc;  
%close all;% Clear workspace and command window

%% Parameters
rho = 1000;          % Density of the pendulum material (kg/m^3)
L = 0.36;            % Length of the pendulum (m)
r = 0.02;            % Radius of the pendulum (m)
vol = pi * r^2 * L;  % Volume of the pendulum (cylinder approximation)
m = rho * vol;       % Mass of the pendulum
g = 9.81;            % Gravitational acceleration (m/s^2)

% Moment of inertia around a perpendicular axis through pivot
Jperp = (1/12)*m*(L^2 + 3*r^2) + m*(L/2)^2;

damp = 1.0;  % Damping factor (non-dimensional)
omega_n = sqrt((m * g * (L / 2)) / Jperp);  % Natural angular frequency (rad/s)
f_n = omega_n / (2 * pi);  % Natural frequency (Hz)

K = 1;  % Torque constant (arbitrary gain)
K_ND = K / (m * g * L / 2);  % Non-dimensionalized torque gain

% Non-dimensional damping coefficient
alpha = (damp * L / 2) / sqrt(Jperp * m * g * L / 2);

% Time scaling factor for normalization
t_factor = sqrt(m * g * (L / 2) / Jperp);

Tf = 6;  % Final time for simulation (s)

% Display key computed parameters
fprintf('K_ND = %.4f\n', K_ND);
fprintf('alpha = %.4f\n', alpha);
fprintf('t_factor = %.4f\n', t_factor);

%% Input functions
% External input to neuron 1: stronger negative input between 0.3s and 0.6s
input_fn1 = @(t) (t > 0.3 && t < 0.6) * -1.2 + ~(t > 0.3 && t < 0.6) * -1;

% Constant external input to neuron 2
input_fn2 = @(t) -1;

%% Rate selection (defines synaptic strength parameter a4)
rate_idx = 3;  % Index for choosing value of a4 from a predefined list
a4s = [1.57, 1.75, 2.49, 3.56];  % List of candidate a4 values
a2 = 0.8 * 2;  % Inhibitory strength from opposite neuron
a4 = a4s(rate_idx);  % Final chosen value for a4

a1 = 2;       % Self-excitation strength
tau_m = 0.001;  % Membrane time constant
tau_s = 0.05;   % Synaptic time constant
tau_us = 2.5;   % Ultra-slow synaptic dynamics (e.g., adaptation)

%% ODE System definition
% Define the system of ODEs representing two interacting neurons
neuron_odes = @(t, x) [
    % Neuron 1 dynamics
    (-x(1) + a1*tanh(x(1)) - a2*tanh(x(2)) + ...
     a3_time(t)*tanh(x(2)+0.9) - a4*tanh(x(3)+0.9) + ...
     synapse(x(5), -0.2) + input_fn1(t)) / tau_m;

    % Neuron 1 synaptic state dynamics
    (x(1) - x(2)) / tau_s;

    % Neuron 1 ultra-slow dynamics
    (x(1) - x(3)) / tau_us;

    % Neuron 2 dynamics
    (-x(4) + a1*tanh(x(4)) - a2*tanh(x(5)) + ...
     a3_time(t)*tanh(x(5)+0.9) - a4*tanh(x(6)+0.9) + ...
     synapse(x(2), -0.2) + input_fn2(t)) / tau_m;

    % Neuron 2 synaptic state dynamics
    (x(4) - x(5)) / tau_s;

    % Neuron 2 ultra-slow dynamics
    (x(4) - x(6)) / tau_us;
];

%% Initial conditions and simulation
x0 = [0, 0, -1, 0, 0, -0.5];  % Initial states: [v1, vs1, vus1, v2, vs2, vus2]
tspan = [0 Tf];              % Time span for simulation

% Solve the ODEs using MATLAB's stiff solver
[t, x] = ode15s(neuron_odes, tspan, x0);

% Extract neuron voltages
v1 = x(:,1);  % Membrane potential of neuron 1
v2 = x(:,4);  % Membrane potential of neuron 2

% Compute torque output based on v1 threshold
torque = double(v1 > -0.5) * K;

%% Plotting
figure;

% Plot membrane potentials
subplot(2,1,1);
plot(t, v1, 'r', 'LineWidth', 1.5); hold on;
plot(t, v2, 'b--', 'LineWidth', 1.5);hold on;
yline(-0.5, 'k--');  % Threshold line
legend('v_1', 'v_2', 'Threshold');
title('Neuron Membrane Potentials');
ylabel('Membrane Voltage');
grid on;

% Plot torque output
subplot(2,1,2);
plot(t, torque, 'k', 'LineWidth', 1.5);hold on;
xlabel('Time (s)');
ylabel('Torque');
title('Torque Output');
grid on;

%% Save results
save('single_HCO.mat', 't', 'v1', 'v2', 'torque');  % Save results to file

%% --- Local Function Definitions ---

% Time-dependent excitatory gain
function a3 = a3_time(t)
    if t > 3
        a3 = 1.2 * 1.5;  % Higher excitatory gain after 3s
    else
        a3 = 0.7 * 1.5;  % Lower gain before 3s
    end
end

% Sigmoidal synapse model
function s = synapse(vs, gain)
    % Computes a nonlinear synaptic effect based on presynaptic input vs
    s = gain / (1 + exp(-2 * (vs + 1)));  % Logistic function
end



%%
