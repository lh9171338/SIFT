function keypoints = retainBest(keypoints,n_points)

%% sort
n = numel(keypoints);
for i=1:n-1
    kp1 = keypoints(i);
    for j=i+1:n
        kp2 = keypoints(j);
        if  kp2.response > kp1.response
            value = kp1;
            kp1 = kp2;
            keypoints(j) = value;
        end
    end
    keypoints(i) = kp1;
end
    
%%
n_points = min(n_points,n);
keypoints = keypoints(1:n_points);

end
