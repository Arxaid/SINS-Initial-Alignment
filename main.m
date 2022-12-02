% This file is part of the SINS Initial Alignment.
%
% Copyright (c) 2022 Vladislav Sosedov, Alexander Novikov.
%
% Feel free to use, copy, modify, merge, and publish this software.

clear all
close all
clc

% Constant values
equator_g = 9.780327;

% SINS measurements per second
mps = 50;

% Initial SINS placement values
sins_altitude = 189;
sins_width = 55 + 81/100;
sins_g = equator_g * (1 + 0.0053024 * (sind(sins_width))^2 - ...
    0.0000058 * (sind(sins_width))^2) - 3.686 * 10^(-6) * sins_altitude;

% Parse data from SINS output file
datasheet = ParseData('data.txt');
totalTime = round(length(datasheet)/mps);

vector = [0,0,0,0,0,0,0,0,0];