%% Preparation
% Cleanup workspace
clc;
clear;
close all;

% Load packages
pkg load control

% Define internal variables
s = tf('s');

% Define plot and print output
plotout = 1;
printout = 1;

%% Boost converter parameters
vo = 200;
%l = 62e-6;
l = 200e-6;
c = 5e-6;
r = 50;
fs = 100e3;
vi= [50 100 150];
vi_plot = [1:1:200];

% Display converter parameters
disp(['Step up converter analysis']);
disp(['']);
disp(['Output voltage:      '   num2str(vo)     ' V']);
disp(['Inductance:          '   num2str(l/1e-6) ' uH']);
disp(['Output capacitor:    '   num2str(c/1e-6) ' uF']);
disp(['Load resistance:     '   num2str(r)      ' Ohm']);
disp(['Switching frequency: '   num2str(fs/1e3) ' kHz']);
disp(['']);

%% Duty ratio and CCM analysis
% Calculate static duty ratio
d = 1 - (vi/ vo);
d_plot = 1 - (vi_plot / vo);

% Check for CCM
d_max= 2 * (vo * l * fs)./(r * vi);
ccm= d < d_max;
d_max_plot = 2 * (vo * l * fs)./(r * vi_plot);
ccm_plot = d_plot < d_max_plot;

% Display CCM for selected values
disp(['Duty ratios at different input voltages:']);
disp(num2str([vi; d; ccm]'))

% Plot CCM over complete input voltage range
if plotout
    figure(1);
    plot(vi_plot, d_plot, 'b', 'LineWidth', 3, vi_plot, d_max_plot, 'r', 'LineWidth', 3, vi_plot, ccm_plot, 'g', 'LineWidth', 2);
    grid on;
    title('CCM analysis');
    legend('Duty ratio', 'Limit for CCM', '1=CCM, 0=DCM');
    xlabel('V_i [V]');
    ylabel('d [ ]');
    ylim([0 3]);
    if printout
        print -dpdf fig/ccm.pdf
    end
end

% Transfer functions of converter
h1 = (vo) / (1-d(1)) * (1 - (l / ((1 - d(1))^2 * r)) * s) / (1 + (l / ((1 - d(1))^2 * r)) * s + ((c * l) / (1-d(1))^2) * s^2);
h2 = (vo) / (1-d(2)) * (1 - (l / ((1 - d(2))^2 * r)) * s) / (1 + (l / ((1 - d(2))^2 * r)) * s + ((c * l) / (1-d(2))^2) * s^2);
h3 = (vo) / (1-d(3)) * (1 - (l / ((1 - d(3))^2 * r)) * s) / (1 + (l / ((1 - d(3))^2 * r)) * s + ((c * l) / (1-d(3))^2) * s^2);

% Plot transfer functions
if plotout
    figure(2);
    bode(h1, h2, h3);
    legend(['D = ' num2str(d(1))], ['D = ' num2str(d(2))], ['D = ' num2str(d(3))]);
    if printout
        print -dpdf fig/h.pdf
    end
end

% Controller
kp = 0.000012;
kp = 0.000009;
wi = 200e3;
g_pi1 = kp * (1 + wi / s);
kp = 0.0000065;
wi = 300e3;
g_pi = kp * (1 + wi / s);

kp = 1;
wi = 1e3;
wt = 10e3;
g_pit1 = kp * ((1 + wi / s) / (1 + s / wt));

kp = 0.03;
wi1 = 3e3;
wi2 = 10e3;
wt1 = 60e3;
wt2 = 100e3;
g_pit2 = kp * (((1 + wi1 / s) * (1 + s / wi2)) / ((1 + s / wt1) * (1 + s / wt2)));

% Plot transfer functions
if plotout
    figure(3);
    bode(g_pi, g_pit1, g_pit2);
    legend('PI', 'PIT1', 'PIT2');
    if printout
        print -dpdf fig/h.pdf
    end
end

% Plot transfer functions
if plotout
    figure(4);
    bode(g_pi*h1, g_pi*h2, g_pi*h3);
    legend(['D = ' num2str(d(1))], ['D = ' num2str(d(2))], ['D = ' num2str(d(3))]);
    %line([100 1e7], [-(180-60) -(180-60)], 'Color', 'r', 'LineWidth', 2);
    %line([fs*pi fs*pi], [0 -400], 'Color', 'r', 'LineWidth', 2);
    if printout
        print -dpdf fig/bode_pi.pdf
    end
end

% Plot step response
if plotout
    figure(5);
    step(g_pi*h1/(1 + g_pi*h1), g_pi*h2/(1 + g_pi*h2), g_pi*h3/(1 + g_pi*h3), g_pi1*h1/(1 + g_pi1*h1), g_pi1*h2/(1 + g_pi1*h2), g_pi1*h3/(1 + g_pi1*h3));
    legend(['D = ' num2str(d(1))], ['D = ' num2str(d(2))], ['D = ' num2str(d(3))]);
    if printout
        print -dpdf fig/step_pi.pdf
    end
end

%figure()
%bode(g_pi, h1, h2, h3, g_pi*h1)
%%bode(g_pit2, h1, h2, h3, g_pit2*h1)
%line([fs*pi fs*pi], [0 -400], 'Color', 'r', 'LineWidth', 2);
%line([100 1e7], [-(180-60) -(180-60)], 'Color', 'r', 'LineWidth', 2);
%figure()
%step(g_pi*h1/(1 + g_pi*h1));
