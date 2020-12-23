function [x_cm,y_cm] = getLocation(CenterX, CenterY, newCorners, horzOffsetRange, verticalOffsetRange, arenaHeight, cmsPerPx)
% Copyright 2018 - 2020 The MathWorks, Inc.
%% Determine the horizontal and vertical limits of the arena 

botY = max(newCorners(:,2));
topY = min(newCorners(:,2));

leftX  = min(newCorners(:,1));
rightX = max(newCorners(:,1));
%% Calculate the location offset value

offsetY = verticalOffsetRange(1) + ((verticalOffsetRange(2)-verticalOffsetRange(1))/(botY-topY))*(botY - CenterY);
offsetX = horzOffsetRange(2) + ((horzOffsetRange(1)-horzOffsetRange(2))/(rightX-leftX))*(CenterX - leftX);

%% Determine the (x,y) coordinates that incorporate the location offsets

x = CenterX + offsetX;
y = CenterY + offsetY;

%% Return the (x,y) coordinates in cm's that incorporate the location offsets

x_cm = (x - min(newCorners(:,1)))*cmsPerPx(1);
y_cm = arenaHeight - (y - min(newCorners(:,2)))*cmsPerPx(2);
