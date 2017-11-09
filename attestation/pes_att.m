% Cleanup workspace
clc;
clear;
close all;

% Load packages
pkg load control

% Detailed analysis
detail = 0;

% Boost converter parameters
vo = 200;
l = 200e-6;
c = 5e-6;
r = 50;
fs = 100e3;
if detail
    vi = [1:1:200];
else
    vi = [50 100 150];
end

% Define internal variables
s = tf("s");

% Calculate static duty ratio
d = 1 - (vi / vo);

% Check for CCM
ccm = d < 2 * (vo * l * fs)./(r * vi);

if detail
    figure(1);
    plot(vi, d, "b", "LineWidth", 3, vi, 2 * (vo * l * fs)./(r * vi), "r", "LineWidth", 3);
    grid on;
    title("CCM analysis");
    legend("Duty ratio", "Limit for CCM");
    xlabel("V_i [V]");
    ylabel("d [ ]");
    ylim([0 5]);
else
    disp(["Duty ratios at different input voltages:"]);
    disp(num2str([vi; d; ccm]'))
end
