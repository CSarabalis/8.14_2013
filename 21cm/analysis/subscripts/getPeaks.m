%% init & get data

data = [longscan1 longscan2 longscan3 longscan4 longscan5 longscan6 longscan7,...
 longscan8 longscan9];

peaks = cell(max(size(data)),1);

for i=1:size(peaks,1)
    peaks{i} = data(i);
    peaks{i}.vel = freq2vel(peaks{i}.freq); % convert freqs to vels
end

clear i data

%% average same glon

avgPeaks = avgDataGlon(peaks);

% for i=1:max(size(avgPeaks))
%     figure()
%     plot(avgPeaks{i}.vel, avgPeaks{i}.counts,'.')
%     title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
%     xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
%     ylabel('Counts','Interpreter','tex','FontSize',20)
% end


clear i

%% trim data

for i=1:max(size(avgPeaks))
avgPeaks = trimData(avgPeaks,i);
end

% for i=1:max(size(avgPeaks))
%     figure()
%     plot(avgPeaks{i}.vel, avgPeaks{i}.counts,'.')
%     title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
%     xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
%     ylabel('Counts','Interpreter','tex','FontSize',20)
% end

clear i

%% remove baseline

for i=1:max(size(avgPeaks))
avgPeaks = removeBaseline(avgPeaks,i,1/2);
end

% for i=1:max(size(avgPeaks))
%     figure()
%     plot(avgPeaks{i}.vel, avgPeaks{i}.counts,'.')
%     title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
%     xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
%     ylabel('Counts','Interpreter','tex','FontSize',20)
%     line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')
% end
% 
% clear i

%% smoothing

span = 5;

for i=1:max(size(avgPeaks))
    figure()
    plot(avgPeaks{i}.vel, smooth3(avgPeaks{i}.counts,span),'.')
    title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
    xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
    ylabel('Counts','Interpreter','tex','FontSize',20)
    line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')
end

clear i span

%% cut the nonsense (when counts is just NaN)
killIndices = [];
for i=1:max(size(avgPeaks))
if size(avgPeaks{i}.counts,1)==1
killIndices = [killIndices i];
end
end

avgPeaks(killIndices) = [];

weirdSlopeyData = [36:47];
avgPeaks(weirdSlopeyData) = [];

%% auto-get peaks mang

for i=1:max(size(avgPeaks))
avgPeaks = storePeaks(avgPeaks,i);
end

for i=1:max(size(avgPeaks))
figure()
plot(avgPeaks{i}.vel, smooth3(avgPeaks{i}.counts,5),'.')
title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
ylabel('Counts','Interpreter','tex','FontSize',20)
line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')
for j=1:size(avgPeaks{i}.P,1)
line([avgPeaks{i}.P(j,2) avgPeaks{i}.P(j,2)], [0 10], 'Color', 'g')
end
end

% %% get peaks mang
% 
% % go through each file, put cursor on peak, get cursor info, store in peaks
% % then plot lon vs peak freq
% % woo!
% i=13; % maxi=21
% 
% span = 5;
% figure()
% plot(avgPeaks{i}.vel, smooth(avgPeaks{i}.counts,span),'.')
% title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
% xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
% ylabel('Counts','Interpreter','tex','FontSize',20)
% line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')
% 
% %%
% avgPeaks = storeCursorInfo(avgPeaks,i,cursor_info);



%% plot glon vs peaks to see structure!

glonVsPeakVel = [];

for i=1:max(size(avgPeaks))
for j=1:size(avgPeaks{i}.P,1)
glonVsPeakVel = [glonVsPeakVel; avgPeaks{i}.glon avgPeaks{i}.P(j,2)];
end
end

plot(glonVsPeakVel(:,1), glonVsPeakVel(:,2),'.')
title('Receding Velocity of major structures in power spectrum at various Glon','FontSize',20)
xlabel('Glon [deg]','Interpreter','tex','FontSize',20)
ylabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)

clear i j

%% get Vmax's (manually cos you a sucka)

% go through each file, put cursor on peak, get cursor info, store in peaks
% then plot lon vs peak freq
% woo!
i=1; % maxi=21

span = 5;
figure()
plot(avgPeaks{i}.vel, smooth(avgPeaks{i}.counts,span),'.')
title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
ylabel('Counts','Interpreter','tex','FontSize',20)
line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')


%%
avgPeaks = VmaxstoreCursorInfo(avgPeaks,i,cursor_info);

%% rotation curve

i=1;

vSun = 220; %km/sec
rSun = 8.5; %kiloparsecs (kpc)

r = rSun*sin(avgPeaks{i}.glon);
v = avgPeaks{i}.VmaxPositions(1) + vSun*sin(avgPeaks{i}.glon);





%% calculate v_receding from earth

% x=[];
% for i=1:73
%     x = [x; peaks{i}.glon peaks{i}.peakPositions(1)];
% end
% 
% x(:,2) = freq2vel(x(:,2));
% 
% figure()
% plot(x(:,1),x(:,2),'.')
% xlabel('Galactic longitude', 'Interpreter','tex','FontSize',20)
% ylabel('Veloctiy rel. to LSR (receding) [km/sec]','Interpreter','tex','FontSize',20)
% title('Doppler shift of the 21cm line across the galaxy','FontSize',20)
% text(165,0.05,'Negative doppler shift means coming towards Earth','FontSize',20)



%%



