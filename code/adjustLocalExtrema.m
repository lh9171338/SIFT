function [kpt,layer,r,c] = adjustLocalExtrema(dogPyramid,octave,layer,r,c,param)
%ADJUSTLOCALEXTREMA - Adjust local extrema point.
%
%   [kpt,layer,r,c] = adjustLocalExtrema(dogPyramid,octave,layer,r,c,param)

%% Check argument
narginchk(6,6);
nargoutchk(4,4);

%% Parameters
firstOctave = param.firstOctave;
nOctaveLayers = param.nOctaveLayers;
contrastThreshold = param.contrastThreshold;
edgeThreshold = param.edgeThreshold;
sigma0 = param.sigma0;
interpSteps = param.interpSteps;
nBorder = param.nBorder;

image_scale = 1.0;
derivative_scale = image_scale * 0.5;
second_derivative_scale = image_scale;
cross_derivative_scale = image_scale * 0.25;

%% Interpolation
kpt = [];
convergenceFlag = false;
xc = 0;
xr = 0;
xl = 0;
for i=1:interpSteps
    image = dogPyramid{octave,layer};
    prev = dogPyramid{octave,layer-1};
    next = dogPyramid{octave,layer+1};
    [rows,cols] = size(image);
    dD = [(image(r,c+1) - image(r,c-1)) * derivative_scale;
          (image(r+1,c) - image(r-1,c)) * derivative_scale;
          (next(r,c) - prev(r,c)) * derivative_scale];
    v2 = image(r,c) * 2;
    dxx = (image(r,c+1) + image(r,c-1) - v2) * second_derivative_scale;
    dyy = (image(r+1,c) + image(r-1,c) - v2) * second_derivative_scale;
    dss = (next(r,c) + prev(r,c) - v2) * second_derivative_scale;
    dxy = (image(r+1,c+1) - image(r+1,c-1) - image(r-1,c+1) + image(r-1,c-1)) * cross_derivative_scale;
    dxs = (next(r,c+1) - next(r,c-1) - prev(r,c+1) + prev(r,c-1)) * cross_derivative_scale;
    dys = (next(r+1,c) - next(r-1,c) - prev(r+1,c) + prev(r-1,c)) * cross_derivative_scale;
    H = [dxx,dxy,dxs;dxy,dyy,dys;dxs,dys,dss];
    if det(H) == 0
        return;
    end
    X = -H \ dD; 
    xc = X(1);
    xr = X(2);
    xl = X(3);
    if abs(xl) < 0.5 && abs(xr) < 0.5 && abs(xc) < 0.5
        convergenceFlag = true;
        break;
    end
    if abs(xl) > intmax / 3 || abs(xr) > intmax / 3 || abs(xc) > intmax / 3
        return;
    end
    c = c + round(xc);
    r = r + round(xr);
    layer = layer + round(xl);
    if layer < 2 || layer > nOctaveLayers+1 ||...
        c < nBorder || c > cols-nBorder+1  ||...
        r < nBorder || r > rows-nBorder+1
        return;
    end
end
if ~convergenceFlag
    return;
end

%% Remove low contrast point
image = dogPyramid{octave,layer};
prev = dogPyramid{octave,layer-1};
next = dogPyramid{octave,layer+1};
dD = [(image(r, c+1) - image(r,c-1)) * derivative_scale;
      (image(r+1,c) - image(r-1,c)) * derivative_scale;
      (next(r, c) - prev(r, c)) * derivative_scale];
X = [xc,xr,xl];
t = 0.5 * X * dD;
contrast = image(r,c) * image_scale + t;
if abs(contrast) * nOctaveLayers < contrastThreshold
    return;
end

%% Principal curvatures are computed using the trace and det of Hessian
v2 = image(r,c) * 2;
dxx = (image(r,c+1) + image(r,c-1) - v2) * second_derivative_scale;
dyy = (image(r+1,c) + image(r-1,c) - v2) * second_derivative_scale;
dxy = (image(r+1,c+1) - image(r+1,c-1) - image(r-1,c+1) + image(r-1,c-1)) * cross_derivative_scale;
tr = dxx + dyy;
delta = dxx * dyy - dxy * dxy;
if delta <= 0 || tr * tr * edgeThreshold >= (edgeThreshold + 1) * (edgeThreshold + 1) * delta
    return;
end

%% Save result
scale = 2^(octave - 1 + firstOctave);
kpt.pt(1) = round((c + xc) * scale);
kpt.pt(2) = round((r + xr) * scale);
kpt.octave = octave;
kpt.layer = layer;
kpt.sigma = sigma0 * (2^((layer + xl) / nOctaveLayers));
kpt.response = abs(contrast);
