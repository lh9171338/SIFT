function descriptor = calcSIFTDescriptor(img,pt,angle,sigma,d,n)

hist_width = 3*sigma;
radius = round(hist_width*sqrt(2)*(d+1)*0.5);
cos_t = cos(-angle*pi/180)/hist_width;
sin_t = sin(-angle*pi/180)/hist_width;
exp_scale = -1/(d*d*0.5);
% Clip the radius to the diagonal of the image to avoid autobuffer too large exception
[rows,cols] = size(img);
radius = min(radius,round(sqrt(rows*rows+cols*cols))); 
hist = zeros(d+2,d+2,n+1);

%% initial hist
for i=1:d+2
    for j=1:d+2
        for k=1:n+1
            hist(i,j,k) = 0;
        end
    end
end
 
%%
x0 = pt(1);
y0 = pt(2);
k = 0;
for i=-radius:radius
    for j=-radius:radius
        c_rot = j*cos_t-i*sin_t;
        r_rot = j*sin_t+i*cos_t;
        rbin = r_rot+d/2-0.5; %·¶Î§-1~4
        cbin = c_rot+d/2-0.5; %·¶Î§-1~4
        r = y0+i;
        c = x0+j;
        if rbin > -1 && rbin < d && cbin > -1 && cbin < d &&...
                r > 1 && r < rows  && c > 1 && c < cols
            dx = img(r,c+1)-img(r,c-1);
            dy = img(r+1,c)-img(r-1,c);
            Mag = sqrt(dx^2+dy^2);
            Ang = atan2(dy,dx)*180/pi;
            if Ang < 0 
                Ang = Ang+360;  
            end
            W = exp((c_rot*c_rot+r_rot*r_rot)*exp_scale);
            %%
            rbin = rbin+2; %·¶Î§1~d+2
            cbin = cbin+2; %·¶Î§1~d+2
            obin = (Ang-angle)/360*n;
            obin = mod(obin,n)+1; %·¶Î§[1~n+1)
            mag = Mag*W;
            r0 = floor(rbin); %·¶Î§1~d+1
            c0 = floor(cbin); %·¶Î§1~d+1
            o0 = floor(obin); %·¶Î§1~n
            rbin = rbin-r0;
            cbin = cbin-c0;
            obin = obin-o0; 
            % histogram update using tri-linear interpolation
            v_r1 = mag*rbin;
            v_r0 = mag-v_r1;	
            v_rc11 = v_r1*cbin;v_rc10 = v_r1-v_rc11;
            v_rc01 = v_r0*cbin;v_rc00 = v_r0-v_rc01;
            v_rco111 = v_rc11*obin;v_rco110 = v_rc11-v_rco111;
            v_rco101 = v_rc10*obin; v_rco100 = v_rc10-v_rco101;
            v_rco011 = v_rc01*obin;v_rco010 = v_rc01-v_rco011;
            v_rco001 = v_rc00*obin;v_rco000 = v_rc00-v_rco001;
            hist(r0,c0,o0) = hist(r0,c0,o0)+v_rco000;
            hist(r0,c0,o0+1) = hist(r0,c0,o0+1)+v_rco001;
            hist(r0,c0+1,o0) = hist(r0,c0+1,o0)+v_rco010;
            hist(r0,c0+1,o0+1) = hist(r0,c0+1,o0+1)+v_rco011;
            hist(r0+1,c0,o0) = hist(r0+1,c0,o0)+v_rco100;
            hist(r0+1,c0,o0+1) = hist(r0+1,c0,o0+1)+v_rco101;
            hist(r0+1,c0+1,o0) = hist(r0+1,c0+1,o0)+v_rco110;
            hist(r0+1,c0+1,o0+1) = hist(r0+1,c0+1,o0+1)+v_rco111;
        end
    end
end

%% finalize histogram, since the orientation histograms are circular
descriptor = zeros(1,d*d*n);
for i=1:d
    for j=1:d
        hist(i+1,j+1,1) = hist(i+1,j+1,1)+hist(i+1,j+1,n+1);
        for k=1:n
            descriptor(((i-1)*d+(j-1))*n+k) = hist(i+1,j+1,k);
        end
    end
end

%%
nrm = 0;
len = d*d*n;
for i=1:len
    nrm = nrm+descriptor(i)^2;
end
thresh = sqrt(nrm)*0.2;
nrm = 0;
for i=1:len
    val = min(descriptor(i),thresh);
    descriptor(i) = val;
    nrm = nrm+val*val;
end
if nrm > 0
    nrm = 512/sqrt(nrm);
end
descriptor = uint8(descriptor*nrm);

end
