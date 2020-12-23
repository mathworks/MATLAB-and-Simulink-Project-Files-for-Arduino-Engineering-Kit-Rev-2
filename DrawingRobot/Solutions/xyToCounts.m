function counts = xyToCounts(xy,Z_i,Base)
% Copyright 2018 - 2020 The MathWorks, Inc.
% Define constants
r_spool = 0.0045;
countsPerRevolution = 1200;
countsPerRadian = countsPerRevolution/(2*pi);

% Convert x and y to Z1 and Z2
x = xy(:,1);
y = xy(:,2);
Z(:,1) = sqrt(x.^2 + y.^2);
Z(:,2) = sqrt((Base-x).^2 + y.^2);
% Subtract initial Z to get change in Z
dZ = Z - Z_i;
% Convert change in Z to change in string length
dStringLength = 2*dZ;
% Compute change in string length to angle
phi = dStringLength/r_spool;
% Convert angle to counts
counts = phi*countsPerRadian;