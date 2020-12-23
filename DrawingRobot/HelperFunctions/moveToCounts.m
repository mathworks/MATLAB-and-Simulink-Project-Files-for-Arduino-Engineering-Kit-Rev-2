function moveToCounts(counts,mL,mR,eL,eR)
% Copyright 2018 - 2020 The MathWorks, Inc.
wRef = 20;      %rpm
hitRadius = 20; %counts

start(mL)
start(mR)

% Loop through all points
nPoints = size(counts,1);
for ii = 1:nPoints
    % Determine destination point
    countTarget = counts(ii,:);

    % Loop until at destination
    while true
        % Update count measurement
        countNew = [readCount(eL) readCount(eR)];
        
        % Check distance to final position and break if close enough
        countRemain = countTarget - countNew;
        countNorm = sqrt(sum((countRemain).^2));
        if countNorm <= hitRadius
            break
        end
        
        % Compute and set target angular speed for each motor
        wSet = (countRemain/countNorm)*wRef;
        stop(mL),start(mL),setSpeed(mL,round(wSet(1)));
        stop(mR),start(mR),setSpeed(mR,round(wSet(2)));
        
    end
end

stop(mL)
stop(mR)

end
