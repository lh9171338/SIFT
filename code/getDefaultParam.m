function param = getDefaultParam(image)
%%GETDEFAULTPARAM - Get default parameters of SIFT.
%
%   param = getDefaultParam(image)

%% Check argument
narginchk(1,1);
nargoutchk(1,1);

%% SIFT parameters
[rows,cols,~] = size(image);
param.orientRange = 360;        % {180,360}
param.orientExtend = false;     
param.firstOctave = 0;          % {-1,0}
param.nFeatures = 1000;
param.nOctaves = round(log2(min(rows,cols)))-4-param.firstOctave;
param.nOctaveLayers = 3;
param.sigma0 = 1.6;
param.initSigma = 0;
param.kernelSize = 15;
param.contrastThreshold = 0.04;
param.edgeThreshold = 10;
param.interpSteps = 5;  
param.orientPeakRatio = 0.8;
param.nBins = 36;
param.nBorder = 6;
param.descriptorSize = [4,4,8];
