function segmentsPix = coords2segments(coordsPix)
% Copyright 2018 - 2020 The MathWorks, Inc.
%
% Find the locations where consecutive pixels are not adjacent. Create a 
% breaks variable that is a logical index with value 1 where there is a 
% break and 0 where pixels are adjacent.

consecutiveDistance = abs(diff(coordsPix));
breaks = any(consecutiveDistance > [1 1],2);

% Use the breaks variable to construct the start and end indices of each 
% segment. Then loop through the segments and create a cell array 
% segmentsPix, where each cell contains all the pixel coordinates for that 
% segment.

% Build cell array of each segment of adjacent pixel coordinates
numSegments = sum(breaks)+1;
segmentsPix = cell(numSegments,1);
breakInds = [0; find(breaks); size(coordsPix,1)];
for ii = 1:numSegments
    segmentsPix{ii} = coordsPix(breakInds(ii)+1:breakInds(ii+1),:);
end