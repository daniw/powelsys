% Cleanup workspace
clc;
clear;
close all;

% Load packages
pkg load control

% Boost converter parameters
vo = 200;
l = 200e-6;
c = 5e-6;
r = 50;
fs = 100e3;
vi = [50 100 150];

% Define internal variables
s = tf("s");

% Calculate static duty ratio
d = 1 - (vi / vo);

disp(["Duty ratios at different input voltages:"]);
disp(num2str([vi; d]'))
