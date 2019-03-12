function img = drawKeypoints(img,keypoints)

%%
num = numel(keypoints);
for i=1:num
    pt = keypoints(i).pt;
    pt = round(pt);
    color = round(rand(1,3)*255);
    img = insertShape(img,'Circle',[pt,2],'Color',color,'LineWidth',2);
end
figure;
imshow(img);

end