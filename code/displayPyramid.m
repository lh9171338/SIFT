function displayPyramid(pyr)

%% get parameter
[m,n] = size(pyr);

%% display
for i=1:m
    for j=1:n
        % ȡ����ֵ
        img = abs(pyr{i,j});
        % ��һ��
        img = img/max(img(:))*255;
        figure;
        imshow(uint8(img));
    end
end

end