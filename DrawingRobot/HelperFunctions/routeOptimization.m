function outSegmentsPix = routeOptimization(segmentsPix, initRobotPosition)
% Copyright 2018 - 2021 The MathWorks, Inc.
%
% Given a set of segments of an image, this algorithm sorts them in the
% order in which the bot draws the picture in the least amount of time. For
% sorting, we have used a greedy approach, where we draw the nearest
% segment first.

outSegmentsPix = cell(size(segmentsPix));   % to store the sorted segements
robotPosition = initRobotPosition;   % set the current position of the bot

% get starting and ending pixel of each segment
% column 1 & 2 - x and y coordinate of the pixel
% column 3 - index of the segment in segmentsPix to which the pixel belongs
startPix = zeros(size(segmentsPix,1), 4);   
endPix = zeros(size(segmentsPix,1), 4);
for i = 1:size(segmentsPix,1)
    t = segmentsPix{i, 1};  % get segment pixels
    startPix(i,1:2) = t(1,:); startPix(i,3) = i;
    endPix(i,1:2) = t(end,:); endPix(i,3) = i;
end

% Get the optimized order of segments
for s = 1:size(outSegmentsPix,1)
    
    % calculate the distance between the current robotPosition and the
    % starting pixel of each segment and store the distance in the fourth
    % column of startPix
    for j = 1:size(startPix,1)
        startPix(j,4) = pdist([robotPosition; startPix(j, 1:2)],'euclidean');
    end
    
    % choose the closest segment and update the robotPosition
    [~, idx] = min(startPix(:,4));
    robotPosition = endPix(idx, 1:2);
    outSegmentsPix(s,1) = segmentsPix(startPix(idx,3),1);
    
    % remove the used segment
    startPix(idx,:) = []; 
    endPix(idx,:) = [];
end

end