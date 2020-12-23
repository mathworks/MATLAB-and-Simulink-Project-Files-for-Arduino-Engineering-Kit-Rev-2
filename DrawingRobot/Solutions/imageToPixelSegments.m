function [segmentsPix,xLimPix,yLimPix] = imageToPixelSegments(img)
% Copyright 2018 - 2020 The MathWorks, Inc.

% Extract line traces from the image
img2 = ~imbinarize(rgb2gray(img),'adaptive','ForegroundPolarity','dark');
img3 = bwmorph(img2,'clean');
img4 = bwmorph(img3,'thin',inf);

% Extract pixels in order
coordsPix = getCoords(img4);

% Break coordinates list into contiguous segments
segmentsPix = coords2segments(coordsPix);

% Clean data and merge connected segments
segmentsPix = connectSegments(segmentsPix);

% Store x and y pixel limits
xLimPix = [min(coordsPix(:,2)) max(coordsPix(:,2))];
yLimPix = [min(coordsPix(:,1)) max(coordsPix(:,1))];