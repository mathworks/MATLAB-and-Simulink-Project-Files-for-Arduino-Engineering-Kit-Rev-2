function undistortImage = im2orthoview(im, tform, outputView, outputSize)
% Copyright 2018 - 2020 The MathWorks, Inc.
    % Warp and resize the image to return the orthogonal view
    undistortImage = imwarp(im,tform,'OutputView',outputView);
    undistortImage = imresize(undistortImage, outputSize);
end