function descriptors = calcDescriptors(gaussPyramid,keypoints,param)
%CALCDESCRIPTORS - Calculate descriptors.
%
%   descriptors = calcDescriptors(gaussPyramid,keypoints,param)

%% Check argument
narginchk(3,3);
nargoutchk(1,1);

%% Parameters
orientRange = param.orientRange;
firstOctave = param.firstOctave;
descriptorSize = param.descriptorSize;
dim = prod(descriptorSize);

%% Calculate descriptors
nPoints = numel(keypoints);
descriptors = zeros(nPoints,dim);
for i=1:nPoints
    kpt = keypoints(i);
    octave = kpt.octave;
    layer = kpt.layer;
    sigma = kpt.sigma;
    scale = 2^(octave - 1 + firstOctave);
    pt = round(kpt.pt / scale);
    angle = kpt.angle;
    image = gaussPyramid{octave,layer};
    descriptors(i,:) = calcSIFTDescriptor(image,pt,angle,sigma,orientRange,descriptorSize);
end
