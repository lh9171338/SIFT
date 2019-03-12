%% test.m
%%
clc,clear;
close all;

%% parameter
filename1 = '../image/lena1.jpg';
filename2 = '../image/lena2.jpg';
resultfilename = '../image/lena_result.jpg';
% filename1 = '../image/image1.png';
% filename2 = '../image/image2.png';
% resultfilename = '../image/image_result.jpg';

%% read and show image
img1 = imread(filename1);
img2 = imread(filename2);
% figure;
% imshow(img1);
% title('image 1');
% figure;
% imshow(img2);
% title('image 2');

%% detect and draw keypointsti
tic;
[keypoints1,descriptors1] = detect(img1);
toc
tic;
[keypoints2,descriptors2] = detect(img2);
toc
% drawKeypoints(img1,keypoints1);
% drawKeypoints(img2,keypoints2);
        
%% match and draw
matches = match(descriptors1,descriptors2,0.6);
img = drawMatches(img1,keypoints1,img2,keypoints2,matches);

%% save the result image
imwrite(img,resultfilename);

