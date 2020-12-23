function theta = xyToRadians(xy,Z_i,Base)
% Copyright 2020 The MathWorks, Inc.
% Define constants
r_spool = 0.0045;

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
theta = dStringLength/r_spool;