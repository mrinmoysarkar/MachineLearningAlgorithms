function [mu, sigma, states] = getMeanAndVarience(x,y)
    uniquerows = unique(y,'rows');
    
    noOffeature = size(x,2);
    noOfOutput = size(uniquerows,1);
    mu = zeros(noOfOutput, noOffeature);
    sigma = zeros(noOfOutput, noOffeature);
    
    for i=1:noOfOutput
        indexes = find(y(:,1)==uniquerows(i,1) ...
                     & y(:,2)==uniquerows(i,2) ...
                     & y(:,3)==uniquerows(i,3) ...
                     & y(:,4)==uniquerows(i,4));
        tempx = x(indexes,:);
        for j=1:noOffeature
            mu(i,j) = mean(tempx(:,j));
            sigma(i,j) = var(tempx(:,j));
        end        
    end
    states = uniquerows;
end