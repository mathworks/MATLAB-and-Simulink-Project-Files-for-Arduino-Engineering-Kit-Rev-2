function [x,y] = targetPos(IMG,newCorners)
% Copyright 2018 - 2020 The MathWorks, Inc.
% Create a square morphological object that will be used to clean the
% processed image later
s = strel('square',20);

% Store some useful constants that will be used for cropping the image and
% computing the target's centroid
minX = min(newCorners(:,1));
minY = min(newCorners(:,2));
width = max(newCorners(:,1)) - min(newCorners(:,1));
height = max(newCorners(:,2)) - min(newCorners(:,2));

% Crop the input image to only focus on the arena
Output = imcrop(IMG, [minX minY width height]);

% Threshold the image
Bin = Output(:,:,1) < 50 & Output(:,:,2) < 50 & Output(:,:,3) < 50;

% Remove squares that do not have a width of 8 pixels 
Bf = imopen(Bin,s);
B = imclose(Bf,s);
%% Position Calculation (Getting the centroid of the target)

% Get the target's centroid
sB = regionprops(B,'centroid');
cB = sB.Centroid;

% Output the (x,y) coordinates of the target. A constant is added because
% centroid was calculated with the origin point being with respect to the
% arena instead of the image.

x = minX + cB(1);
y = minY + cB(2);