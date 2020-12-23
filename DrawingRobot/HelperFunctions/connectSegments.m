function segments = connectSegments(segments)
% Copyright 2018 - 2020 The MathWorks, Inc.
%
% If a segment intersects itself, such as in the letter "O," it will end at
% a point that is adjacent to another pixel in that segment. This will 
% create a small gap when drawn on the whiteboard. To correct this, add the
% final adjacent pixel to the end of that segment so the line is closed. 
% This section of code looks at each segment, finds any self-intersections,
% and closes them. p1 is the first point in a segment. pN is the last point
% in the segment. Add any points near p1 to the beginning of the segment. 
% Add any points near pN to the end of the segment.

for ii = 1:length(segments)
    points = segments{ii};
    p1 = points(1,:);
    pN = points(end,:);
    % Add any points near p1 to beginning of segment ii
    nearP1 = isadjacent(p1,points(4:end,:));   %Don't check first 3 points
    if any(nearP1)
        idx = find(nearP1,1)+3;
        points = [points(idx,:); points]; %#ok<*AGROW>
    end
    % Add any points near pN to end of segment ii
    nearPN = isadjacent(pN,points(1:end-3,:)); %Don't check last 3 points
    if any(nearPN)
        idx = find(nearPN,1);
        points = [points; points(idx,:)];
    end
    segments{ii} = points;
end

% This code merges any segments with endpoints that are adjacent. It looks 
% at every pair of segments ii and jj. Take the first and last point of 
% each segment in the pair (four points total), and check whether any are 
% adjacent. If any adjacencies are found, replace the two segments with a 
% single segment describing a continuous path through both segments.

for ii = 1:length(segments)-1
    jj = ii + 1;
    % Check all combinations of 2 segments ii and jj
    while jj <= length(segments)
        points_i = segments{ii};
        points_j = segments{jj};
        pi1 = points_i(1,:);
        piN = points_i(end,:);
        pj1 = points_j(1,:);
        pjN = points_j(end,:);
        % Compare points 1 and N from segments ii and jj
        if isadjacent(pi1,pj1)
            segments{ii} = [flipud(points_j); points_i];
            segments(jj) = [];
        elseif isadjacent(pi1,pjN)
            segments{ii} = [points_j; points_i];
            segments(jj) = [];
        elseif isadjacent(piN,pj1)
            segments{ii} = [points_i; points_j];
            segments(jj) = [];
        elseif isadjacent(piN,pjN)
            segments{ii} = [points_i; flipud(points_j)];
            segments(jj) = [];
        end
        jj = jj + 1;
    end
end

end

% The sub-function isadjacent creates a convenient way to check whether two
% points are adjacent. As a sub-function, it can only be called within the
% connectSegments function.

function tf = isadjacent(p1,p2)
tf = all(abs(p1-p2) <= [1 1],2);
end