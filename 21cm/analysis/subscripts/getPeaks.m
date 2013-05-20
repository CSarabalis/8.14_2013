%% init & get data

data = [longscan1 longscan2 longscan3 longscan4 longscan5 longscan6 longscan7,...
 longscan8 longscan9];

peaks = cell(max(size(data)),1);

for i=1:size(peaks,1)
    peaks{i} = data(i);
    peaks{i}.vel = freq2vel(peaks{i}.freq) - peaks{i}.vlsr; % convert freqs to vels
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
clear i

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

clear i

%% auto-get peaks mang

for i=1:max(size(avgPeaks))
avgPeaks = storePeaks(avgPeaks,i);
end
% 
% for i=1:max(size(avgPeaks))
% figure()
% plot(avgPeaks{i}.vel, smooth3(avgPeaks{i}.counts,5),'.')
% title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
% xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
% ylabel('Counts','Interpreter','tex','FontSize',20)
% line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')
% for j=1:size(avgPeaks{i}.P,1)
% line([avgPeaks{i}.P(j,2) avgPeaks{i}.P(j,2)], [0 10], 'Color', 'g')
% end
% end

clear i


%% plot glon vs peaks to see structure!

glonVsPeakVel = [];

for i=1:max(size(avgPeaks))
for j=1:size(avgPeaks{i}.P,1)
glonVsPeakVel = [glonVsPeakVel; avgPeaks{i}.glon avgPeaks{i}.P(j,2)];
end
end

figure()
errorbar(glonVsPeakVel(:,1), glonVsPeakVel(:,2),glonVsPeakVel(:,2)*0+1,'.')
title('Receding Velocity of major peaks in power spectrum at various Glon','FontSize',20)
xlabel('Galactic longitude [deg]','Interpreter','tex','FontSize',20)
ylabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
line([0 250],[0 0],'Color','r')

clear i j

%% get Vmax's (manually cos you a sucka)

% go through each file, put cursor on peak, get cursor info, store in peaks
% then plot lon vs peak freq
% woo!
VmaxIndices = [];

for i=1:max(size(avgPeaks))
if avgPeaks{i}.glon < 95

%plot
figure()
plot(avgPeaks{i}.vel, smooth3(avgPeaks{i}.counts,5),'.')
title(['Glon = ' num2str(avgPeaks{i}.glon) ', n = ' num2str(avgPeaks{i}.n)],'FontSize',20)
xlabel('Receding velocity [km/sec]','Interpreter','tex','FontSize',20)
ylabel('Counts','Interpreter','tex','FontSize',20)
line([avgPeaks{i}.vel(1) avgPeaks{i}.vel(end)],[0 0],'Color','r')
for j=1:size(avgPeaks{i}.P,1)
line([avgPeaks{i}.P(j,2) avgPeaks{i}.P(j,2)], [0 10], 'Color', 'g')
end
%

[x, y] = ginput(1);

avgPeaks{i}.Vmax = x;

VmaxIndices = [VmaxIndices i];

end

end

clear x y j i


%% rotation curve

% VmaxIndices=[];
% for i=1:max(size(avgPeaks))
% if avgPeaks{i}.glon < 95
% VmaxIndices=[VmaxIndices i];
% end
% end

load('goodRotCurve.mat')

vSun = 220; %km/sec
rSun = 8.5; %kiloparsecs (kpc)
R = [];
V = [];
for i=VmaxIndices
glonRad = avgPeaks{i}.glon/360*2*pi;
r = rSun*sin(glonRad);
v = avgPeaks{i}.Vmax + vSun*sin(glonRad);
R=[R; r];
V=[V; v];
end

a0 = [67.76 50.06 -4.0448 0.0861];
Tr = @(r) (a0(1) + a0(2)*r + a0(3)*r.^2 + a0(4)*r.^3);
TrLM = @(r,a) a(1) + a(2)*r + a(3)*r.^2 + a(4)*r.^3;
err = V*0+5;
[a,aerr,chisq,yfit,corr] = levmar(R,V,err,TrLM,a0,0,0)

chi2 = sum((V-Tr(R)).^2./V);
chi2nu = chi2/(max(size(V))-1);

