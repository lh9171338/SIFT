function keypoints = retainBest(keypoints,nPoints)
%RETAINBEST - Retain the best keypoints.
%
%   keypoints = retainBest(keypoints,nPoints)

%% Check argument
narginchk(2,2);
nargoutchk(1,1);

%% Sort
if nPoints >= numel(keypoints)
    return;
end
responses = vertcat(keypoints.response);
[~,indexes] = sort(responses,'descend');
keypoints = keypoints(indexes(1:nPoints));
