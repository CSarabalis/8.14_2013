%% init & get data
peaks = cell(73);

data = longscan1;

for i=1:73
    peaks{i} = data(i);
end

%% get peaks mang

% go through each file, put cursor on peak, get cursor info, store in peaks
% then plot lon vs peak freq
% woo!
i=73;

roughPlot(data,i)
%%
peaks = storeCursorInfo(peaks,i,cursor_info);






%%
x=[];
for i=1:73
    x = [x; peaks{i}.glon peaks{i}.peakPositions(1)];
end

x(:,2) = x(:,2)-1420.4;

figure()
plot(x(:,1),x(:,2),'.')
xlabel('Galactic longitude', 'Interpreter','tex')
ylabel('Doppler shift [MHz]','Interpreter','tex')
title('Doppler shift of the 21cm line across the galaxy')
text(165,-0.2,'Negative doppler shift means coming towards Earth')



