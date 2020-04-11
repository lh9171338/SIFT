function descriptors = rotateDescriptors(descriptors,param)
%ROTATEDESCRIPTOR - Rotate descriptors.
%
%   descriptors = rotateDescriptor(descriptors,param)

%% check argument
narginchk(2,2);
nargoutchk(0,1);

%% parameter
d = param.d;
n = param.n;

%% rotate descriptor
num = size(descriptors,1);
for i=1:num
    descriptor = reshape(descriptors(i,:)',[n,d*d]);
    descriptor = fliplr(descriptor);
    descriptors(i,:) = reshape(descriptor,[n*d*d,1])';
end