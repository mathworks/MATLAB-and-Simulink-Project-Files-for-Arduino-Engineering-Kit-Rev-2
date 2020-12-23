function drawImageFromPix(segmentsPix,xLimPix,yLimPix,Z_i)
% Copyright 2018 - 2020 The MathWorks, Inc.

nSegments = length(segmentsPix);

% Define whiteboard limits
load WhiteboardLimits.mat xLim yLim

% Convert pixel coordinates to physical distances and then to encoder counts
fraction = 0.7;
segmentsMeters = transformPixelsToMeters(segmentsPix,xLim,yLim,xLimPix,yLimPix,fraction);

% Reduce size of each segment
radius = 0.002; %Max distance between points to draw (meters)
for ii = 1:length(segmentsMeters)
    segmentsMeters{ii} = reduceSegment(segmentsMeters{ii},radius);
end

load RobotGeometry.mat Base
segmentsTheta = cell(size(segmentsMeters));
for ii = 1:nSegments
    segmentsTheta{ii} = xyToRadians(segmentsMeters{ii},Z_i,Base);
end

%% Connect to hardware
a = arduino;
carrier = motorCarrier(a);
s = servo(carrier,3);
pidML = pidMotor(carrier,2,'position',3,[0.18 0.0 0.01]); % Modify the PID gains [Kp Ki Kd] as per your requirements
pidMR = pidMotor(carrier,1,'position',3,[0.18 0.0 0.01]); % Modify the PID gains [Kp Ki Kd] as per your requirements

%% Define up and down positions for servo motor
load ServoPositions.mat LeftMarker NoMarker
%% Draw image on whiteboard
writePosition(s,NoMarker)
for ii = 1:nSegments
    % Get theta for current segment
   thetaList = segmentsTheta{ii};
    % Move to first position and lower marker
    moveToRadians(thetaList(1,:),pidML,pidMR)
    writePosition(s,LeftMarker)
    % Move to all positions of current segment
    moveToRadians(thetaList,pidML,pidMR)
    % Raise marker
    writePosition(s,NoMarker)
end
