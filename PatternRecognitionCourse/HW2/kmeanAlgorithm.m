function [z,classes] = kmeanAlgorithm(x,k)
classes = cell(1,k);
z=zeros(size(x,1),k);
for i=1:k
    z(:,i) = x(:,i);
    classes{1,i}=[];
end

while 1
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
    if sum(sum(z-zNew)) == 0
        break;
    else
        z=zNew;
    end
    for i=1:k
        classes{1,i}=[];
    end
end
end