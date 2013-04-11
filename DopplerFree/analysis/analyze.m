%% Startup
res='n';
setup

clear res

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

sumData=da{42};  % init
sumData.name = 'sumData (indices 42:55)';

for i = 43:55
  if da{i}.time(1) == da{42}.time(1)
    sumData.up = sumData.up + da{i}.up;
    sumData.bal = sumData.bal + da{i}.bal;
    sumData.fp = sumData.fp + da{i}.fp;
    sumData.p = sumData.p + da{i}.p;
  end
end

sumData.up=sumData.up/14;
sumData.bal=sumData.bal/14;
sumData.fp=sumData.fp/14;
sumData.p=sumData.p/14;

figure()
bfpPlot(sumData)

figure()
bfpPlot(da{42})


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

% m values added
z(:,2) = [0;...
          0;...
          0;...
          1;...
          %
          7;...
          8;...
          8;...
          9;...
          9;...
          %
          32;...
          33;...
          33;...
          33;...
          33;...
          33;...
          %
          39;...
          40;...
          40;...
          41;...
          41];
      
% convert arcsin into freq diffs

z(:,1) = (-1).^(z(:,2)+1).*z(:,1)+(z(:,2)+1/2)*pi; % convert arcsin into phase diffs
z(:,1) = z(:,1)/(2*pi); % convert phase diffs to wavenumbers
z(:,1) = z(:,1)-z(1,1); % normalize to first peak

L_fp = 0.4655;  % length of FP
uncert_L_fp = 0.005;  % uncert in length of FP

c = 2.998*10^8;  % speed of light
n_air = 1.000277;  % refractive index of air

fsr = c/(2*n_air*L_fp); % calculate free spectral range of FP

z(:,3) = z(:,1)*fsr;  % get frequencies
z(:,3) = z(:,3)/10^9; % convert to GHz

z(:,4) = [0; diff(z(:,3))];  % get freq diffs in GHz

z(:,5) = [0; diff(z(:,1))]; % wavenum diffs


[pks, locs] = findpeaks(abs(smooth(da{68}.fp,10)),'minpeakdistance',75);
figure()
plot(da{68}.fp,'.')
line([locs locs],[-0.34 -0.31])
%% clear
clear L_fp uncert_L_fp c n_air fsr x y z pks locs


   
   %% Visualization of Error from Voltage Resolution of FP
   figure
   plot(-1:.1:1,asin(-1:.1:1),'.')
   xlabel('Points that can be resolved')
   ylabel('angle that can be resolved')
   
   
%% clear shit

clear i j