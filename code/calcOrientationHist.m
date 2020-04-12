function hist = calcOrientationHist(image,pt,radius,sigma,nBins)
%CALCORIENTATIONHIST - Calculate orientation histogram.
%
%   hist = calcOrientationHist(image,pt,radius,sigma,nBins)

%% Check argument
narginchk(5,5);
nargoutchk(1,1);

%% Parameters
expf_scale = -1 / (2 * sigma * sigma);
temphist = zeros(nBins+4,1);
hist = zeros(nBins,1);

%% Calculate orientation histogram
x0 = pt(1);
y0 = pt(2);
[rows,cols] = size(image);
for i=-radius:radius
    y = y0 + i;
    if y <= 1 || y >= rows
        continue;
    end
    for j=-radius:radius
        x = x0 + j;
        if x <= 1 || x >= cols
            continue;
        end
        dx = image(y,x+1) - image(y,x-1);
        dy = image(y+1,x) - image(y-1,x);
        Mag = sqrt(dx^2 + dy^2);
        Ang = atan2(dy,dx) * 180 / pi;
        W = exp((i^2 + j^2) * expf_scale);
        bin = round(Ang / 360 * nBins);
        bin = mod(bin,nBins) + 1;
        temphist(bin+2) = temphist(bin+2) + W * Mag;
    end
end

%% Smooth the histogram
temphist(1) = temphist(nBins+1);
temphist(2) = temphist(nBins+2);
temphist(nBins+3) = temphist(3);
temphist(nBins+4) = temphist(4);
for i=3:nBins+2
    hist(i-2) = (temphist(i-2) + temphist(i+2)) * (1/16)+...
        (temphist(i-1) + temphist(i+1)) * (4/16)+...
        temphist(i) * (6/16);
end
