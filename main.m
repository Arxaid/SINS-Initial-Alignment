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
mps = 50;

% Initial SINS placement values
sins_altitude = 189;
sins_width = 55.81;
sins_g = equator_g * (1 + 0.0053024 * (sind(sins_width))^2 - ...
    0.0000058 * (sind(sins_width))^2) - 3.686 * 10^(-6) * sins_altitude;

% Parse data from SINS output file
datasheet = ParseData('data.txt');
totalTime = round(length(datasheet)/mps);

vector =    [0,0,0,0,0,0,0,0,0];
sumVector = [0,0,0,0,0,0,0,0,0];
yawDiff =   [];
pitchDiff = [];
rollDiff =  [];
timeArr =   [];

for timeCounter = 1:totalTime
    timeArr(timeCounter) = timeCounter;
    for measureCounter = 1:mps
        currentTick = (mps * (timeCounter - 1)) + measureCounter;
        % Current yaw angle value
        sumVector(1) = sumVector(1) + datasheet(currentTick, 4);
        % Current pitch angle value
        sumVector(2) = sumVector(2) + datasheet(currentTick, 5);
        % Current roll angle value
        sumVector(3) = sumVector(3) + datasheet(currentTick, 6);
        
        % Current OMx value
        sumVector(4) = sumVector(4) + deg2rad(datasheet(currentTick, 7));
        % Current OMy value
        sumVector(5) = sumVector(5) + deg2rad(datasheet(currentTick, 8));
        % Current OMz value
        sumVector(6) = sumVector(6) + deg2rad(datasheet(currentTick, 9));
        
        % Current Nx value
        sumVector(7) = sumVector(7) + datasheet(currentTick, 10) * sins_g;
        % Current Ny value
        sumVector(8) = sumVector(8) + datasheet(currentTick, 11) * sins_g;
        % Current Nz value
        sumVector(9) = sumVector(9) + datasheet(currentTick, 12) * sins_g;
    end
    % Awerage per second Nx value
    vector(timeCounter, 1) = sumVector(7)/(mps * timeCounter);
    % Awerage per second Ny value
    vector(timeCounter, 2) = sumVector(8)/(mps * timeCounter);
    % Awerage per second Nz value
    vector(timeCounter, 3) = sumVector(9)/(mps * timeCounter);
    
    % Awerage per second OMx value
    vector(timeCounter, 4) = sumVector(4)/(mps * timeCounter);
    % Awerage per second OMy value
    vector(timeCounter, 5) = sumVector(5)/(mps * timeCounter);
    % Awerage per second OMz value
    vector(timeCounter, 6) = sumVector(6)/(mps * timeCounter);
    
    % Orientation matrix C
    C = GetOrientMatrix(vector(timeCounter,:));
    
    % Awerage per second yaw angle value
    vector(timeCounter, 7) = sumVector(1)/(mps * timeCounter);
    % Awerage per second pitch angle value
    vector(timeCounter, 8) = sumVector(2)/(mps * timeCounter);
    % Awerage per second roll angle value
    vector(timeCounter, 9) = sumVector(3)/(mps * timeCounter);
    
    yawDiff(timeCounter) = abs(rad2deg(-atan2(C(3,1),C(1,1)))) - ...
        vector(timeCounter, 7);
    pitchDiff(timeCounter) = abs(rad2deg(asin(C(2,1)))) - ...
        vector(timeCounter, 8);
    rollDiff(timeCounter) = abs(rad2deg(-atan2(C(2,3),C(2,2)))) - ...
        vector(timeCounter, 9);
end

figure('Name','Yaw diff')
plot(timeArr, yawDiff)
figure('Name','Pitch diff')
plot(timeArr, pitchDiff)
figure('Name','Roll diff')
plot(timeArr, rollDiff)