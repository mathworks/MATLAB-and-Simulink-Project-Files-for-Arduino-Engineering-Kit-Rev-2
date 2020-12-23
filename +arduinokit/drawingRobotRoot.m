function output = drawingRobotRoot()
% This function returns the path for the Arduino Kit Project Files Drawing
% Robot folder

% Copyright 2018 - 2020 The MathWorks, Inc.

output = fileparts(fileparts(mfilename('fullpath')));
output = fullfile(output,'DrawingRobot');

end