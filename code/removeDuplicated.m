function keypoints = removeDuplicated(keypoints)

%%
n = numel(keypoints);
mask = true(n,1);     
for i=1:n-1
    kp1 = keypoints(i);
    for j=i+1:n
        kp2 = keypoints(j);
        if  kp1.pt(1) == kp2.pt(1) && kp1.pt(2) == kp2.pt(2) &&...
            kp1.sigma == kp2.sigma && kp1.angle == kp2.angle 
            mask(j) = 0;
        end
    end
end
    
%%
j = 0;
for i=1:n
    if mask(i)
        j = j+1;
        if i ~= j 
            keypoints(j) = keypoints(i);
        end
    end
end
keypoints = keypoints(1:j);

end
