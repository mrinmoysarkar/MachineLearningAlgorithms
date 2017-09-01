close all;

fileName = 'C:\Users\msarkar\dataSet\1. Northwest diagonal area, tarp found and confirmed\custd.sqlite3';
tableName = 'mavlink_scaled_imu2';

%row no. of the variable in the database table
zacc = 6;
xacc = 12;
yacc = 8;
timeStamp = 7;

cols = [zacc xacc yacc timeStamp];

[x1,y] = loadData(fileName, tableName, cols);

figure;
plot(x1(:,4),x1(:,1),'r');hold on;
plot(x1(:,4),x1(:,2),'g');
plot(x1(:,4),x1(:,3),'b');
legend('zacc','xacc','yacc')

tableName = 'mavlink_attitude';
%row no. of the variable in the database table
pitchSpeed = 2;
pitch = 6;
yawSpeed = 8;
yaw = 3;
rollSpeed = 4;
roll = 9;
timeStamp = 5;

cols = [pitchSpeed pitch yawSpeed yaw rollSpeed roll timeStamp];

[x2,y] = loadData(fileName, tableName, cols);