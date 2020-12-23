function moveToRadians(theta,pidML,pidMR)
% Copyright 2020 The MathWorks, Inc.

% Define the gear ratio constant.
gearRatio = 100;

% Convert the motor shaft rotations to the actual motor rotations.
thetaL = theta(:,1)*gearRatio;
thetaR = theta(:,2)*gearRatio;

% Implement an nth order delay 'nD' to store the past angular position 
% values.
nD = 3;

% Initializing delay vectors of length 'nD' for storing the past angular 
% position values for both the motors.
thetaDelayL = zeros(nD,1);
thetaDelayR = zeros(nD,1);

% Size of the Input Sequence
N = size(theta,1);

% Set up a For-Loop to drive the motor through a set of angular position
% values consecutively.

for i = 1:N
    
   % Command the motors to move to the target angular position values.
    writeAngularPosition(pidML,thetaL(i),'abs');
    writeAngularPosition(pidMR,thetaR(i),'abs');
    
   % At each iteration step, check if the motor has completed its travel to
   % the set angular position value by comparing its current position 
   % theta(n) with a past value theta(n-nD). If the motor has achieved the
   % target position, then it will stop rotating, and the difference value
   % will be zero. At the next iteration step, move on to the next angular
   % position value and continue until all the points have been traversed.
    
    diffL = abs(readAngularPosition(pidML) - thetaDelayL(1));
    diffR = abs(readAngularPosition(pidMR) - thetaDelayR(1));
    
    j = 1;   
    
    % Use a while loop to keep the motors running until they achieve the
    % target position values.
    
    while ~(diffL==0 && diffR==0)
              
        if j > nD
        
            % The variable 'k' increments from '1' upto 'nD' and then 
            % resets back to 1. This variable helps recall the past 'nD'
            % angular position values to compute the difference value.
            
            k = 1 + mod(j-1,nD);
            
            diffL = abs(readAngularPosition(pidML) - thetaDelayL(k));
            diffR = abs(readAngularPosition(pidMR) - thetaDelayR(k));
            
            % Overwrite the past values with current values once the
            % difference value has been computed.
            
            thetaDelayL(k) = readAngularPosition(pidML);
            thetaDelayR(k) = readAngularPosition(pidMR);
        else
            thetaDelayL(j) = readAngularPosition(pidML);
            thetaDelayR(j) = readAngularPosition(pidMR);
        end
        j = j+1;
    end
    
    % Reset the delay vectors after every iteration step.
    thetaDelayL(:) = 0;
    thetaDelayR(:) = 0;           
end