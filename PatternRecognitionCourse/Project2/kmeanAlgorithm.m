function [z,classes] = kmeanAlgorithm(x,k,z,T)
classes = cell(1,k);
for i=1:k
    classes{1,i}=[];
end
iterationNo = 1;
while 1
    %fprintf('Iteration Number : %d\n', iterationNo);
    iterationNo = iterationNo + 1;
    for i=1:size(x,2)
        temp = ones(size(z)).*x(:,i);
        [m mi] = min(sqrt(sum((z-temp).^2)));
        classes{1,mi} = [classes{1,mi} x(:,i)];
    end
    zNew = zeros(size(z));
    for i=1:k
        temp = classes{1,i};
        zNew(:,i) = (1/size(temp,2))*sum(temp,2);
    end
    if sum(sum(abs(z-zNew)> T)) == 0
        break;
    else
        z=zNew;
    end
    for i=1:k
        classes{1,i}=[];
    end
end
end