% Stability diagram for the damped driven pendulum with accurate homoclinic bifurcation
% Equation: q'' + alpha*q' + sin(q) = I
clc; close all; clear;
% Define parameter ranges
alpha_vec = linspace(0, 2, 200);   % More appropriate damping range
I_vec = linspace(0, 2, 200);     % More appropriate torque range
[Alpha, Ival] = meshgrid(alpha_vec, I_vec);

% Initialize stability matrix
stability = zeros(size(Alpha));

% Calculate stability regions
for i = 1:length(I_vec)
    for j = 1:length(alpha_vec)
        if Ival(i,j) > 1
            stability(i,j) = 1;  % Rotation
        elseif Ival(i,j) < 1 && Alpha(i,j) < 0.5
            stability(i,j) = 2;  % Bistable
        else
            stability(i,j) = 0;  % Fixed point
        end
    end
end

% Calculate accurate homoclinic bifurcation curve
alpha_hom = linspace(0, 2, 50);
I_hom = zeros(size(alpha_hom));

% Numerical calculation of homoclinic bifurcation
for k = 1:length(alpha_hom)
    alpha = alpha_hom(k);
    if alpha == 0
        I_hom(k) = 0;
    else
        % Solve for I where homoclinic connection occurs
        options = optimset('TolX',1e-6);
        I_hom(k) = fzero(@(I) homoclinic_condition(I,alpha), [0 1], options);
    end
end

% Create the plot
figure;
hold on;

% Plot regions
imagesc(alpha_vec, I_vec, stability);
colormap([0.8 0.3 0.3; 0.3 0.3 0.8; 0.8 0.8 0.3]);

% Plot homoclinic bifurcation
plot(alpha_hom, I_hom, 'k-', 'LineWidth', 3, 'DisplayName', 'Homoclinic Bifurcation');

% Plot separatrix between regions
contour(Alpha, Ival, stability, [0.5 1.5], 'k', 'LineWidth', 1.5);

% Formatting
xlabel('Damping coefficient \alpha', 'FontSize', 12);
ylabel('Driving torque I', 'FontSize', 12);
% title('Pendulum Stability Diagram with Accurate Homoclinic Curve', 'FontSize', 14);

legend({'Fixed Point', 'Rotation', 'Bistable', 'Homoclinic'}, 'Location', 'northwest');
axis tight; grid on; box on;
colorbar('Ticks', [0.33, 1, 1.66], 'TickLabels', {'Fixed', 'Rotation', 'Bistable'});

% Homoclinic condition function
function val = homoclinic_condition(I, alpha)
    % Numerically determine when stable and unstable manifolds meet
    % Using energy balance approximation for the pendulum
    q0 = asin(I);  % Saddle point
    q1 = pi - asin(I);  % Unstable point
    
    % Energy difference approximation
    val = 2*alpha*(2*q1 - pi*I) - (4*I*cos(q0) + 4*sin(q1));
end
