function keypoints = removeDuplicated(keypoints)
%REMOVEDUPLICATED - Remove duplicated keypoints.
%
%   keypoints = removeDuplicated(keypoints)

%% Check argument
narginchk(1,1);
nargoutchk(1,1);

%% Remove duplicated keypoints
nPoints = numel(keypoints);
mask = true(nPoints,1);     
for i=1:nPoints-1
    kpt1 = keypoints(i);
    for j=i+1:nPoints
        kpt2 = keypoints(j);
        if  kpt1.pt(1) == kpt2.pt(1) && kpt1.pt(2) == kpt2.pt(2) &&...
            kpt1.sigma == kpt2.sigma && kpt1.angle == kpt2.angle 
            mask(j) = false;
        end
    end
end
keypoints = keypoints(mask);
