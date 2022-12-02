% This file is part of the SINS Initial Alignment.
%
% Copyright (c) 2022 Vladislav Sosedov, Alexander Novikov.
%
% Feel free to use, copy, modify, merge, and publish this software.

function C = GetOrientMatrix(vector)
% Input:
%   SINS initial alignment coordinates vector
%   in the instrument coordinate system
% Output:
%   Orientation matrix C in the instrument
%   coordinate system

% Initialize single values from vector
dx = vector(1);
dy = vector(2);
dz = vector(3);
wx = vector(4);
wy = vector(5);
wz = vector(6);

% Calculation of ort coordinates
m1 = sqrt(dx^2 + dy^2 + dz^2);
m2 = sqrt((dy * wz - dz * wy)^2 + (dz * wx - dx * wz)^2 + ...
    (dx * wy - dy * wx)^2);

e11(1) = dx/m1;
e11(2) = dy/m1;
e11(3) = dz/m1;

e12(1) = (dy * wz - dz * wy)/m2;
e12(2) = (dz * wx - dx * wz)/m2;
e12(3) = (dx * wy - dy * wx)/m2;

e13(1) = e11(2) * e12(3) - e11(3) * e12(2);
e13(2) = e11(3) * e12(1) - e11(1) * e12(3);
e13(3) = e11(1) * e12(2) - e11(2) * e12(1);

% Accompanying trihedron coordinates
e2 = [0  0 -1;
      1  0  0;
      0 -1  0];

% Intermediate matrix  
e = [e11(1) e11(2) e11(3);
     e12(1) e12(2) e12(3);
     e13(1) e13(2) e13(3)];
 
% Final orientation matrix C 
C = e2 * e;
end