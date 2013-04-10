%% Startup

home = pwd;  %save current path in analysis
addpath([home,'/tools'])
addpath([home,'/subscripts'])

% grab the data
cd ../data/
data = cjsImport('csv',',',2);
cd(home)

%% Visualize

for i = 71:length(data)
    figure
    hold on
    for j = 2:size(data{i}.data,2)
       plot(data{i}.data(:,1),data{i}.data(:,j),'.')
    end
    title(['Data set: ',num2str(i)])
    xlabel('Time [s]')
    ylabel('Voltage [V]')
end

%% Summed Data

for i = 43:55
  if data{i}.data(1,1) == data{42}.data(1,1)
    sumData = sumData + data{i}.data;
  end
end

%% Peak Splittings for 68,69

%plot lamb dips and FP
subplot(2,1,1)
hold on
plot(data{68}.data(:,1),data{68}.data(:,3),'.')
xlabel('Time [s]')
ylabel('Pumped-Unpumped [V]')

subplot(2,1,2)
hold on
plot(data{68}.data(:,1),data{68}.data(:,4),'.')
xlabel('Time [s]')
ylabel('Fabry-Perot')

%Peak centers determined by maximum of lamb dips
% x = [Center [s], Left Error [s], Right Error [s]]
x = [0.4178,0.0003,0.0003;...
     0.4307,0.0006,0.0006;...
     0.4371,0.0006,0.0006;...
     0.4494,0.0015,0.0015;...
     %
     0.6469,0.0003,0.0003;...
     0.6727,0.0003,0.0003;...
     0.6882,0.0003,0.0003;...
     0.7011,0.0015,0.0015;...
     0.7140,0.0006,0.0006;...
     %
     %Insert cluster three here
     %
     1.37285,0.0003,0.0003;...
     1.38165,0.0003,0.0003;...
     1.3846,0.0003,0.0003;...
     1.3863,0.0003,0.0006;...
     1.3890,0.0003,0.0003;...
     1.3992,0.0009,0.0009;...
     %
     1.5539,0.0003,0.0003;...
     1.5735,0.0003,0.0003;...
     1.5765,0.0003,0.0003;...
     1.5864,0.0003,0.0003;...
     1.5885,0.0003,0.0003;...
     1.5885,0.0009,0.0009];
   
%Get the indices and put them in col 4

for i = 1:length(x)
[~,x(i,4)] = min(abs(data{68}.data(:,1)-x(i,1)));
end

%Get the FP values and put then in col 5

x(:,5) = data{68}.data(x(:,4),4);



   %mark on graphs
   %difference
   subplot(2,1,1)
   for i = 1:length(x)
     line([x(i,1),x(i,1)],[0, 0.4])
   end
   %FP
   subplot(2,1,2)
   for i = 1:length(x)
     line([x(i,1),x(i,1)],[-.33, -.31])
   end
   
   % Sinusoid data for peak 
   % y = [min [V], max [V]]
   y =[-0.3300,-0.3110;...
       -0.3300,-0.3110;...
       -0.3300,-0.3110;...
       -0.3300,-0.3110;...
       %
       -0.3300,-0.3110;...
       -0.3300,-0.3110;...
       -0.3300,-0.3110;...
       -0.3300,-0.3110;...
       -0.3300,-0.3110;...
       %Peak 3 here
       -0.3320,-0.3100;...
       -0.3320,-0.3100;...
       -0.3320,-0.3100;...
       -0.3320,-0.3100;...
       -0.3320,-0.3100;...
       -0.3320,-0.3100;...
       %
       -0.3330,-0.3100;...
       -0.3330,-0.3100;...
       -0.3330,-0.3100;...
       -0.3330,-0.3100;...
       -0.3330,-0.3100];

%offset
y(:,3) = mean(y')';
%amplitude
y(:,4) = (y(:,2) - y(:,1))/2;

z = asin((x(:,5)-y(:,3))./y(:,4));
   
   %% Visualization of Error from Voltage Resolution of FP
   figure
   plot(-1:.1:1,asin(-1:.1:1),'.')
   xlabel('Points that can be resolved')
   ylabel('angle that can be resolved')