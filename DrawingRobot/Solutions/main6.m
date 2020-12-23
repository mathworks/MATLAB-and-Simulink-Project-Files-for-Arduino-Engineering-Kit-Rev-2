% Copyright 2018 - 2020 The MathWorks, Inc.

% Load image from file
img = imread('MathWorksLogo.jpg');

% Convert image to pixel segments
[segmentsPix,xLimPix,yLimPix] = imageToPixelSegments(img);

% Identify initial position on whiteboard
Z_i = initialPosition();

% Draw image
drawImageFromPix(segmentsPix,xLimPix,yLimPix,Z_i)