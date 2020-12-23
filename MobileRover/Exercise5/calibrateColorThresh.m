function calibrateColorThresh(IMG)
% Copyright 2018 - 2020 The MathWorks, Inc.
% Get the thresholds for the respective RGB channels in the order R -> G -> B
% The user should select 3 color points by clicking on each colored disk once in a given 
% lighting condition.
% This calibration needs to be performed if the lighting of the arena changes!

% This string will be used to create an annotation with instructions inside
% of the while loop. ValidRGB will be used to control the while loop. 
str = 'Please click on the red circle, followed by the green circle, followed by the blue circle. Press ENTER when complete';
ValidRGB = false;
%% Wait for the user to select the three points in the correct order

while ~ValidRGB
% Create a figure window and an annotation to display the instructions to the user. 
% An invisible axes is used as a guide to place the annotation.
    h = figure;
    ax1 = axes(h, 'Visible', 'off');
    instrBox = annotation('textbox',ax1.Position,'String', str,'FitBoxToText','on', 'BackgroundColor', 'w'); 
    
% Check to see if the circles were selected in the proper order by ensuring
% that the first pixel is the most red, the second pixel is the most green
% and the third pixel is the most blue.
    P = impixel(IMG);
    if P(1,1) < P(2,1) || P(1,1) < P(3,1)
        input('Please pick a red point first. Press ENTER and try again');
        close(h)
    elseif P(2,2) < P(1,2) || P(2,2) < P(3,2)
        input('Please pick a green point second. Press ENTER and try again')
        close(h);
    elseif P(3,3) < P(2,3) || P(3,3) < P(1,3)
        input('Please pick a blue point last. Press ENTER and try again')
        close(h);
    else
        ValidRGB = true;
        close(h);
    end
end
%% Save the results
save('color.mat','P');