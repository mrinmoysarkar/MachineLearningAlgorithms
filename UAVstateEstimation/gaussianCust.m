function p = gaussianCust(x,mu,sigma)
    p = (1/sqrt(2*pi*sigma.^2)) .* exp(-.5*((x-mu)/sigma).^2);
end