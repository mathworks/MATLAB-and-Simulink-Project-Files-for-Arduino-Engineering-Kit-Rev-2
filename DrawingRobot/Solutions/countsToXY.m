function xy = countsToXY(counts,Z_i,Base)
% Copyright 2018 - 2020 The MathWorks, Inc.

% Define constants
countsPerRevolution = 1200;
countsPerRadian = countsPerRevolution/(2*pi);
r_spool = 0.0045;

% Convert counts to angle
theta = counts/countsPerRadian;

% Convert angle to change in string length
dStringLength = r_spool*theta;

% Convert change in string length to change in Z
dZ = dStringLength/2;

% Add change in Z to initial Z to get current Z
Z = Z_i + dZ;

% Compute x and y from Z1 and Z2
x = (Base^2 + Z(1)^2 - Z(2)^2)/(2*Base);
y = sqrt(Z(1)^2-x^2);
xy = [x,y];
