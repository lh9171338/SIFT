function displayPyramid(pyr)

%% get parameter
[m,n] = size(pyr);

%% display
for i=1:m
    for j=1:n
        % 取绝对值
        img = abs(pyr{i,j});
        % 归一化
        img = img/max(img(:))*255;
        figure;
        imshow(uint8(img));
    end
end

end