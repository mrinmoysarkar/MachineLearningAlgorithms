clear;
close all;

load('parameter.mat')


m = size(testX,1);
n = size(states,1);
allP = zeros(1,n);
correct = 0;
for i=1:10
    xtemp = testX(i,:);
    for j=1:n
        p = py(j);
        for k=1:length(xtemp)
            p = p * gaussianCust(xtemp(k),mu(j,k),sigma(j,k));
        end
        allP(j) = p;
    end
    [ma,mai] = max(allP);
%     disp('true:');
%     disp(testY(i,:));
%     disp('estimated:');
%     disp(states(mai,:));
%     disp('probability:');
%     disp(ma)
    
    Y = testY(i,:);
    Ystar = states(mai,:);
    if sum(Y==Ystar) == length(Y)
        correct = correct + 1;
    end
end

disp('correct:');
disp(correct);
disp('total');
disp(m);

disp('correct%:');
disp((correct*100)/m);