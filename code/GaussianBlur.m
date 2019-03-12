function dst = GaussianBlur(src,width,sigma)

%% get parameter
if width == 0
    width = round(sigma*6+1);
    if mod(width,2) == 0
        width = width+1;
    end
end

%% ¸ßË¹ÂË²¨
k = fspecial('gaussian',width,sigma);
dst = imfilter(src,k,'replicate');

end