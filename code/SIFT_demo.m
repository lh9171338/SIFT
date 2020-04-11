% SIFT_demo.m
%%
clc,clear;
close all;

%% Parameters
folder = '../image/book';
srcFilename1 = [folder,'/image1.jpg'];
srcFilename2 = [folder,'/image2.jpg'];
dstFilename = [folder,'/result.jpg'];
saveFlag = false;

%% Read images
image1 = imread(srcFilename1);
image2 = imread(srcFilename2);
if size(image1,2) > 800
    image1 = imresize(image1,800/size(image1,2));
end
if size(image2,2) > 800
    image2 = imresize(image2,800/size(image2,2));
end

%% Detect keypoints and compute descriptors
param1 = getDefaultParam(image1);
param2 = getDefaultParam(image2);
param1.orientRange = 180;param1.orientExtend = false;
param2.orientRange = 180;param2.orientExtend = true;
[keypoints1,descriptors1] = detectAndCompute(image1,param1);
[keypoints2,descriptors2] = detectAndCompute(image2,param2);
        
%% Match
matches = match(descriptors1,descriptors2);
keypoints1 = vertcat(keypoints1.pt);
keypoints2 = vertcat(keypoints2.pt);
matchedPoints1 = keypoints1(matches(:,1),:);
matchedPoints2 = keypoints2(matches(:,2),:);
[tform,inlierPoints1,inlierPoints2,status] = estimateGeometricTransform(matchedPoints1,matchedPoints2,...
    'similarity','Confidence',99,'MaxDistance',3);
scale = norm(tform.T(1:2,1:2));
numInliers = size(inlierPoints1,1);
goodMatches = [1:numInliers;1:numInliers]';
disp(['numInliers = ',num2str(numInliers),' scale = ', num2str(scale)]);

%% Save result
% drawKeypoints(image1,inlierPoints1);
% drawKeypoints(image2,inlierPoints2);
image = drawMatches(image1,inlierPoints1,image2,inlierPoints2,goodMatches,true);
if saveFlag
    imwrite(image,dstFilename);
end


