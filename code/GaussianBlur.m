function dstImage = GaussianBlur(srcImage,kernelSize,sigma)
%GAUSSIANBLUR - Gaussian blur.
%
%   dstImage = GaussianBlur(srcImage,kernelSize,sigma)

%% Check argument
narginchk(3,3);
nargoutchk(1,1);

%% Get parameters
if kernelSize == 0
    kernelSize = round(sigma * 6 + 1);
    if mod(kernelSize,2) == 0
        kernelSize = kernelSize + 1;
    end
end

%% Gaussian filter
kernel = fspecial('gaussian',kernelSize,sigma);
dstImage = imfilter(srcImage,kernel,'replicate');
