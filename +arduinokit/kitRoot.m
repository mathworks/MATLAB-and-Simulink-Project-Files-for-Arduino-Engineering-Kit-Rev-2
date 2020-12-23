function output = kitRoot()
% This function returns the path where Arduino Kit Project Files is
% installed. 

%   Copyright 2018 - 2020 The MathWorks, Inc.

output = fileparts(fileparts(mfilename('fullpath')));

end