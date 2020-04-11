function image = SIFTMatch(image1,image2)
%SIFTMATCH - Match images based on SIFT.
%
%   image = SIFTMatch(image1,image2)

%% Check argument
narginchk(2,2);
nargoutchk(1,1);

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

%% Save result
image = drawMatches(image1,inlierPoints1,image2,inlierPoints2,goodMatches);
