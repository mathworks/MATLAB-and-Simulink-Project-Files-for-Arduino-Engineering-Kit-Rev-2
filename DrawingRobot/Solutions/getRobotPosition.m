function [x,y] = getRobotPosition(Z_i, Base)
% Copyright 2018 - 2021 The MathWorks, Inc.
% Given L1, L2, & Base length - find the position of the robot 

x = (Base^2 + Z_i(1,1)^2 - Z_i(1,2)^2)/(2*Base); %meters
y = sqrt(Z_i(1,1)^2-x^2); %meters

end
