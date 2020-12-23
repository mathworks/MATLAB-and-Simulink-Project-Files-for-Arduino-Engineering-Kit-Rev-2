function [orthoView,tform, outputView, outputSize, newCorners] =  calibrateOrthoView(im, arenaHeight, arenaWidth)
% Copyright 2018 - 2020 The MathWorks, Inc.
% CALIBRATEORTHOVIEW returns the orthogonal view of the input image. It performs  
% a transformation based upon the coordinates of the corners of the arena
%% Get the coordinates of the four corners of the arena

% Determine the size of the image
imSize = size(im);

% Ask the user to click on the four corners of the arena
hFig = figure; 
imshow(im);
title('Mark the four corners of the arena with the mouse cursor');
hold on;

% Mark the 4 corners of the arena
corners = zeros(4,2);
for i = 1:4
    
    [corners(i,1), corners(i,2)] = ginput(1);
    text(corners(i,1), corners(i,2),'+', ...
        'HorizontalAlignment','center', ...
        'Color', [1 0 0], ...
        'FontSize',20);
end
close(hFig)

%% Perform the orthogonal transformation

% Undistort the image to remove the projective view. (We still need to resize the 
% image using the knowledge of the aspect ratio of the arena)
[undistortedImg,tform,outputView, newCorners] = undistortImageFromRectangle(...
                                                           im,corners,true);

% Calculate the scaling factors and scale the dimensions of the arena
arenaWidthPx = newCorners(3,1)-newCorners(2,1);
arenaHeightPx = newCorners(1,2)-newCorners(2,2);
HWAspectRatio = arenaHeight/arenaWidth;

arenaHeightPXScaled = HWAspectRatio*arenaWidthPx;
heightResizeFactor = arenaHeightPXScaled/arenaHeightPx;

% Scale the orthogonal view using the scaling factors calculated above
scaledImageSize = [imSize(1)*heightResizeFactor, imSize(2)];
orthoView = imresize(undistortedImg, scaledImageSize);  

% Find the newCorners on the resized image
cornersOriginalImage = [[1,1];
                        [1, imSize(1)];
                        [imSize(2), 1];
                        [imSize(2), imSize(1)]];
                    
cornersResizedImage = [[1,1];
                      [1, scaledImageSize(1)];
                      [scaledImageSize(2), 1];
                      [scaledImageSize(2), scaledImageSize(1)]];
                  
% Compute the resize Tform to find the new corners
resizeTform = fitgeotrans(cornersOriginalImage,cornersResizedImage,'projective');

[x, y] = resizeTform.transformPointsForward(newCorners(:,1),newCorners(:,2));
newCorners = [x,y];
outputSize = scaledImageSize;

% Save the results to the following .MAT files
save('orthoCalibrationData.mat', 'tform','outputView','outputSize', 'newCorners');