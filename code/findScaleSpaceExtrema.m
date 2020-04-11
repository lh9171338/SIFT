function keypoints = findScaleSpaceExtrema(gaussPyramid,dogPyramid,param)
%FINDSCALESPACEEXTREMA - Find scale space extrema points.
%
%   keypoints = findScaleSpaceExtrema(gaussPyramid,dogPyramid,param)

%% Check argument
narginchk(3,3);
nargoutchk(1,1);

%% Parameters
orientRange = param.orientRange;
nOctaves = param.nOctaves;
nOctaveLayers = param.nOctaveLayers;
contrastThreshold = param.contrastThreshold;
nBins = param.nBins;
nBorder = param.nBorder;
orientPeakRatio = param.orientPeakRatio;

%% Find scale spcae extrema points
threshold = floor(0.5 * contrastThreshold / nOctaveLayers * 255);
keypoints = [];
for o=1:nOctaves
    for l=2:nOctaveLayers+1
        image = dogPyramid{o,l};
        prev = dogPyramid{o,l-1};
        next = dogPyramid{o,l+1};
        [rows,cols] = size(image);
        for r=nBorder:rows-nBorder+1
            for c=nBorder:cols-nBorder+1
                val = image(r,c);
                if abs(val) > threshold &&...
                ((val > 0 && val >= image(r,c-1) && val >= image(r,c+1) &&...
                val >= image(r-1,c-1) && val >= image(r-1,c) && val >= image(r-1,c+1) &&...
                val >= image(r+1,c-1) && val >= image(r+1,c) && val >= image(r+1,c+1) &&...
                val >= next(r,c-1) && val >= next(r,c) && val >= next(r,c+1) &&...
                val >= next(r-1,c-1) && val >= next(r-1,c) && val >= next(r-1,c+1) &&...
                val >= next(r+1,c-1) && val >= next(r+1,c) && val >= next(r+1,c+1) &&...
                val >= prev(r,c-1) && val >= prev(r,c) && val >= prev(r,c+1) &&...
                val >= prev(r-1,c-1) && val >= prev(r-1,c) && val >= prev(r-1,c+1) &&...
                val >= prev(r+1,c-1) && val >= prev(r+1,c) && val >= prev(r+1,c+1)) ||...
                (val < 0 && val <= image(r,c-1) && val <= image(r,c+1) &&...
                val <= image(r-1,c-1) && val <= image(r-1,c) && val <= image(r-1,c+1) &&...
                val <= image(r+1,c-1) && val <= image(r+1,c) && val <= image(r+1,c+1) &&...
                val <= next(r,c-1) && val <= next(r,c) && val <= next(r,c+1) &&...
                val <= next(r-1,c-1) && val <= next(r-1,c) && val <= next(r-1,c+1) &&...
                val <= next(r+1,c-1) && val <= next(r+1,c) && val <= next(r+1,c+1) &&...
                val <= prev(r,c-1) && val <= prev(r,c) && val <= prev(r,c+1) &&...
                val <= prev(r-1,c-1) && val <= prev(r-1,c) && val <= prev(r-1,c+1) &&...
                val <= prev(r+1,c-1) && val <= prev(r+1,c) && val <= prev(r+1,c+1)))
                    %% Remove unstable points
                    [kpt,layer,r1,c1] = adjustLocalExtrema(dogPyramid,o,l,r,c,param);
                    if isempty(kpt)
                        continue;
                    end
                    %% Compute gradient of keypoints
                    sigma = 1.5 * kpt.sigma;
                    radius = round(3 * sigma);
                    hist = calcOrientationHist(gaussPyramid{o,layer},[c1,r1],radius,sigma,nBins);
                    maxOrient= max(hist);
                    orientThreshold = maxOrient * orientPeakRatio;
                    for j=1:nBins
                         left = mod(j-2,nBins)+1;
                         right = mod(j,nBins)+1;
                         if  hist(j) > hist(left)  &&  hist(j) > hist(right)  &&  hist(j) >= orientThreshold
                                bin = j - 0.5 * (hist(right) - hist(left)) / ...
                                    (hist(right) + hist(left) - 2 * hist(j));
                                bin = mod(bin-1,nBins);
                                angle = bin * 360 / nBins;
                                kpt.angle = mod(angle,orientRange);
                                keypoints = cat(1,keypoints,kpt);
                         end
                    end
                end
            end
        end
    end
end
