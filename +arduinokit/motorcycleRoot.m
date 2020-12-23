function output = motorcycleRoot()
% This function returns the path for the Arduino Kit Project Files
% Motorcycle folder

% Copyright 2018 - 2020 The MathWorks, Inc.

output = fileparts(fileparts(mfilename('fullpath')));
output = fullfile(output,'Motorcycle');

end