function [x,y]=loadData(fileName, tableName, cols)
%this function will load data from sqlite database fileName is the name of
%the sqlite file and tableName is the name of the table and cols are the array for which columns data should be extracted 

connection = sqlite(fileName, 'readonly');
tableData = fetch(connection, horzcat('SELECT * FROM ',tableName));
close(connection);

n = length(cols);
r = size(tableData,1);
x = zeros(r,n);

for i=1:n
 x(:,i) =  cell2mat(tableData(:,cols(i)));
end

y=0;

end