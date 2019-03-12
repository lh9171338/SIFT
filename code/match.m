function matches = match(descriptors0,descriptors1,thresh)

%%
matches = [];
if size(descriptors0,1) <= size(descriptors1,1)
    queryDescriptors = descriptors0;
    trainDescriptors = descriptors1;
    nquery = size(queryDescriptors,1);
    ntrain = size(trainDescriptors,1);
    for i=1:nquery
        queryDescriptor = queryDescriptors(i,:);
        min_dist0 = realmax;
        min_dist1 = realmax;
        min_idx = 0;
        for j=1:ntrain
            trainDescriptor = trainDescriptors(j,:);
            delta = queryDescriptor-trainDescriptor;
            dist = sum(delta.^2);
            if dist < min_dist0
                min_dist1 = min_dist0;
                min_dist0 = dist;
                min_idx = j;
            elseif dist < min_dist1
                min_dist1 = dist;
            end    
        end
        % 筛选匹配点
        if min_dist0 < thresh*min_dist1
            temp.idx0 = i;
            temp.idx1 = min_idx;
            matches = cat(1,matches,temp);
        end   
    end
else
    queryDescriptors = descriptors1;
    trainDescriptors = descriptors0;
    nquery = size(queryDescriptors,1);
    ntrain = size(trainDescriptors,1);
    for i=1:nquery
        queryDescriptor = queryDescriptors(i,:);
        min_dist0 = realmax;
        min_dist1 = realmax;
        min_idx = 0;
        for j=1:ntrain
            trainDescriptor = trainDescriptors(j,:);
            delta = queryDescriptor-trainDescriptor;
            dist = sum(delta.^2);
            if dist < min_dist0
                min_dist1 = min_dist0;
                min_dist0 = dist;
                min_idx = j;
            elseif dist < min_dist1
                min_dist1 = dist;
            end    
        end
        % 筛选匹配点
        if min_dist0 < thresh*min_dist1
            temp.idx1 = i;
            temp.idx0 = min_idx;
            matches = cat(1,matches,temp);
        end   
    end    
end


end


