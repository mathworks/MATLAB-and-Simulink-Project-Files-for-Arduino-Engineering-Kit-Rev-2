% Copyright 2018 - 2020 The MathWorks, Inc.

% Capture image from webcam
% w = webcam;
w = webcam('USB2.0 PC CAMERA'); %Alternative syntax
preview(w)
pause
img = snapshot(w);
clear w

% Convert image to pixel segments
[segmentsPix,xLimPix,yLimPix] = imageToPixelSegments(img);

% Identify initial position on whiteboard
Z_i = initialPosition();

% Draw image
drawImageFromPix(segmentsPix,xLimPix,yLimPix,Z_i)