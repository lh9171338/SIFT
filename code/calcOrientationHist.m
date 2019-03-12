function hist = calcOrientationHist(img,pt,radius,sigma,n)

%% variable
len = (radius*2+1)*(radius*2+1);
expf_scale = -1/(2*sigma*sigma);
temphist = zeros(n+4,1);
hist = zeros(n,1);
% initial temphist
for i=1:n+4
    temphist(i) = 0;
end

%%
x0 = pt(1);
y0 = pt(2);
[rows,cols] = size(img);
for i = -radius:radius
    y = y0+i;
    if y <= 1 || y >= rows
        continue;
    end
    for j=-radius:radius
        x = x0+j;
        if x <= 1 || x >= cols
            continue;
        end
        dx = img(y,x+1)-img(y,x-1);
        dy = img(y+1,x)-img(y-1,x);
        Mag = sqrt(dx^2+dy^2);
        Ang = atan2(dy,dx)*180/pi;
        if Ang < 0 
            Ang = Ang+360;  
        end
        W = exp((i*i+j*j)*expf_scale);
        bin = round(Ang/360*n);
        bin = mod(bin,n)+1;
        temphist(bin+2) = temphist(bin+2)+W*Mag;
    end
end

%% smooth the histogram
temphist(1) = temphist(n+1);
temphist(2) = temphist(n+2);
temphist(n+3) = temphist(3);
temphist(n+4) = temphist(4);
for i=3:n+2
    hist(i-2) = (temphist(i-2) + temphist(i+2))*(1/16)+...
        (temphist(i-1)+temphist(i+1))*(4/16)+...
        temphist(i)*(6/16);
end

end