function descriptors = calcDescriptors(gauss_pyr,keypoints,param)

%% get parameter
firstOctave = param.firstOctave;
d = param.d;
n = param.n;

%% calculate descriptors
num = numel(keypoints);
descriptors = zeros(num,d*d*n);
for i=1:num
    kpt = keypoints(i);
    octave = kpt.octave;
    layer = kpt.layer;
    sigma = kpt.sigma;
    scale = 2^(octave-1+firstOctave);
    pt = round(kpt.pt/scale);
    angle = kpt.angle;
    img = gauss_pyr{octave,layer};
    descriptors(i,:) = calcSIFTDescriptor(double(img),pt,angle,sigma,d,n);
end

end