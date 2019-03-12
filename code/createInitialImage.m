function base = createInitialImage(img,param)

%% ת�Ҷ�ͼ
if size(img,3) ~= 1
    img = rgb2gray(img);
end
img = double(img);

%% ��˹�˲�
sigma0 = param.sigma0;
initsigma = param.initsigma;
width = param.width;
if param.firstOctave < 0
    img = imresize(img,2);
    sigma = sqrt(sigma0^2-4*initsigma^2);
    sigma = max(sigma,0.1);
    base = GaussianBlur(img,width,sigma);
else
    sigma = sqrt(sigma0^2-initsigma^2);
    sigma = max(sigma,0.1);
    base = GaussianBlur(img,width,sigma);
end

    
end