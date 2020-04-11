function descriptor = calcSIFTDescriptor(image,pt,angle,sigma,orientRange,descriptorSize)
%CALCDSIFTESCRIPTOR - Calculate SIFT descriptor.
%
%   descriptor = calcSIFTDescriptor(image,pt,angle,sigma,orientRange,descriptorSize)

%% Check argument
narginchk(6,6);
nargoutchk(1,1);

%% Parameters
d = descriptorSize(1);
n = descriptorSize(3);
histSize = 3 * sigma;
radius = round(histSize * sqrt(2) * (d+1) * 0.5);
exp_scale = -1 / (d * d * 0.5);
[rows,cols] = size(image);
radius = min(radius,round(sqrt(rows^2 + cols^2) / 2)); 
hist = zeros(d+2,d+2,n+1);
cos_t = cos(-angle * pi / 180) / histSize;
sin_t = sin(-angle * pi / 180) / histSize;
 
%% Calculate SIFT descriptor
x0 = pt(1);
y0 = pt(2);
for i=-radius:radius
    for j=-radius:radius
        c_rot = j * cos_t - i * sin_t;
        r_rot = j * sin_t + i * cos_t;
        rbin = r_rot + d / 2 - 0.5;
        cbin = c_rot + d / 2 - 0.5; 
        r = y0 + i;
        c = x0 + j;
        if rbin > -1 && rbin < d && cbin > -1 && cbin < d &&...
                r > 1 && r < rows  && c > 1 && c < cols
            dx = image(r,c+1) - image(r,c-1);
            dy = image(r+1,c) - image(r-1,c);
            W = exp((c_rot^2 + r_rot^2) * exp_scale);
            Mag = sqrt(dx^2 + dy^2);
            Mag = Mag * W;
            Ang = atan2(dy,dx) * 180 / pi;
            Ang = mod(Ang,orientRange);
            rbin = rbin + 2; 
            cbin = cbin + 2;
            obin = (Ang - angle) / orientRange * n;
            obin = mod(obin,n) + 1; 
            r0 = floor(rbin); 
            c0 = floor(cbin); 
            o0 = floor(obin);
            rbin = rbin - r0;
            cbin = cbin - c0;
            obin = obin - o0; 
            %% Tri-linear interpolation
            v_r1 = Mag * rbin;
            v_r0 = Mag - v_r1;	
            v_rc11 = v_r1 * cbin;v_rc10 = v_r1 - v_rc11;
            v_rc01 = v_r0 * cbin;v_rc00 = v_r0 - v_rc01;
            v_rco111 = v_rc11 * obin;v_rco110 = v_rc11 - v_rco111;
            v_rco101 = v_rc10 * obin;v_rco100 = v_rc10 - v_rco101;
            v_rco011 = v_rc01 * obin;v_rco010 = v_rc01 - v_rco011;
            v_rco001 = v_rc00 * obin;v_rco000 = v_rc00 - v_rco001;
            hist(r0,c0,o0) = hist(r0,c0,o0) + v_rco000;
            hist(r0,c0,o0+1) = hist(r0,c0,o0+1) + v_rco001;
            hist(r0,c0+1,o0) = hist(r0,c0+1,o0) + v_rco010;
            hist(r0,c0+1,o0+1) = hist(r0,c0+1,o0+1) + v_rco011;
            hist(r0+1,c0,o0) = hist(r0+1,c0,o0) + v_rco100;
            hist(r0+1,c0,o0+1) = hist(r0+1,c0,o0+1) + v_rco101;
            hist(r0+1,c0+1,o0) = hist(r0+1,c0+1,o0) + v_rco110;
            hist(r0+1,c0+1,o0+1) = hist(r0+1,c0+1,o0+1) + v_rco111;
        end
    end
end

%% Finalize histogram, since the orientation histograms are circular
hist(:,:,1) = hist(:,:,1) + hist(:,:,n+1);
descriptor = permute(hist(2:d+1,2:d+1,1:n),[3,2,1]);
descriptor = descriptor(:)';

%% Normalize
descriptor = descriptor / norm(descriptor);
descriptor = uint8(descriptor * 255);
