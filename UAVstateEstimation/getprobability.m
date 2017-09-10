function py = getprobability(y,states)
    uniquerows = states;
    m = size(y,1);
    noOfOutput = size(uniquerows,1);
    py = zeros(noOfOutput,1);
    for i=1:noOfOutput
        indexes = find(y(:,1)==uniquerows(i,1) ...
                     & y(:,2)==uniquerows(i,2) ...
                     & y(:,3)==uniquerows(i,3) ...
                     & y(:,4)==uniquerows(i,4));
        py(i) = length(indexes)/m;
    end
end