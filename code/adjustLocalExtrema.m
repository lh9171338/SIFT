  function [iskpt,kpt,layer,r,c] = adjustLocalExtrema(dog_pyr,octv,layer,r,c,param)

%% get parameter
firstOctave = param.firstOctave;
nOctaveLayers = param.nOctaveLayers;
contrastThreshold = param.contrastThreshold;
edgeThreshold = param.edgeThreshold;
sigma0 = param.sigma0;
interp_steps = param.interp_steps;
nborder = param.nborder;

%% variable
img_scale = 1.;
deriv_scale = img_scale*0.5;
second_deriv_scale = img_scale;
cross_deriv_scale = img_scale*0.25;
kpt = [];

%% 3元2次插值
xc = 0;
xr = 0;
xi = 0;
i = 1;
for i=1:interp_steps
    img = dog_pyr{octv,layer};
    prev = dog_pyr{octv,layer-1};
    next = dog_pyr{octv,layer+1};
    [rows,cols] = size(img);
    dD = [(img(r,c+1)-img(r,c-1))*deriv_scale;
          (img(r+1,c)-img(r-1,c))*deriv_scale;
          (next(r,c) - prev(r,c))*deriv_scale];
    v2 = img(r,c)*2;
    dxx = (img(r,c+1)+img(r,c-1)-v2)*second_deriv_scale;
    dyy = (img(r+1,c)+img(r-1,c)-v2)*second_deriv_scale;
    dss = (next(r,c)+prev(r,c)-v2)*second_deriv_scale;
    dxy = (img(r+1,c+1)-img(r+1,c-1)-img(r-1,c+1)+img(r-1,c-1))*cross_deriv_scale;
    dxs = (next(r,c+1)-next(r,c-1)-prev(r,c+1)+prev(r,c-1))*cross_deriv_scale;
    dys = (next(r+1,c)-next(r-1,c)-prev(r+1,c)+prev(r-1,c))*cross_deriv_scale;
    H = [dxx,dxy,dxs;dxy,dyy,dys;dxs,dys,dss];
%     if det(H) == 0
%         iskpt = false;
%         return;
%     end
%     X = -H\dD;
    [res,X] = solve3x3(-H,dD);
     if ~res
        iskpt = false;
        return;
     end   

    xc = X(1);
    xr = X(2);
    xi = X(3);
    if abs(xi) < 0.5 && abs(xr) < 0.5 && abs(xc) < 0.5
        break;
    end
    if abs(xi) > intmax/3 || abs(xr) > intmax/3 || abs(xc) > intmax/3
        iskpt = false;
        return;
    end
    c = c+round(xc);
    r = r+round(xr);
    layer = layer+round(xi);
    if layer < 2 || layer > nOctaveLayers+1 ||...
        c < nborder || c > cols-nborder+1  ||...
        r < nborder || r > rows-nborder+1
        iskpt = false;
        return;
    end
end

% ensure convergence of interpolation
if i > interp_steps
    iskpt = false;
    return;
end

%% 去除低对比度的点
img = dog_pyr{octv,layer};
prev = dog_pyr{octv,layer-1};
next = dog_pyr{octv,layer+1};
dD = [(img(r, c+1)-img(r,c-1))*deriv_scale;
      (img(r+1,c)-img(r-1,c))*deriv_scale;
      (next(r, c) - prev(r, c))*deriv_scale];
X = [xc,xr,xi];
t = 0.5*X*dD;
contr = img(r,c)*img_scale+t;
if abs(contr)*nOctaveLayers < contrastThreshold
    iskpt = false;
    return;
end

%% principal curvatures are computed using the trace and det of Hessian
v2 = img(r,c)*2;
dxx = (img(r,c+1)+img(r,c-1)-v2)*second_deriv_scale;
dyy = (img(r+1,c)+img(r-1,c)-v2)*second_deriv_scale;
dxy = (img(r+1,c+1)-img(r+1,c-1)-img(r-1,c+1)+img(r-1,c-1))*cross_deriv_scale;
tr = dxx+dyy;
delta = dxx*dyy-dxy*dxy;
if delta <= 0 || tr*tr*edgeThreshold >= (edgeThreshold+1)*(edgeThreshold+1)*delta
    iskpt = false;
    return;
end

%% 保存结果
iskpt = true;
scale = 2^(octv-1+firstOctave);
kpt.pt(1) = round((c+xc)*scale);
kpt.pt(2) = round((r+xr)*scale);
kpt.octave = octv;
kpt.layer = layer;
kpt.sigma = sigma0*(2^((layer+xi)/nOctaveLayers));
kpt.response = abs(contr);

end
