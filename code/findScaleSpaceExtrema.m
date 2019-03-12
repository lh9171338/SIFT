function keypoints = findScaleSpaceExtrema(gauss_pyr,dog_pyr,param)

%% get parameter
nOctaves = param.nOctaves;
nOctaveLayers = param.nOctaveLayers;
contrastThreshold = param.contrastThreshold;
n = param.nbins;
nborder = param.nborder;
ori_peak_ratio = param.ori_peak_ratio;

%% find scale spcae extrema points
threshold = floor(0.5*contrastThreshold/nOctaveLayers*255);
keypoints = [];
num = 0;
for o=1:nOctaves
    for i=2:nOctaveLayers+1
        img = dog_pyr{o,i};
        prev = dog_pyr{o,i-1};
        next = dog_pyr{o,i+1};
        [rows,cols] = size(img);
        for r=nborder:rows-nborder+1
            for c=nborder:cols-nborder+1
                val = img(r,c);
                if abs(val) > threshold &&...
                ((val > 0 && val >= img(r,c-1) && val >= img(r,c+1) &&...
                val >= img(r-1,c-1) && val >= img(r-1,c) && val >= img(r-1,c+1) &&...
                val >= img(r+1,c-1) && val >= img(r+1,c) && val >= img(r+1,c+1) &&...
                val >= next(r,c-1) && val >= next(r,c) && val >= next(r,c+1) &&...
                val >= next(r-1,c-1) && val >= next(r-1,c) && val >= next(r-1,c+1) &&...
                val >= next(r+1,c-1) && val >= next(r+1,c) && val >= next(r+1,c+1) &&...
                val >= prev(r,c-1) && val >= prev(r,c) && val >= prev(r,c+1) &&...
                val >= prev(r-1,c-1) && val >= prev(r-1,c) && val >= prev(r-1,c+1) &&...
                val >= prev(r+1,c-1) && val >= prev(r+1,c) && val >= prev(r+1,c+1)) ||...
                (val < 0 && val <= img(r,c-1) && val <= img(r,c+1) &&...
                val <= img(r-1,c-1) && val <= img(r-1,c) && val <= img(r-1,c+1) &&...
                val <= img(r+1,c-1) && val <= img(r+1,c) && val <= img(r+1,c+1) &&...
                val <= next(r,c-1) && val <= next(r,c) && val <= next(r,c+1) &&...
                val <= next(r-1,c-1) && val <= next(r-1,c) && val <= next(r-1,c+1) &&...
                val <= next(r+1,c-1) && val <= next(r+1,c) && val <= next(r+1,c+1) &&...
                val <= prev(r,c-1) && val <= prev(r,c) && val <= prev(r,c+1) &&...
                val <= prev(r-1,c-1) && val <= prev(r-1,c) && val <= prev(r-1,c+1) &&...
                val <= prev(r+1,c-1) && val <= prev(r+1,c) && val <= prev(r+1,c+1)))
                    num = num+1;
                    %去除不稳定的关键点
                    [iskpt,kpt,layer,r1,c1] = adjustLocalExtrema(dog_pyr,o,i,r,c,param);
                    if ~iskpt
                        continue;
                    end
                    %计算关键点的梯度
                    sigma = 1.5*kpt.sigma;
                    radius = round(3*sigma);
                    hist = calcOrientationHist(double(gauss_pyr{o,layer}),[c1,r1],radius,sigma,n);
                    omax = max(hist);
                    mag_thr = omax*ori_peak_ratio;
                    for j=1:n
                         left = mod(j-2,n)+1;
                         right = mod(j,n)+1;
                         if  hist(j) > hist(left)  &&  hist(j) > hist(right)  &&  hist(j) >= mag_thr
                                bin = j-0.5*(hist(right)-hist(left))/(hist(right)+hist(left)-2*hist(j));
                                bin = mod(bin-1,n);
                                kpt.angle = 360/n*bin;
                                keypoints = cat(1,keypoints,kpt);
                         end
                    end
                end
            end
        end
    end
end



end