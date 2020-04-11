% rotation_demo.m
%%
clear,clc;
close all;

%% Parameters

srcFilename1 = '../image/book/image1.jpg';
srcFilename2 = '../image/book/image2.jpg';
dstPath = '../image/rotation';
saveFlag = true;
dTheta = 10;
nTheta = round(360 / dTheta);

%% Read images
srcImage1 = imread(srcFilename1);
srcImage2 = imread(srcFilename2);

%% Test
figure;
for i=1:nTheta
    theta = i * dTheta;
    rotatedImage = imrotate(srcImage2,theta);
    dstImage = SIFTMatch(srcImage1,rotatedImage);
    dstFilename = [dstPath,'/',num2str(theta),'.jpg'];
    imshow(dstImage);
    if saveFlag
        imwrite(dstImage,dstFilename);
    end
    fprintf('Progress: %d/%d\n',i,nTheta);
end
