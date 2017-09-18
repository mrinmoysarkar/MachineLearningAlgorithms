%% max_dist_K_mean_test.m 
%  author: mrinmoy sarkar
%  email:msarkar@aggies.ncat.edu

clear;
close all;
% data
x = [0 0 5 5 4 1;
     0 1 4 5 5 0];
 
%% plot data
figure;
plot(x(1,:),x(2,:),'or');
xlabel('x1');
ylabel('x2');
axis([-1 6 -1 6])
title('visualize of data points')



%% Maximum-Distance algorithm
[z,L] = maximumDistanceAlgorithm(x);
figure
noOfClass = size(z,2);
classes = cell(1,noOfClass);
indicator={'g>','b<'};
for i=1:noOfClass
    index = find(L==i);
    data = x(:,index);
    classes{1,i} = data;
    %plot different cluster member with different color
    hold on;
    plot(data(1,:),data(2,:),indicator{i},'MarkerSize',10);
end

%indicate cluster centre
plot(z(1,:),z(2,:),'ko','MarkerSize',15);
axis([-1 6 -1 6])
xlabel('x1');
ylabel('x2');
legend('cluster 1','cluster 2','cluster center');
title('clustering using Maximum-Distance Algorithms')


%% K-Means Algorithm
k = 2;
[z, classes] = kmeanAlgorithm(x,k);
figure
for i=1:k
    data = classes{1,i};
    %plot different cluster member with different color
    hold on;
    plot(data(1,:),data(2,:),indicator{i},'MarkerSize',10);
end

%indicate cluster centre
plot(z(1,:),z(2,:),'k*','MarkerSize',15);
axis([-1 6 -1 6])
xlabel('x1');
ylabel('x2');
legend('cluster 1','cluster 2','cluster center');
title('clustering using K-Means Algorithms')