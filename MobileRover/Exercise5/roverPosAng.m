function [x,y,heading] = roverPosAng(IMG,P)
% Copyright 2018 - 2020 The MathWorks, Inc.
% Create a disk object (will be used to clean up the image) and determine the RGB threshold values for the image
delta = 20;
s = strel('disk',3);
threshR = P(1,:) + delta.*[-1 1 1]; 
threshG = P(2,:) + delta.*[1 -1 1];
threshB = P(3,:) + delta.*[1 1 -1];


% Threshold each channel of the image 
Rin = IMG(:,:,1) > threshR(1)  & IMG(:,:,2) < threshR(2) & IMG(:,:,3) < threshR(3);
Gin = IMG(:,:,1) < threshG(1) & IMG(:,:,2) > threshG(2) & IMG(:,:,3) < threshG(3);
Bin = IMG(:,:,1) < threshB(1) & IMG(:,:,2) < threshB(2) & IMG(:,:,3) > threshB(3);

% Remove RGB points that do not have a radius of 3 pixels 
Rf = imopen(Rin,s);
R = imclose(Rf,s);
Gf = imopen(Gin,s);
G = imclose(Gf,s);
Bf = imopen(Bin,s);
B = imclose(Bf,s);

%% Position Calculation (Getting the centroid of the circular plate)

% Get the red centroid
sR = regionprops(R,'centroid');
cR = sR.Centroid;

% Get the green centroid
sG = regionprops(G,'centroid');
cG = sG.Centroid;

% Get the blue centroid
sB = regionprops(B,'centroid');
cB = sB.Centroid;

% Determine where the center of the rover's colored wheel is located
cPlate = (cR + cG + cB)/3;

%% Heading calculation (Getting the orientation of the rover)
% Assumption: The origin of the arena is in the bottom left corner.
% The markers are placed in equilateral triangle. 
% The red marker should correspond to the front of the rover
% The blue marker should correspond to the base of the rover

thetaRC = atand((cPlate(2) - cR(2)) / (cPlate(1) - cR(1)));
thetaFinal = thetaRC;

% Add 180 offset if red marker lies to the left of centre, given the
% conventions noted earlier.
if cR(1) < cPlate(1)
    thetaFinal = thetaFinal + 180 ;
end

thetaFinal = thetaFinal + 180;

% Output the heading and (x,y) coordinates of the rover
x = cPlate(1);
y = cPlate(2);
heading = thetaFinal;
if heading > 360
    heading = heading - 360;
end
