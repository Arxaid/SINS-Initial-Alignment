% This file is part of the SINS Initial Alignment.
%
% Copyright (c) 2022 Vladislav Sosedov, Alexander Novikov.
%
% Feel free to use, copy, modify, merge, and publish this software.

function datasheet = ParseData(name)
% Input:
%   File name
% Output:
%   Datasheet array consists parsed data from file

% Number of strings in file
dataFile = fopen(name, 'rt');

fileSize = 0;

while ~feof(dataFile)
    fileSize = fileSize + sum(fread(dataFile, 16384, 'char') == char(10));
end

fclose(dataFile);

% Parsing loop
dataFile = fopen(name, 'r');

datasheet = [[],[],[],[],[],[],[],[],[],[],[],[]];

for counter = 1:fileSize
    data = fscanf(dataFile, ['%d' char(58) '%d' char(58) '%d' '%f' ... 
                  '%f' '%f' '%f' '%f' '%f' '%f' '%f' '%f'],[12 1]);
    for i = 1:12
        datasheet(counter, i) = data(i);
    end
end

fclose(dataFile);