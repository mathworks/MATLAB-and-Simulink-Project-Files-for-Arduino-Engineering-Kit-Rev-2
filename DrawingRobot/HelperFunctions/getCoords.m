function curvePoints = getCoords(shapeImage)
% Copyright 2018 - 2020 The MathWorks, Inc.
%
% Call the function `bwboundaries` to obtain the boundaries of each unique region.
[curves,~,N] = bwboundaries(shapeImage);
curves = curves(1:N); % Ignore hole boundaries

% Get the pixel points from the boundary detected
curvePoints = cell2mat(curves);

% Remove all duplicate points from the curve
curvePoints = unique(curvePoints,'rows','stable');

% In the image you're analyzing, remove all the pixels that were captured 
% by `bwboundaries`. There may still be pixels remaining in the image.

% Remove curves from the image
curveInd = sub2ind(size(shapeImage),curvePoints(:,1),curvePoints(:,2));
shapeImage(curveInd) = 0;

% Go through the image to check for any remaining pixels. If no pixels 
% remain, return the `curvePoints` found. If there are more pixels, then 
% call this function again and append `curvePoints` to the additional pixels 
% found by the recursive call.

% Call getCoords recursively if there are other curves remaining
if any(shapeImage(:))
    curvePoints = [curvePoints; getCoords(shapeImage)];
end
