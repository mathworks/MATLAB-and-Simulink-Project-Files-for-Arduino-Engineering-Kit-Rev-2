function output = mobileRoverRoot()
% This function returns the path for the Arduino Kit Project Files Mobile
% Rover folder

% Copyright 2018 - 2020 The MathWorks, Inc.

output = fileparts(fileparts(mfilename('fullpath')));
output = fullfile(output,'MobileRover');

end