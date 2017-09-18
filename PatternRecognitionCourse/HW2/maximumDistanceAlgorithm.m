function [z,L] = maximumDistanceAlgorithm(x)
z = x(:,1);
dist = 0;
xx=x;
x=x(:,2:end);
while 1
    n = size(x,2);
    distances = zeros(1,n);
    for i=1:n
        c = size(z,2);
        p = ones(size(z,1),c).*x(:,i);
        d = z - p;
        d = sum(d.^2);
        d = sqrt(d);
        distances(i) = min(d);
    end
    
    [dn, dni] = max(distances);
    if dist ~= 0 && dn > dist
        temp = ones(size(z)).*x(:,dni);
        dist =.5 * mean(sqrt(sum((z-temp).^2)));
        z = [z x(:,dni)];
        if size(x,2) == 1
            break;
        elseif dni == 1
            x=x(:,2:end);
        elseif dni == size(x,2)
            x=x(:,1:dni-1);
        else
            x=[x(:,1:dni-1) x(:,dni+1:end)];
        end
    elseif dist ~= 0 && dn < dist
        break;
    else
        z = [z x(:,dni)];
        dist = sqrt(sum((z(:,2) - z(:,1)).^2))/2;
        if size(x,2) == 1
            break;
        elseif dni == 1
            x=x(:,2:end);
        elseif dni == size(x,2)
            x=x(:,1:dni-1);
        else
            x=[x(:,1:dni-1) x(:,dni+1:end)];
        end
    end
end
L = zeros(1,size(xx,2));
for i= 1:size(xx,2)
    temp = ones(size(z)).*xx(:,i);
    [mi, L(i)] = min(sqrt(sum((z-temp).^2)));
end
end