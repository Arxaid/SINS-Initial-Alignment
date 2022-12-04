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
yawReal =   [];
pitchReal = [];
rollReal =  [];
yawCalc =   [];
pitchCalc = [];
rollCalc =  [];
yawDiff =   [];
pitchDiff = [];
rollDiff =  [];
timeArr =   [];

% Main loop
for timeCounter = 1:totalTime
    
    % Filling time array
    timeArr(timeCounter) = timeCounter;
    
    % Accumulating data
    for measureCounter = 1:mps
        currentTick = (mps * (timeCounter - 1)) + measureCounter;
        % Accumulation of current yaw angle value
        sumVector(1) = sumVector(1) + datasheet(currentTick, 4);
        % Accumulation of current pitch angle value
        sumVector(2) = sumVector(2) + datasheet(currentTick, 5);
        % Accumulation of current roll angle value
        sumVector(3) = sumVector(3) + datasheet(currentTick, 6);
        
        % Accumulation of current OMx value
        sumVector(4) = sumVector(4) + deg2rad(datasheet(currentTick, 7));
        % Accumulation of current OMy value
        sumVector(5) = sumVector(5) + deg2rad(datasheet(currentTick, 8));
        % Accumulation of current OMz value
        sumVector(6) = sumVector(6) + deg2rad(datasheet(currentTick, 9));
        
        % Accumulation of current Nx value
        sumVector(7) = sumVector(7) + datasheet(currentTick, 10) * sins_g;
        % Accumulation of current Ny value
        sumVector(8) = sumVector(8) + datasheet(currentTick, 11) * sins_g;
        % Accumulation of current Nz value
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
    
    % Calculating orientation matrix C
    C = GetOrientMatrix(vector(timeCounter,:));
    % Calculating yaw angle value w/ orientation matrix
    yawCalc(timeCounter) = rad2deg(atan2(C(3,1),C(1,1)));
    % Calculating pitch angle value w/ orientation matrix
    pitchCalc(timeCounter) = rad2deg(asin(C(2,1)));
    % Calculating roll angle value w/ orientation matrix
    rollCalc(timeCounter) = rad2deg(-atan2(C(2,3),C(2,2)));
    
    % Awerage per second yaw angle value
    vector(timeCounter, 7) = sumVector(1)/(mps * timeCounter);
    yawReal(timeCounter) = vector(timeCounter, 7);
    % Awerage per second pitch angle value
    vector(timeCounter, 8) = sumVector(2)/(mps * timeCounter);
    pitchReal(timeCounter) = vector(timeCounter, 8);
    % Awerage per second roll angle value
    vector(timeCounter, 9) = sumVector(3)/(mps * timeCounter);
    rollReal(timeCounter) = vector(timeCounter, 9);
    
    % Calculating difference between real and calculated angles
    yawDiff(timeCounter) = yawCalc(timeCounter) - yawReal(timeCounter);
    pitchDiff(timeCounter) = pitchCalc(timeCounter) - pitchReal(timeCounter);
    rollDiff(timeCounter) = rollCalc(timeCounter) - rollReal(timeCounter);
    
    disp('_____________________________________________');
    disp(['Time:                           ' num2str(timeArr(timeCounter)) ' sec']);
    disp(['Awerage per second yaw angle:   ' num2str(vector(timeCounter, 7))]);
    disp(['Awerage per second pitch angle: ' num2str(vector(timeCounter, 8))]);
    disp(['Awerage per second roll angle:  ' num2str(vector(timeCounter, 9))]);
    disp(['Calculated yaw angle:           ' num2str(yawCalc(timeCounter))]);
    disp(['Calculated pitch angle:         ' num2str(pitchCalc(timeCounter))]);
    disp(['Calculated roll angle:          ' num2str(rollCalc(timeCounter))]);
    disp(['Difference between yaw angles:  ' num2str(yawDiff(timeCounter))]);
    disp(['Difference between pitch angles:' num2str(pitchDiff(timeCounter))]);
    disp(['Difference between roll angles: ' num2str(rollDiff(timeCounter))]);
end
disp('_____________________________________________');

figure('Name','Yaw angle')
plot(timeArr, yawReal, timeArr, yawCalc), grid
xlabel('t, sec')
ylabel('Yaw angle, grades')
legend('Real', 'Calc')

figure('Name','Yaw angles difference')
plot(timeArr, yawDiff), grid
xlabel('t, sec')
ylabel('Yaw angle, grades')

figure('Name','Pitch angle')
plot(timeArr, pitchReal, timeArr, pitchCalc), grid
xlabel('t, sec')
ylabel('Pitch angle, grades')
legend('Real', 'Calc')

figure('Name','Pitch angles difference')
plot(timeArr, pitchDiff), grid
xlabel('t, sec')
ylabel('Pitch angle, grades')

figure('Name','Roll angle')
plot(timeArr, rollReal, timeArr, rollCalc), grid
xlabel('t, sec')
ylabel('Roll angle, grades')
legend('Real', 'Calc')

figure('Name','Roll angles difference')
plot(timeArr, rollDiff), grid
xlabel('t, sec')
ylabel('Roll angle, grades')