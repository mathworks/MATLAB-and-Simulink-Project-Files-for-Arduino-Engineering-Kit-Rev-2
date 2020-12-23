function [undistortedImg,tform, outputView, newCorners] = undistortImageFromRectangle(inputImg,inputPoints,autoSort)
% Copyright 2018 - 2020 The MathWorks, Inc. 
% Unwarp image from four corners of a distorted rectangle
%
% PROVIDE 4 CORNER POINTS OF A WARPED RECTANGLE IN [BL, TL, TR, BR]
% ORDER, OR REQUEST AUTOSORT; THIS FUNCTION WILL UNWARP THE IMAGE
% CONTAINING IT.
%
% [undistortedImg,tform,newCorners] = ...
%     undistortImageFromRectangle(inputImg,inputPoints,autoSort)
%
% INPUTS: 
% inputImage: A distorted image, or the name of a distorted image.
%
% inputPoints: The coordinates of 4 corners of a distorted rectangle
%    in the image, in a 4x2 array.
%
%    The points must be in [BL, TL, TR, BR] order, OR you must set
%    autoSort to true.
%
% autoSort: T/F Flag to request auto-sorting of the corners to [BL,
%    TL, TR, BR] order. Default: false.
%
% OUTPUTS:
% undistortedImg: Distortion-corrected version of inputImg;
%
% tform: The tform object with which the image will be undistorted.
% 
% newCorners: The locations of the rectangle corners after
%    transforming.
%
% © 2018 The MathWorks, Inc.

if ischar(inputImg)
	inputImg = imread(inputImg);
end

if nargin == 3 && autoSort
	% Attempt to auto-sort corners into [BL, TL, TR, BR] order:
	inputPoints = reorderCorners(inputPoints,inputImg(:,:,1),[4 1 2 3]);
end
	
basepoints = [inputPoints(1,:);
	inputPoints(1,1) inputPoints(2,2);
	inputPoints(4,1) inputPoints(2,2);
	inputPoints(4,1),inputPoints(1,2)];
tform = fitgeotrans(inputPoints,basepoints,'projective');
outputView = imref2d(size(inputImg));
undistortedImg = imwarp(inputImg,tform,'OutputView',outputView);

if nargout > 2
	% Calculated values--should be pretty close to basepoints, if all went well!
	% isequal(newCorners,basepoints)
	[newX,newY] = tform.transformPointsForward(inputPoints(:,1),inputPoints(:,2));
	newCorners = [newX,newY];
end
 
function sortedCorners = reorderCorners(corners,img,order)
% SORTS CORNERS (BY DEFAULT) TO:
% UL = 1;
% UR = 2;
% LR = 3;
% LL = 4;
[nrows, ncols, ~] = size(img); 
if nargin < 3
	order = 1:4;
end
cornerInds = zeros(4,1);

% INDEX 1: Upper Left, Closest to:
cornerCoord  = [0 0];
[~, cornerInds(1)] = ...
    min(sqrt((corners(:,1)-cornerCoord(1)).^2 + (corners(:,2)-cornerCoord(2)).^2));

% INDEX 2: Upper Right, Closest to:
cornerCoord  = [ncols 0];
[~, cornerInds(2)] = ...
    min(sqrt((corners(:,1)-cornerCoord(1)).^2 + (corners(:,2)-cornerCoord(2)).^2));

% INDEX 3: Lower Left, Closest to:
cornerCoord  = [ncols nrows];
[~, cornerInds(3)] = ...
    min(sqrt((corners(:,1)-cornerCoord(1)).^2 + (corners(:,2)-cornerCoord(2)).^2));

% INDEX 4: Lower Right:
cornerInds(4) = setdiff(1:4,cornerInds(1:3));
% Reorder corners to Upper Left;Upper Right; Lower Right;
% Lower Left:
sortedCorners = corners(cornerInds(order),:);