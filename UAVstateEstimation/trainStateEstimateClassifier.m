close all;

[x,y] = dataFormation();

x=normalize(x);
%shuffle the data


m = size(x,1);
indexes = randi(m,1,m);

trainSetLength = .6*m; % 60% train set
trainX = x(indexes(1:trainSetLength),:);
trainY = y(indexes(1:trainSetLength),:);

testX = x(indexes(trainSetLength+1:end),:);
testY = y(indexes(trainSetLength+1:end),:);

[mu,sigma,states] = getMeanAndVarience(trainX,trainY);

py = getprobability(trainY,states);

save('parameter.mat','mu','sigma','py','testX','testY','states')