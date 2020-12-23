function Z_i = initialPosition()
% Copyright 2018 - 2020 The MathWorks, Inc.

str = inputdlg({'L1 (meters)','L2 (meters)'},'Enter initial string lengths.',[1 50]);
L1_i = str2double(str{1}); %meters
L2_i = str2double(str{2}); %meters

L_arm = 0.075;             %meters
Z_i = [L1_i L2_i] + L_arm; %meters