%% file name project4.m
% author: Mrinmoy Sarkar
% email: msarkar@aggies.ncat.edu
% date: 12/1/2017

%%
clear all;
close all;
%% load data to a veriable
data = importdata('iris.txt');

% no. of class is 3 named Iris-setosa, Iris-versicolor and Iris-verginica
% there are 4 attributes named sepal-length, sepal-width, petal-length,
% petal-width
% there are 50 plants for each species

irisSetosad = zeros(50,4);
irisVersicolord = zeros(50,4);
irisVerginicad = zeros(50,4);

n = size(data,1);

indxSeto = 1;
indxVers = 1;
indxVerg = 1;

for i=2:n
    x = strsplit(cell2mat(data(i)));
    if strcmp(x(5), 'Iris-setosa')
        for j=1:4
            irisSetosad(indxSeto,j) = str2double(cell2mat(x(j)));
        end
        indxSeto = indxSeto + 1;
    elseif strcmp(x(5), 'Iris-versicolor')
        for j=1:4
            irisVersicolord(indxVers,j) = str2double(cell2mat(x(j)));
        end
        indxVers = indxVers + 1;
    elseif strcmp(x(5), 'Iris-virginica')
        for j=1:4
            irisVerginicad(indxVerg,j) = str2double(cell2mat(x(j)));
        end
        indxVerg = indxVerg + 1;
    end
end

featureName = {'SL','SW','PL','PW'};
color = 'rgbkmc';

%% divergence calculation and quadratic Bayesian classifier implementation
for opt = 1:3
    option = opt;
    for sf=2:3
        noOfclass = 3;
        classes={};
        classes{1} = irisSetosad;
        classes{2} = irisVersicolord;
        classes{3} = irisVerginicad;
        
        noOfselectedFeature = sf;
        featurevector = 1:4;
        combOffeature = nchoosek(featurevector,noOfselectedFeature);
        combOfclass = nchoosek(1:3,2);
        Di = zeros(size(combOffeature,1),1);
        Pe = Di;
        for ii=1:size(combOffeature,1)
            mu = {};
            co = {};
            for j=1:noOfclass
                cl = classes{j};
                mu{j} = (mean(cl(:,combOffeature(ii,:))))';
                co{j} = (cov(cl(:,combOffeature(ii,:))));
            end
            D = zeros(noOfclass,1);
            a = D;
            for j=1:size(combOfclass,1)
                D(j) = 0.5*trace((co{combOfclass(j,1)}-co{combOfclass(j,2)})*(pinv(co{combOfclass(j,2)})-pinv(co{combOfclass(j,1)})))...
                    + 0.5*trace((pinv(co{combOfclass(j,1)})+pinv(co{combOfclass(j,2)}))*(mu{combOfclass(j,1)}-mu{combOfclass(j,2)})...
                    *(mu{combOfclass(j,1)} - mu{combOfclass(j,2)})');
                
                A = 0.5*(co{combOfclass(j,1)}+co{combOfclass(j,2)});
                a(j) = 0.125*(mu{combOfclass(j,1)} - mu{combOfclass(j,2)})'...
                    *pinv(A)*(mu{combOfclass(j,1)} - mu{combOfclass(j,2)})...
                    +0.5*log(det(A)/sqrt(det(co{combOfclass(j,1)})*det(co{combOfclass(j,2)})));
            end
            if option == 1 %divergence
                Di(ii) = mean(D);
            elseif option == 2 %Transformed divergence
                Di(ii) = mean(2*(1-exp(-D)/8));
            elseif option == 3 %Bhattacharyya distance
                Di(ii) = mean(2*(1-exp(-a)));
            end
            
            
            
            
            % quadratic Bayesian classifier
            irisSetosa = irisSetosad(:,combOffeature(ii,:));
            irisVersicolor = irisVersicolord(:,combOffeature(ii,:));
            irisVerginica = irisVerginicad(:,combOffeature(ii,:));
            
            no_of_train_sample = 50;
            no_of_test_sample = 50;
            fprintf('quadratic Bayesian classifier for no. of training sample : %d and no. of test sample : %d\n',no_of_train_sample, no_of_test_sample);
            % dataset is partisioned as train:test = no_of_train_sample:no_of_test_sample
            trainSet = [irisSetosa(1:no_of_train_sample,:); irisVersicolor(1:no_of_train_sample,:); irisVerginica(1:no_of_train_sample,:)];
            testSet = [irisSetosa(1:no_of_test_sample,:); irisVersicolor(1:no_of_test_sample,:); irisVerginica(1:no_of_test_sample,:)];
            
            % mean vector calculation
            m_i = [mean(trainSet(1:no_of_train_sample,:));mean(trainSet(no_of_train_sample+1:2*no_of_train_sample,:));mean(trainSet(2*no_of_train_sample+1:3*no_of_train_sample,:))];
            
            % co-varience matrix calculation
            cv = [cov(trainSet(1:no_of_train_sample,:));cov(trainSet(no_of_train_sample+1:2*no_of_train_sample,:));cov(trainSet(2*no_of_train_sample+1:3*no_of_train_sample,:))];
            
            confussionMat = zeros(3,3);
            % test each sample
            for i = 1:no_of_test_sample*3
                testX = testSet(i,:);
                ln_ci = [log(det(cv(1:noOfselectedFeature,:))) log(det(cv(noOfselectedFeature+1:2*noOfselectedFeature,:))) log(det(cv(2*noOfselectedFeature+1:3*noOfselectedFeature,:)))];
                ln_ci = -0.5 * ln_ci;
                xm_i = [testX;testX;testX] - m_i;
                xm_i_das_Cinv_xm_i = [xm_i(1,:)*pinv(cv(1:noOfselectedFeature,:))*(xm_i(1,:))' xm_i(2,:)*pinv(cv(noOfselectedFeature+1:2*noOfselectedFeature,:))*(xm_i(2,:))' xm_i(3,:)*pinv(cv(2*noOfselectedFeature+1:3*noOfselectedFeature,:))*(xm_i(3,:))'];
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
            Pe(ii) = 100 - 100*sum(diag(confussionMat))/(3*no_of_test_sample);
        end
        
        % sort divergence
        [Di,indx] = sort(Di);
        tpe = Pe;
        tcombOffeature = combOffeature;
        for jj=1:length(Di)
            Pe(jj) = tpe(indx(jj));
            combOffeature(jj,:) = tcombOffeature(indx(jj),:);
        end
        figure
        for jj=1:length(Di)
            if length(Di)==6
                lgnd = strcat(featureName{combOffeature(jj,1)},',',featureName{combOffeature(jj,2)});
            else
                lgnd = strcat(featureName{combOffeature(jj,1)},',',featureName{combOffeature(jj,2)},',',featureName{combOffeature(jj,3)});
            end
            disp(lgnd)
            plot(Di(jj),Pe(jj),strcat('*',color(jj)),'LineWidth',7,'DisplayName', lgnd);
            legend('-DynamicLegend');
            hold on;
        end
        if length(Di)==6
            title('Two Features');
        else
            title('Three Features');
        end
        xlabel('Divergence');
        ylabel('Probability of Error(%)');
        disp('Divergence:')
        disp(Di')
        disp('Probability of Error(%):')
        disp(Pe')
    end
end
