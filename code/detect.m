function [keypoints,descriptors] = detect(img)

%% SIFT parameters
param.firstOctave = 0;
param.nfeatures = 0;
param.nOctaves = 0;
param.nOctaveLayers = 3;
param.sigma0 = 1.6;
param.initsigma = 0;
param.width = 15;
param.contrastThreshold = 0.04;
param.edgeThreshold = 10;
param.interp_steps = 5;  
param.ori_peak_ratio = 0.8;
param.nbins = 36;
param.nborder = 6;
param.d = 4;
param.n = 8;

%% create the gaussian pyramid and DOG pyramid
[rows,cols] = size(img);
base = createInitialImage(img,param);
param.nOctaves = round(log2(min(rows,cols)))-4-param.firstOctave;
gauss_pyr = buildGaussianPyramid(base,param);
dog_pyr = buildDoGPyramid(gauss_pyr,param);

%% find scale spcae extrema points
keypoints = findScaleSpaceExtrema(gauss_pyr,dog_pyr,param);
% keypoints = removeDuplicated(keypoints);
% if param.nfeatures > 0 
%     keypoints = retainBest(keypoints,param.nfeatures);
% end
        
%% calcualte descriptors
descriptors = calcDescriptors(gauss_pyr,keypoints,param);

end
