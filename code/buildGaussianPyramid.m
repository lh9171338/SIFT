function gauss_pyr = buildGaussianPyramid(base,param)

%% get parameter
nOctaves = param.nOctaves;
nOctaveLayers = param.nOctaveLayers;
sigma0 = param.sigma0;

%% calculate sigma
sig = zeros(nOctaves,1);
sig(1) = sigma0;
k = 2^(1/nOctaveLayers);
for i=2:nOctaveLayers+3
    sig_prev = (k^(i-2))*sigma0;
    sig_total = sig_prev*k;
    sig(i) = sqrt(sig_total*sig_total-sig_prev*sig_prev);
end

%% create guassian pyramid
gauss_pyr = cell(nOctaves,nOctaveLayers+3);
for o=1:nOctaves
    for i=1:nOctaveLayers+3
        if o == 1  &&  i == 1
            gauss_pyr{o,i} = base;
        % base of new octave is halved image from end of previous octave
        elseif i == 1
            gauss_pyr{o,i} = imresize(gauss_pyr{o-1,nOctaveLayers+1},0.5,'nearest');
        else
            gauss_pyr{o,i} = GaussianBlur(gauss_pyr{o,i-1},param.width,sig(i));
        end
    end
end

end