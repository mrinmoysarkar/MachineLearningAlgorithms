%% file name project3.m
% author: Mrinmoy Sarkar
% email: msarkar@aggies.ncat.edu
% date: 10/24/2017


clear;
close all;

% load data to a veriable
data = importdata('iris.txt');

% no. of class is 3 named Iris-setosa, Iris-versicolor and Iris-verginica
% there are 4 attributes named sepal-length, sepal-width, petal-length,
% petal-width
% there are 50 plants for each species

irisSetosa = zeros(50,4);
irisVersicolor = zeros(50,4);
irisVerginica = zeros(50,4);

n = size(data,1);

indxSeto = 1;
indxVers = 1;
indxVerg = 1;

for i=2:n
    x = strsplit(cell2mat(data(i)));
    if strcmp(x(5), 'Iris-setosa')
        for j=1:4
            irisSetosa(indxSeto,j) = str2double(cell2mat(x(j)));
        end
        indxSeto = indxSeto + 1;
    elseif strcmp(x(5), 'Iris-versicolor')
        for j=1:4
            irisVersicolor(indxVers,j) = str2double(cell2mat(x(j)));
        end
        indxVers = indxVers + 1;
    elseif strcmp(x(5), 'Iris-virginica')
        for j=1:4
            irisVerginica(indxVerg,j) = str2double(cell2mat(x(j)));
        end
        indxVerg = indxVerg + 1;
    end
end

%% minimum-distance classifier
trs = [10,25];
tns = [40,25];
for l=1:2
    no_of_train_sample = trs(l);
    no_of_test_sample = tns(l);
    fprintf('minimum-distance classifier for no. of training sample : %d and no. of test sample : %d\n',no_of_train_sample, no_of_test_sample);
    % dataset is partisioned as train:test = no_of_train_sample:no_of_test_sample
    trainSet = [irisSetosa(1:no_of_train_sample,:); irisVersicolor(1:no_of_train_sample,:); irisVerginica(1:no_of_train_sample,:)];
    testSet = [irisSetosa(no_of_train_sample+1:50,:); irisVersicolor(no_of_train_sample+1:50,:); irisVerginica(no_of_train_sample+1:50,:)];
    
    % mean vector calculation
    m_i = [mean(trainSet(1:no_of_train_sample,:));mean(trainSet(no_of_train_sample+1:2*no_of_train_sample,:));mean(trainSet(2*no_of_train_sample+1:3*no_of_train_sample,:))];
    disp('mean vector:');
    disp(m_i)
    mi_das_mi = 0.5 * diag(m_i*m_i');
    confussionMat = zeros(3,3);
    % test each sample
    for i = 1:no_of_test_sample*3
        testX = testSet(i,:);
        di = testX*m_i' - mi_das_mi';
        [m, m_index] = max(di);
        if i<=no_of_test_sample
            confussionMat(m_index, 1) = confussionMat(m_index, 1) + 1;
        elseif i>no_of_test_sample && i<=2*no_of_test_sample
            confussionMat(m_index, 2) = confussionMat(m_index, 2) + 1;
        else
            confussionMat(m_index, 3) = confussionMat(m_index, 3) + 1;
        end
    end
    
    fprintf('\nConfusion Matrix:        |irisSetosa(True) | irisVersicolor(True) | irisVerginica(True)\n');
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('irisSetosa(Predicted)     | %2d              | %2d                   | %2d\n', confussionMat(1,1), confussionMat(1,2), confussionMat(1,3));
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('irisVersicolor(Predicted) | %2d              | %2d                   | %2d\n', confussionMat(2,1), confussionMat(2,2), confussionMat(2,3));
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('irisVerginica(Predicted)  | %2d              | %2d                   | %2d\n', confussionMat(3,1), confussionMat(3,2), confussionMat(3,3));
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('Correct = %.2f%%\n\n\n',100*sum(diag(confussionMat))/(3*no_of_test_sample));
end

%% quadratic Bayesian classifier
trs = [10,25];
tns = [40,25];
for l=1:2
    no_of_train_sample = trs(l);
    no_of_test_sample = tns(l);
     fprintf('quadratic Bayesian classifier for no. of training sample : %d and no. of test sample : %d\n',no_of_train_sample, no_of_test_sample);
    % dataset is partisioned as train:test = no_of_train_sample:no_of_test_sample
    trainSet = [irisSetosa(1:no_of_train_sample,:); irisVersicolor(1:no_of_train_sample,:); irisVerginica(1:no_of_train_sample,:)];
    testSet = [irisSetosa(no_of_train_sample+1:50,:); irisVersicolor(no_of_train_sample+1:50,:); irisVerginica(no_of_train_sample+1:50,:)];
    
    % mean vector calculation
    m_i = [mean(trainSet(1:no_of_train_sample,:));mean(trainSet(no_of_train_sample+1:2*no_of_train_sample,:));mean(trainSet(2*no_of_train_sample+1:3*no_of_train_sample,:))];
    disp('mean vector:');
    disp(m_i)
    % co-varience matrix calculation
    cv = [cov(trainSet(1:no_of_train_sample,:));cov(trainSet(no_of_train_sample+1:2*no_of_train_sample,:));cov(trainSet(2*no_of_train_sample+1:3*no_of_train_sample,:))];
    disp('Co-variance Matrix:');
    disp('CV1 = ');
    disp(cv(1:4,:));
    disp('CV2 = ');
    disp(cv(5:8,:));
    disp('CV3 = ');
    disp(cv(9:12,:));
    
    confussionMat = zeros(3,3);
    % test each sample
    for i = 1:no_of_test_sample*3
        testX = testSet(i,:);
        ln_ci = [log(det(cv(1:4,:))) log(det(cv(5:8,:))) log(det(cv(9:12,:)))];
        ln_ci = -0.5 * ln_ci;
        xm_i = [testX;testX;testX] - m_i;
        xm_i_das_Cinv_xm_i = [xm_i(1,:)*inv(cv(1:4,:))*(xm_i(1,:))' xm_i(2,:)*inv(cv(5:8,:))*(xm_i(2,:))' xm_i(3,:)*inv(cv(9:12,:))*(xm_i(3,:))'];
        xm_i_das_Cinv_xm_i = -0.5 * xm_i_das_Cinv_xm_i;
        di = ln_ci + xm_i_das_Cinv_xm_i;
        [m, m_index] = max(di);
        if i<=no_of_test_sample
            confussionMat(m_index, 1) = confussionMat(m_index, 1) + 1;
        elseif i>no_of_test_sample && i<=2*no_of_test_sample
            confussionMat(m_index, 2) = confussionMat(m_index, 2) + 1;
        else
            confussionMat(m_index, 3) = confussionMat(m_index, 3) + 1;
        end
    end
    
    fprintf('\nConfusion Matrix:        |irisSetosa(True) | irisVersicolor(True) | irisVerginica(True)\n');
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('irisSetosa(Predicted)     | %2d              | %2d                   | %2d\n', confussionMat(1,1), confussionMat(1,2), confussionMat(1,3));
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('irisVersicolor(Predicted) | %2d              | %2d                   | %2d\n', confussionMat(2,1), confussionMat(2,2), confussionMat(2,3));
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('irisVerginica(Predicted)  | %2d              | %2d                   | %2d\n', confussionMat(3,1), confussionMat(3,2), confussionMat(3,3));
    fprintf('----------------------------------------------------------------------------------------\n');
    fprintf('Correct = %.2f%%\n\n\n',100*sum(diag(confussionMat))/(3*no_of_test_sample));
end











