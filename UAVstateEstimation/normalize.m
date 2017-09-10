function xNorm = normalize(x)
    c = size(x,2);
    xNorm = zeros(size(x));
    for i=1:c
        ma = max(x(:,i));
        mi = min(x(:,i));
        xNorm(:,i) = x(:,i)/abs(ma-mi);
    end

end