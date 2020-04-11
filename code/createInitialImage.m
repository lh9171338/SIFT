function base = createInitialImage(image,param)
%CREATEINITIALIMAGE - Create initial image by Gaussian filter.
%
%   base = createInitialImage(image,param)

%% Check argument
narginchk(2,2);
nargoutchk(1,1);

%% Parameters
firstOctave = param.firstOctave;
sigma0 = param.sigma0;
initSigma = param.initSigma;
kernelSize = param.kernelSize;

%% Gaussian filtering
image = double(image);
if firstOctave < 0
    image = imresize(image,2);
    sigma = sqrt(sigma0^2 - 4 * initSigma^2);
    sigma = max(sigma,0.1);
    base = GaussianBlur(image,kernelSize,sigma);
else
    sigma = sqrt(sigma0^2 - initSigma^2);
    sigma = max(sigma,0.1);
    base = GaussianBlur(image,kernelSize,sigma);
end
