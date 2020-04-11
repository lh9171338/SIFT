function dogPyramid = buildDoGPyramid(gaussPyramid,param)
%BUILDDOGPYRAMID - Build DoG pyramid.
%
%   dogPyramid = buildDoGPyramid(gaussPyramid,param)

%% Check argument
narginchk(2,2);
nargoutchk(1,1);

%% Parameters
nOctaves = param.nOctaves;
nOctaveLayers = param.nOctaveLayers;

%% Build difference of Guassian pyramid
dogPyramid = cell(nOctaves,nOctaveLayers+2);
for o=1:nOctaves
    for l=1:nOctaveLayers+2
        dogPyramid{o,l} = gaussPyramid{o,l+1}-gaussPyramid{o,l};
    end
end
