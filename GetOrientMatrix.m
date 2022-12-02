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
Nx = vector(1);
Ny = vector(2);
Nz = vector(3);
OMx = vector(4);
OMy = vector(5);
OMz = vector(6);

% Calculation of ort coordinates
m1 = sqrt(Nx^2 + Ny^2 + Nz^2);
m2 = sqrt((Ny * OMz - Nz * OMy)^2 + (Nz * OMx - Nx * OMz)^2 + ...
    (Nx * OMy - Ny * OMx)^2);

e11(1) = Nx/m1;
e11(2) = Ny/m1;
e11(3) = Nz/m1;

e12(1) = (Ny * OMz - Nz * OMy)/m2;
e12(2) = (Nz * OMx - Nx * OMz)/m2;
e12(3) = (Nx * OMy - Ny * OMx)/m2;

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