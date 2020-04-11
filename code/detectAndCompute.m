function [keypoints,descriptors] = detectAndCompute(image,param)
%DETECTANDCOMPUTE - Detect keypoints and compute descriptors.
%
%   [keypoints,descriptors] = detectAndCompute(image,param)

%% Check argument
narginchk(1,2);
nargoutchk(2,2);

%% SIFT parameters
if nargin < 2
    param = getDefaultParam(image);
end

%% Create Gaussian pyramid and DOG pyramid
if size(image,3) == 3
    image = rgb2gray(image);
end
base = createInitialImage(image,param);
gaussPyramid = buildGaussianPyramid(base,param);
dogPyramid = buildDoGPyramid(gaussPyramid,param);

%% Find scale spcae extrema points
keypoints = findScaleSpaceExtrema(gaussPyramid,dogPyramid,param);
% keypoints = removeDuplicated(keypoints);
if param.nFeatures > 0 
    keypoints = retainBest(keypoints,param.nFeatures);
end
        
%% Compute descriptors
if param.orientRange == 180 && param.orientExtend
    nPoints = numel(keypoints);
    for i=1:nPoints
        keypoints(i+nPoints) = keypoints(i);
        keypoints(i+nPoints).angle = keypoints(i+nPoints).angle + 180;
    end
end
descriptors = calcDescriptors(gaussPyramid,keypoints,param);
