% Cleanup workspace
clc;
clear;
close all;

% Output
detail=0;
detailplot=1;
disp('Multilevel inverter output voltage analysis');
disp('');

% Define possible voltages of one phase leg
ud1 = 10;
ud2 = 20;
phase_leg = [ud1 0 -ud2];
%phase_leg = [-1 1]*300;
%phase_leg = [-2 -1 0 1 2];
disp(['Phase leg voltages: ' num2str(numel(phase_leg))]);
disp([num2str(phase_leg)]);

% All possible output voltage combinations
[c, b, a] = ndgrid(phase_leg, phase_leg, phase_leg);
u_abc0 = [a(:) b(:) c(:)];
u_a0 = u_abc0(:,1);
u_b0 = u_abc0(:,2);
u_c0 = u_abc0(:,3);
if detail
    disp('Output combinations: ');
    disp(u_abc0);
end

% Phase-Phase voltages
% a -> b
u_ab = u_a0 - u_b0;
% b -> c
u_bc = u_b0 - u_c0;
% c -> a
u_ca = u_c0 - u_a0;
disp(['Phase-phase voltages: ' num2str(numel(unique(u_ab)))]);
disp([num2str(unique(u_ab)')]);

% Star point voltages
u_0 = sum(u_abc0')';
if detail
    disp('Star point voltages: ');
    disp(u_0);
end

% Load voltage to star point
u_a = (3*u_a0 - u_0)/3;
u_b = (3*u_b0 - u_0)/3;
u_c = (3*u_c0 - u_0)/3;
disp(['Load voltages: ' num2str(numel(unique(u_a)))]);
disp([num2str(unique(u_a)')]);
if detail
    disp('Load voltages: ');
    disp(u_a);
end

% Load votlage vectors
u_abc = [u_a, u_b, u_c];
disp(['Load voltage vectors: ' num2str(numel(unique(u_abc, 'rows'))/3)]);
if detail
    disp([unique(u_abc, 'rows')]);
end
u_abc_comp = u_a * exp(0/180*pi*j) + u_b * exp(120/180*pi*j) + u_c * exp(-120/180*pi*j);
if detailplot
    plot(u_abc_comp, 'o');
    grid on;
end
