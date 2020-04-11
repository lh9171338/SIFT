function gaussPyramid = buildGaussianPyramid(base,param)
%BUILDGAUSSIANPYRAMID - Build Gaussian pyramid.
%
%   base = createInitialImage(image,param)

%% Check argument
narginchk(2,2);
nargoutchk(1,1);

%% Parameters
nOctaves = param.nOctaves;
nOctaveLayers = param.nOctaveLayers;
sigma0 = param.sigma0;
kernelSize = param.kernelSize;

%% Calculate sigma
sigma = zeros(nOctaves,1);
sigma(1) = sigma0;
k = 2^(1 / nOctaveLayers);
for i=2:nOctaveLayers+3
    sigma_prev = (k^(i - 2)) * sigma0;
    sigma_total = sigma_prev * k;
    sigma(i) = sqrt(sigma_total^2 - sigma_prev^2);
end

%% Build Guassian pyramid
gaussPyramid = cell(nOctaves,nOctaveLayers+3);
for o=1:nOctaves
    for l=1:nOctaveLayers+3
        if o == 1  &&  l == 1
            gaussPyramid{o,l} = base;
        % base of new octave is halved image from end of previous octave
        elseif l == 1
            gaussPyramid{o,l} = imresize(gaussPyramid{o-1,nOctaveLayers+1},0.5,'nearest');
        else
            gaussPyramid{o,l} = GaussianBlur(gaussPyramid{o,l-1},kernelSize,sigma(l));
        end
    end
end
