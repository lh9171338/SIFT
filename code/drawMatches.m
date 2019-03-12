function img = drawMatches(img0,keypoints0,img1,keypoints1,matches)

%% 拼接图片
[rows0,cols0,ch] = size(img0);
[rows1,cols1,~] = size(img1);
rows = max(rows0,rows1);
cols = cols0+cols1;
img = uint8(zeros(rows,cols,ch));
img(1:rows0,1:cols0,:) = img0;
img(1:rows1,cols0+1:end,:) = img1;

% %% 画特征点
% num = numel(keypoints0);
% for i=1:num
%     pt = round(keypoints0(i).pt);
%     color = round(rand(1,3)*255);
%     img = insertShape(img,'Circle',[pt,2],'Color',color,'LineWidth',2);
% end
% num = numel(keypoints1);
% for i=1:num
%     pt = round(keypoints1(i).pt);
%     pt(1) = pt(1)+cols0;
%     color = round(rand(1,3)*255);
%     img = insertShape(img,'Circle',[pt,2],'Color',color,'LineWidth',2);
% end

%% 画匹配的特征点
num = numel(matches);
for i=1:num
    idx0 = matches(i).idx0;
    idx1 = matches(i).idx1;
    pt0 = round(keypoints0(idx0).pt);
    pt1 = round(keypoints1(idx1).pt);
    pt1(1) = pt1(1)+cols0;
    color = round(rand(1,3)*255);
    img = insertShape(img,'Circle',[pt0,2],'Color',color,'LineWidth',2);
    img = insertShape(img,'Circle',[pt1,2],'Color',color,'LineWidth',2);
    img = insertShape(img,'Line',[pt0,pt1],'Color',color,'LineWidth',1);
end

%% 显示
figure;
imshow(img);

end