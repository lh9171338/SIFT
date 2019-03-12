function [res,x] = solve3x3(A,b)

x = b;
for i=1:3
    if A(i,i) == 0
            flag = false;
%             for k=i+1:3
%                 if A(k,i) ~= 0
%                     temp = A(k,:);
%                     A(k,:) = A(i,:);
%                     A(i,:) = temp;
%                     temp = x(k);
%                     x(k) = x(i);
%                     x(i) = temp;
%                     flag = true;
%                     break;
%                 end
%             end
            if ~flag
                res = false;
                return;
            end
    end
    x(i) = x(i)/A(i,i);
    A(i,:) = A(i,:)/A(i,i);
    for j=1:3
        if i~=j
            x(j) = x(j)-A(j,i)*x(i);
            A(j,:) = A(j,:)-A(j,i)*A(i,:);
        end
    end
end
res = true;

end