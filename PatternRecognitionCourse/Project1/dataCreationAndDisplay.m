%% file name dataCreationAndDisplay.m
% author: Mrinmoy Sarkar
% email: msarkar@aggies.ncat.edu
% date: 9/2/2017


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





%% plot Fisher's Iris data with petal width versus sepal length
figure;
plot(irisSetosa(:,1), irisSetosa(:,4), 'or'); hold on;
plot(irisVersicolor(:,1), irisVersicolor(:,4), '>c'); hold on;
plot(irisVerginica(:,1), irisVerginica(:,4), '^b'); hold on;

axis([min([min(irisSetosa(:,1)),min(irisVersicolor(:,1)),min(irisVerginica(:,1))])-1 ...
    max([max(irisSetosa(:,1)),max(irisVersicolor(:,1)),max(irisVerginica(:,1))])+1 ...
    min([min(irisSetosa(:,4)),min(irisVersicolor(:,4)),min(irisVerginica(:,4))])-1 ...
    max([max(irisSetosa(:,4)), max(irisVersicolor(:,4)),max(irisVerginica(:,4))])+1]);

title('petal width vs sepal length');
xlabel('sepal length');
ylabel('petal width');
legend('Iris Setosa', ' Iris Versicolor', 'Iris Verginica','AutoUpdate','off');






%% plot overlap symbol (*)
overlapingPointX = [];
overlapingPointY = [];
for i=1:length(irisSetosa(:,1))
    x11 = irisSetosa(i,1);
    y11 = irisSetosa(i,4);
    x21 = irisVersicolor(i,1);
    y21 = irisVersicolor(i,4);
    for j=1:length(irisSetosa(:,1))
        x22 = irisVersicolor(j,1);
        y22 = irisVersicolor(j,4);
        x32 = irisVerginica(j,1);
        y32 = irisVerginica(j,4);
        d1 = (x11-x22)^2 + (y11-y22)^2;
        d2 = (x11-x32)^2 + (y11-y32)^2;
        d3 = (x21-x32)^2 + (y21-y32)^2;
        if d1 == 0 || d2 == 0
            if isempty(find(overlapingPointX == irisSetosa(i,1)))
                overlapingPointX = [overlapingPointX irisSetosa(i,1)];
                overlapingPointY = [overlapingPointY irisSetosa(i,4)];
            else
                if isempty(find(overlapingPointY(find(overlapingPointX == irisSetosa(i,1))) == irisSetosa(i,4)))
                    overlapingPointX = [overlapingPointX irisSetosa(i,1)];
                    overlapingPointY = [overlapingPointY irisSetosa(i,4)];
                end
            end 
        end
        if d3 == 0
            if isempty(find(overlapingPointX == irisVersicolor(i,1)))
                overlapingPointX = [overlapingPointX irisVersicolor(i,1)];
                overlapingPointY = [overlapingPointY irisVersicolor(i,4)];
            else
                if isempty(find(overlapingPointY(find(overlapingPointX == irisVersicolor(i,1))) == irisVersicolor(i,4)))
                    overlapingPointX = [overlapingPointX irisVersicolor(i,1)];
                    overlapingPointY = [overlapingPointY irisVersicolor(i,4)];
                end
            end
        end
    end
end
disp(['Total overlapping data points for petal width vs sepal length is : ' num2str(length(overlapingPointX))])

plot(overlapingPointX, overlapingPointY, '*k');
legend('Iris Setosa', ' Iris Versicolor', 'Iris Verginica', 'Overlap dataPoint')





%% plot Fisher's Iris data with petal length versus sepal width
figure;
plot(irisSetosa(:,2), irisSetosa(:,3), 'or'); hold on;
plot(irisVersicolor(:,2), irisVersicolor(:,3), '>c'); hold on;
plot(irisVerginica(:,2), irisVerginica(:,3), '^b'); hold on;

axis([min([min(irisSetosa(:,2)),min(irisVersicolor(:,2)),min(irisVerginica(:,2))])-1 ...
    max([max(irisSetosa(:,2)),max(irisVersicolor(:,2)),max(irisVerginica(:,2))])+1 ...
    min([min(irisSetosa(:,3)),min(irisVersicolor(:,3)),min(irisVerginica(:,3))])-1 ...
    max([max(irisSetosa(:,3)), max(irisVersicolor(:,3)),max(irisVerginica(:,3))])+1]);

title('petal length vs sepal width');
xlabel('sepal width');
ylabel('petal length');
legend('Iris Setosa', ' Iris Versicolor', 'Iris Verginica','AutoUpdate','off');






%% plot overlap symbol (*)
overlapingPointX = [];
overlapingPointY = [];
for i=1:length(irisSetosa(:,2))
    x11 = irisSetosa(i,2);
    y11 = irisSetosa(i,3);
    x21 = irisVersicolor(i,2);
    y21 = irisVersicolor(i,3);
    for j=1:length(irisSetosa(:,2))
        x22 = irisVersicolor(j,2);
        y22 = irisVersicolor(j,3);
        x32 = irisVerginica(j,2);
        y32 = irisVerginica(j,3);
        d1 = (x11-x22)^2 + (y11-y22)^2;
        d2 = (x11-x32)^2 + (y11-y32)^2;
        d3 = (x21-x32)^2 + (y21-y32)^2;
        if d1 == 0 || d2 == 0
            if isempty(find(overlapingPointX == irisSetosa(i,2)))
                overlapingPointX = [overlapingPointX irisSetosa(i,2)];
                overlapingPointY = [overlapingPointY irisSetosa(i,3)];
            else
                if isempty(find(overlapingPointY(find(overlapingPointX == irisSetosa(i,2))) == irisSetosa(i,3)))
                    overlapingPointX = [overlapingPointX irisSetosa(i,2)];
                    overlapingPointY = [overlapingPointY irisSetosa(i,3)];
                end
            end
        end
        if d3 == 0
            if isempty(find(overlapingPointX == irisVersicolor(i,2)))
                overlapingPointX = [overlapingPointX irisVersicolor(i,2)];
                overlapingPointY = [overlapingPointY irisVersicolor(i,3)];
            else
                if isempty(find(overlapingPointY(find(overlapingPointX == irisVersicolor(i,2))) == irisVersicolor(i,3)))
                    overlapingPointX = [overlapingPointX irisVersicolor(i,2)];
                    overlapingPointY = [overlapingPointY irisVersicolor(i,3)];
                end
            end
        end
    end
end


disp(['Total overlapping data points for petal length vs sepal width is : ' num2str(length(overlapingPointX))])

plot(overlapingPointX, overlapingPointY, '*k');
legend('Iris Setosa', ' Iris Versicolor', 'Iris Verginica', 'Overlap dataPoint')

