% vary_tau_s_compact.m
% Explore the effect of tau_s (synaptic time constant) on neural oscillation

clear; clc; close all;

%% Shared Parameters
rho = 1000; L = 0.36; r = 0.02;
vol = pi * r^2 * L;
m = rho * vol; g = 9.81;
Jperp = (1/12)*m*(L^2 + 3*r^2) + m*(L/2)^2;
damp = 1.0;
omega_n = sqrt((m * g * (L / 2)) / Jperp);
K = 1;
K_ND = K / (m * g * L / 2);
alpha = (damp * L / 2) / sqrt(Jperp * m * g * L / 2);
t_factor = sqrt(m * g * (L / 2) / Jperp);
Tf = 6;

input_fn1 = @(t) (t > 0.3 && t < 0.6) * -1.2 + ~(t > 0.3 && t < 0.6) * -1;
input_fn2 = @(t) -1;

a4s = [1.57, 1.75, 2.49, 3.56];
a2 = 0.8 * 2;
a4 = a4s(3);
a1 = 2;
tau_m = 0.001;
tau_us = 2.5;

tau_s_values = [0.02, 0.05, 0.1];
colors = lines(length(tau_s_values));

figure;

for i = 1:length(tau_s_values)
    tau_s = tau_s_values(i);

    neuron_odes = @(t, x) [
        (-x(1) + a1*tanh(x(1)) - a2*tanh(x(2)) + ...
         a3_time(t)*tanh(x(2)+0.9) - a4*tanh(x(3)+0.9) + ...
         synapse(x(5), -0.2) + input_fn1(t)) / tau_m;

        (x(1) - x(2)) / tau_s;
        (x(1) - x(3)) / tau_us;

        (-x(4) + a1*tanh(x(4)) - a2*tanh(x(5)) + ...
         a3_time(t)*tanh(x(5)+0.9) - a4*tanh(x(6)+0.9) + ...
         synapse(x(2), -0.2) + input_fn2(t)) / tau_m;

        (x(4) - x(5)) / tau_s;
        (x(4) - x(6)) / tau_us;
    ];

    x0 = [0, 0, -1, 0, 0, -0.5];
    [t, x] = ode15s(neuron_odes, [0 Tf], x0);

    v1 = x(:,1);
    torque = double(v1 > -0.5) * K;

    % Plot both v1 and torque in the same subplot
    subplot(3,1,i);

    % Plot v1
    yyaxis left
    plot(t, v1, 'LineWidth', 1.5);
    ylabel('v_1');
    ylim([-2, 2]);
    hold on;
    yline(-0.5, '--k', 'Threshold', ...
        'LabelHorizontalAlignment', 'left', ...
        'LabelVerticalAlignment', 'bottom');

    % Plot torque
    yyaxis right
    plot(t, torque, '-', 'LineWidth', 1.2); % Solid line for torque
    ylabel('Torque');
    ylim([-0.2, 1.2]);

    title(sprintf('\\tau_s = %.2f', tau_s));
    xlabel('Time (s)');
    grid on;
end

sgtitle('Membrane Potential and Torque for Different \tau_s');


%% Local Functions
function a3 = a3_time(t)
    if t > 3
        a3 = 1.2 * 1.5;
    else
        a3 = 0.7 * 1.5;
    end
end

function s = synapse(vs, gain)
    s = gain / (1 + exp(-2 * (vs + 1)));
end
