function segmentsMeters = transformPixelsToMeters(segmentsPix,xLim,yLim,xLimPix,yLimPix,fraction)
% Copyright 2018 - 2020 The MathWorks, Inc.
%
% This function computes the scale factor for converting pixels to meters,
% then converts all the segments in segmentsPix to meters.

% First, create variables to represent the ranges xRange, yRange, xRangePix,
% and yRangePix.

xMinM = xLim(1);
yMinM = yLim(1);
xRangeM = diff(xLim);
yRangeM = diff(yLim);

% Determine the range of the coordinates to draw
xMinPix = xLimPix(1);
yMinPix = yLimPix(1);
xRangePix = diff(xLimPix);
yRangePix = diff(yLimPix);

% Calculate the two possible scale factors. The fraction factor indicates
% what percentage of the available space should be used.

% Scale from pixels to real world units (meters)
xScaleFactor = fraction * xRangeM/xRangePix;
yScaleFactor = fraction * yRangeM/xRangePix;

% Pick the smaller scale factor. If both are NaN, pick 0.
pix2M = min(xScaleFactor,yScaleFactor);
if isnan(pix2M)
    pix2M = 0;
end

% Based on the chosen scaling factor and range values, identify the new 
% origin for the scaled drawing so that the entire drawing will be centered
% at the center of the drawable area.

% Identify the origin of the scaled drawing
centerMeters = [xMinM yMinM] + [xRangeM yRangeM]/2;
drawingOriginM = centerMeters - pix2M*[xRangePix yRangePix]/2;

segmentsMeters = cell(size(segmentsPix));
nSegments = length(segmentsPix);

% Loop through all segments and transform pixel values to meters for all
% coordinates. Subtract the pixel origin, multiply by the scaling factor,
% and add the drawing origin.

for ii = 1:nSegments
    % Scale all segments by the computed scaling factor
    coordsPix = segmentsPix{ii};
    coordsPix = fliplr(coordsPix); %Convert from row,col to x,y
    coordsMeters = pix2M*(coordsPix-[xMinPix yMinPix]) + drawingOriginM;
    segmentsMeters{ii} = coordsMeters;
end

