function [horzOffsetRange, verticalOffsetRange] = calibrateLocationOffset(objectType, imUp, imDown, imLeft, imRight, tform,outputView, outputSize)
% Copyright 2018 - 2020 The MathWorks, Inc.
% Create some images and variables to calculate the location offset values
% for a given object (rover or target)

% Suppress a warning related to displaying large images
id = 'images:initSize:adjustingMag';
warning('off',id)

undistortedImUp = im2orthoview(imUp,tform,outputView, outputSize);
undistortedImDown = im2orthoview(imDown,tform,outputView, outputSize);
undistortedImLeft = im2orthoview(imLeft,tform,outputView, outputSize);
undistortedImRight = im2orthoview(imRight,tform,outputView, outputSize);

% Determine whether we are calculating offsets for the target or the rover
if strcmp(objectType,'rover')
    verticalOffsetRange = zeros(1,2);
    horzOffsetRange = zeros(1,2);
    annote_str = 'Please click on the point where you actually placed the rover and then click on the center of the disc on this image';
elseif strcmp(objectType, 'target')
    verticalOffsetRangeTarget = zeros(1,2);
    horzOffsetRangeTarget = zeros(1,2);
    annote_str = 'Please click on the point where you actually placed the target and then click on its center on this image';
end
%% Get the offset when the object is located on the top edge

h = figure;
imshowobj = imshow(undistortedImUp);
instrBox = annotation('textbox',imshowobj.Parent.Position,'String',annote_str,'FitBoxToText','on'); instrBox.BackgroundColor = 'w';

if strcmpi(objectType,'rover')
    title('Rover Location: Top (Select the original rover location followed by the center of disc on this image)');
elseif strcmpi(objectType, 'target')
    title('Target Location: Top (Select the original target location followed by its center on this image)');
end

[x, y] = ginput(2);
centerUp = [x y];
close(h);
%% Get the offset when the object is located on the bottom edge

h = figure;
imshowobj = imshow(undistortedImDown);
instrBox = annotation('textbox',imshowobj.Parent.Position,'String',annote_str,'FitBoxToText','on'); instrBox.BackgroundColor = 'w';

if strcmpi(objectType,'rover')
    title('Rover Location: Bottom (Select the original rover location followed by the center of disc on this image)');
elseif strcmpi(objectType, 'target')
    title('Target Location: Bottom (Select the original target location followed by its center on this image)');
end

[x, y] = ginput(2);
centerDown = [x y];
close(h);
%% Get the offset when the object is located on the left edge

h = figure;
imshowobj = imshow(undistortedImLeft);
instrBox = annotation('textbox',imshowobj.Parent.Position,'String',annote_str,'FitBoxToText','on'); instrBox.BackgroundColor = 'w';

if strcmpi(objectType,'rover')
    title('Rover Location: Left (Select the original rover location followed by the center of disc on this image)');
elseif strcmpi(objectType, 'target')
    title('Target Location: Left (Select the original target location followed by its center on this image)');
end

[x, y] = ginput(2);
centerLeft = [x y];
close(h);
%% Get the offset when the object is located on the right edge

h = figure;
imshowobj = imshow(undistortedImRight);
instrBox = annotation('textbox',imshowobj.Parent.Position,'String',annote_str,'FitBoxToText','on'); instrBox.BackgroundColor = 'w';

if strcmpi(objectType,'rover')
    title('Rover Location: Right (Select the original rover location followed by the center of disc on this image)');
elseif strcmpi(objectType, 'target')
    title('Target Location: Right (Select the original target location followed by its center on this image)');
end

[x, y] = ginput(2);
centerRight = [x y];
close(h);
%% Calculate the offset ranges and save them to the appropriate .MAT file
if strcmpi(objectType,'rover')
    verticalOffsetRange(1) = centerDown(1,2) -centerDown(2,2);
    verticalOffsetRange(2) = centerUp(1,2) -centerUp(2,2);
    horzOffsetRange(1) = centerLeft(1,1) -centerLeft(2,1);
    horzOffsetRange(2) = centerRight(1,1) -centerRight(2,1);
    
    save('offsetCalibrationRover.mat', 'verticalOffsetRange', 'horzOffsetRange');
elseif strcmpi(objectType, 'target')
    verticalOffsetRangeTarget(1) = centerDown(1,2) -centerDown(2,2);
    verticalOffsetRangeTarget(2) = centerUp(1,2) -centerUp(2,2);
    horzOffsetRangeTarget(1) = centerLeft(1,1) -centerLeft(2,1);
    horzOffsetRangeTarget(2) = centerRight(1,1) -centerRight(2,1);
    
    % Assign the target ranges to the function's outputs
    verticalOffsetRange = verticalOffsetRangeTarget;
    horzOffsetRange = horzOffsetRangeTarget;
    
    save('offsetCalibrationTarget.mat', 'verticalOffsetRangeTarget', 'horzOffsetRangeTarget');
end
warning('on',id)