figure()
errorbar(R,V,V*0+10,'.','MarkerSize',20)
title('Rotation curve of the Milky Way with cubic model','FontSize',20)
xlabel('Radius from galactic center [kpc]','Interpreter','tex','FontSize',20)
ylabel('Orbital velocity [km/sec]','Interpreter','tex','FontSize',20)
hold all
r = [0:0.01:9];
plot(r,Tr(r),'r')
text(2.4,110,{'$V = a_1 + a_2 R + a_3 R^2 + a_4 R^3$',...
    ['$a_1 =$ ' num2str(a0(1)) ', $a_2 =$ ' num2str(a0(2)) ', $a_3 =$ ' num2str(a0(3)) ', $a_4 =$ ' num2str(a0(4))],...
    ['$\chi^2_{\nu} =$ ' num2str(chi2nu)]},'FontSize',20)

figure()
errorbar(R,V,err,'.','MarkerSize',20)
title('Rotation curve of the Milky Way with cubic model Lev-Mar','FontSize',20)
xlabel('Radius from galactic center [kpc]','Interpreter','tex','FontSize',20)
ylabel('Orbital velocity [km/sec]','Interpreter','tex','FontSize',20)
hold all
r = [0:0.01:9];
plot(r,TrLM(r,a),'r')
text(2.4,110,{'$V = a_1 + a_2 R + a_3 R^2 + a_4 R^3$',...
    ['$a_1 =$ ' num2str(a(1)) ', $a_2 =$ ' num2str(a(2)) ', $a_3 =$ ' num2str(a(3)) ', $a_4 =$ ' num2str(a(4))],...
    ['$\chi^2_{\nu} =$ ' num2str(chisq/max(size(V)))]},'FontSize',20)


clear vSun rSun glonRad R V r v i


%% map spiral arms

vSun = 220; %km/sec
rSun = 8.5; %kiloparsecs (kpc)

spirals = [];

for i=1:max(size(avgPeaks))
if avgPeaks{i}.glon > 95
%a = [67.76 50.06 -4.0448 0.0861]*0.868;
glon = avgPeaks{i}.glon*2*pi/360;
for j = size(avgPeaks{i}.P,1)
Vp = avgPeaks{i}.P(j,2);
Tr = @(r) (a(1) + a(2)*r + a(3)*r.^2 + a(4)*r.^3)*(rSun*glon)/(Vp+vSun*glon)-r;
R = fzero(Tr,9);
%phi = acos(rSun*sin(glon*(2*pi/360))/R);
phim = acos(rSun/R*sin(glon)^2 - cos(glon)*sqrt(1-(rSun*sin(glon)/R)^2));
phip = acos(rSun/R*sin(glon)^2 + cos(glon)*sqrt(1-(rSun*sin(glon)/R)^2));
X = rSun/R;
if 0<glon && glon<3.14
    phim1 = asin(X*sin(glon))-glon;
end
if 3.14<glon && glon<6.29
    glonQ = 2*pi - glon;
    phim1 = -1*(asin(X*sin(glon))-glon);
end
%phip1 = abs(asec((X.*tan(glon)+sec(glon).*(X+1).^-0.5)./(X-1)));
spirals = [spirals; glon*360/(2*pi) R phim1 phip];
end
end
end
%C = @(Vp, glon) (Vp+vSun*glon*(2*pi/360))/(rSun*glon*(2*pi/360));
spirals(:,[1,3])

figure()
errorbar(spirals(:,1),spirals(:,2),spirals(:,2)*0+0.2,'.')
title('Spiral arms of the Milky Way','FontSize',20)
xlabel('Galactic longitude','Interpreter','tex','FontSize',20)
ylabel('Radius from galactic center [kpc]','Interpreter','tex','FontSize',20)

figure()
polar(-1*spirals(:,3),spirals(:,2),'b.')
hold all
polar(-1*spirals(:,4),spirals(:,2),'r.')
polar([0],[8.5],'MarkerSize',20)
figure()
polar(spirals(:,1)*2*pi/360,spirals(:,2),'.')



clear vSun rSun i j a glon glonRad Tr Vp

%% clearing
 
clear peaks spirals glonVsPeakVel R V VmaxIndices killIndices weirdSlopeyData

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



