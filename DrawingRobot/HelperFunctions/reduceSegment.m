function reducedSegment = reduceSegment(segment,radius)
% Copyright 2018 - 2020 The MathWorks, Inc.

% First, create variables that will be used to decide which points to keep
% in the reducedSegment.

nPoints = size(segment,1);
keepPoint = true(nPoints,1);
reference = 1;
test = 2;

% Loop through the segment and decide which points to remove. By default, 
% all points will be included in the output. Select points to keep and 
% remove such that each consecutive point remaining is separated by a
% minimum distance from the previous point.

while test < nPoints
    
    % Check if the distance between the reference point and the current 
    % test point is less than the specified minimum radius. If it is, mark 
    % the test point for removal and test the next point in the segment.
    
    if norm(segment(test,:) - segment(reference,:)) < radius
        % If so, mark test point for removal and test the next point
        keepPoint(test) = false;
        test = test + 1;
    
    % If the distance between the two points exceeds the specified radius, 
    % make the test point the new reference point, and begin testing the
    % next point in the segment.
    
    else
        % If not, update reference and test points
        reference = test;
        test = reference + 1;
    end
end

% Create the output by keeping only the points that are not marked for removal.
reducedSegment = segment(keepPoint,:);