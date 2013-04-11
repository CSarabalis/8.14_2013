%% Startup
%res='n'
%setup
clear res

%% input peak and FP data from raw

i=43;

% first plot up some data
figure()
bfpPlot(da,i)

% then place a cursor on top of every peak (manually do this)
% right-click and export the cursor data to the workspace, save the
% variable as cursor_info
%% break while user inputs cursor_info
% then run storeCursorInfo
da = storeCursorInfo(da,i,cursor_info);

% then select the maxs and mins of the FP output. Start with the first FP max to
% the left of the first BAL peak. This is for the asin step.
da = getOrders(da,i);

% then run the getShifts calculation
da = getShifts(da,i);

%% save your work from above
saveQ = 'y';

if saveQ == 'y'
    save('da.mat','da','data','data_indices','home')
end

clear i saveQ

%% fabry-perot ffts

for i=data_indices(68:end)
    figure()
    fftPlot(da,i)
end

clear i

%% find peaks

i=43;
%plots the peaks overlaid with the calculated shifts. for reference
figure()
findPeaks(da,43)

clear i





