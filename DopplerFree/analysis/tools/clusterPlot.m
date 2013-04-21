function bananas = clusterPlot(cluster,index,da,peak)

j=index;

if j==1
    x = 3.325760e-02;
    T = 4e-5;
    what = -490;
else
    x = 0;
    T = 1; % sets abs val of peak  1 location to 0. i.e. just returns relative shifts again
    what = 0;
end
if j==2
    x = 7.300000e-02;
    T = 4e-5;
    what = -185;
end
if j==3
    x = 7.575431e-02;
    T = 8e-5;
    what = -710;
end
if j==4
    x = 8.690000e-02;
    T = 4e-5;
    what = -1602;
end

data = da{cluster{j}.avgFile}.bal(cluster{j}.domain);
fit = cluster{j}.yfit;

% lower = min(fit);
% upper = max(fit);
% lower = 0.14;
% upper = 0.23;
lower = -0.02;
upper = 0.16;

peaks = cluster{j}.shifts; % peak shifts

peaks = peaks + x*cluster{j}.afit(2)/T; % abs val of peak 1 location
peaks = peaks + what; % i have no idea why this is necessary but it is

hold all
plot(data,'.','MarkerSize',5.0)
plot(fit,'black','LineWidth',2.0)
axis([0 1200 lower upper])

% for i=1:max(size(peaks))
% line([peaks(i) peaks(i)],[lower upper],'Color','r')
% if i >= 2 && i<=6
% text((peaks(i)+peaks(i-1))/2-210, (upper-lower)*0.75+lower, [num2str(10^3*peak.shiftsDiff(i),4) 'MHz'],...
%     'FontSize',16.0)
% end
% end

i=1;
line([peaks(i) peaks(i)],[lower upper],'Color','r')
i=2;
line([mean([peaks(i),peaks(i+1)]) mean([peaks(i),peaks(i+1)])],[lower upper],'Color','r')
text((peaks(i)+peaks(i-1))/2-45, (upper-lower)*0.75+lower, [num2str(10^3*(peak.shiftsDiff(i)+peak.shiftsDiff(i+1)/2),4) 'MHz'],...
    'FontSize',16.0)
text((peaks(i+1)+peaks(i+2))/2-45, (upper-lower)*0.75+lower, [num2str(10^3*(peak.shiftsDiff(i+1)/2+peak.shiftsDiff(i+2)),4) 'MHz'],...
    'FontSize',16.0)
i=4;
line([mean([peaks(i),peaks(i+1)]) mean([peaks(i),peaks(i+1)])],[lower upper],'Color','r')

kraut = 0.008;
franco = 10;
i=1;
text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$\nu_3$','FontSize',16.0)
i=2;
text(mean([peaks(i),peaks(i+1)])+franco, data(round(mean([peaks(i),peaks(i+1)])))+kraut, '$\nu_2$','FontSize',16.0)
i=4;
text(mean([peaks(i),peaks(i+1)])+franco, data(round(mean([peaks(i),peaks(i+1)])))+kraut, '$\nu_1$','FontSize',16.0)

% kraut = 0.004;
% franco = 10;
% i=1;
% text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$\nu_3$','FontSize',16.0)
% i=2;
% text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$(\nu_3+\nu_2)/2$','FontSize',16.0)
% i=3;
% text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$(\nu_3+\nu_1)/2$','FontSize',16.0)
% i=4;
% text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$\nu_2$','FontSize',16.0)
% i=5;
% text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$(\nu_2+\nu_1)/2$','FontSize',16.0)
% i=6;
% text(peaks(i)+franco, data(round(peaks(i)))+kraut, '$\nu_1$','FontSize',16.0)


legend({'Balanced photodiode output [V]'; 'Lorentzian fits'},'Interpreter','tex','FontSize',14)
xlabel('Index','Interpreter','tex','FontSize',16)
ylabel('Intensity [V]','Interpreter','tex','FontSize',16)
title('Rb 85: Fitting Lorentzians to Lamb dips','FontSize',16)
%title('Rb 87: Fitting Lorentzians to Lamb dips','FontSize',16)


end