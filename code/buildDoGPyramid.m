function dog_pyr = buildDoGPyramid(gauss_pyr,param)

%% get parameter
nOctaves = param.nOctaves;
nOctaveLayers = param.nOctaveLayers;

%% create difference of guassian pyramid
dog_pyr = cell(nOctaves,nOctaveLayers+2);
for o=1:nOctaves
    for i=1:nOctaveLayers+2
        dog_pyr{o,i} = gauss_pyr{o,i+1}-gauss_pyr{o,i};
    end
end

end