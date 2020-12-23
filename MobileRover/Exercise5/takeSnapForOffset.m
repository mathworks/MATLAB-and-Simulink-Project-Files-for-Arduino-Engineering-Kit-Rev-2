function [picOut, reTakeImage] = takeSnapForOffset(cam,objectType,desiredEdge)
% Copyright 2018 - 2020 The MathWorks, Inc.
%% This function helps display the instructions for taking a snapshot of the target/rover on the four edges of the arena
    %% Construct and display the string for the snapshot prompt
    outStr = sprintf('Please take a snapshot with the %s on the %s edge of the arena. Press ENTER when ready.\n', objectType, desiredEdge);
    input(outStr);
    
    %% Take a snapshot and display it to the user
    picOut = snapshot(cam);
    h=figure;
    imshow(picOut);
    set(gcf,'Visible','on')
    
    %% Ask the user if they want to take the picture again
    reTakeImage = input('Do you want to take the image again? Please enter "0" for no or "1" for yes\n');
    set(gcf,'Visible','off')
    close(h)
    clc
end