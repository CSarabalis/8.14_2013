%% Startup
%res='n'
%setup
clear res

%% look at raw data

% bal_indices are the indices of all the datasets with .bal data
% sc_indices are the indices of all the datasets with .sc data
% sc_test_indices are 71:72, a test of FP drift

%indices = 42:55;
indices = bal_indices;

for i=indices
    figure()
    bfpPlot(da,i)
end

clear i indices


%% input peak and FP data from raw

i=63;

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
    save('da.mat','da','data','bal_indices','sc_indices','sc_test_indices','home')
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

%% analysis of peaks and comparison with expected values

%% Rb87 analysis

Rb87.transitions = {'2-3';'1-2';'0-1'};
Rb87.freqs = [267; 157; 72]*10^(-3); % in GHz

avg61_62 = shiftsAvg(da, 61:62);
fu = avg61_62.shifts;

transFreqs87 = [2*(fu(3)-fu(1)); fu(6)-fu(3); fu(8)-fu(6)];

scaleFactor = transFreqs87./Rb87.freqs;
scaled_transFreqs87 = transFreqs87/mean(scaleFactor);

{'Meas (scaled) [MHz]' 'Expect [MHz]'}
[scaled_transFreqs87*1000 Rb87.freqs*1000] % in MHz

clear scaleFactor scaled_transFreqs87 transFreqs87 avg61_62 fu

%% Rb85 analysis

Rb85.transitions = {'3-4';'2-3';'1-2'};
Rb85.freqs = [121; 63; 29]*10^(-3); % in GHz

avg42_43 = shiftsAvg(da, 42:43);
fu = avg42_43.shifts

transFreqs85 = [2*(fu(3)-fu(1)); fu(6)-fu(3); fu(8)-fu(6)];

scaleFactor = transFreqs85./Rb85.freqs;
scaled_transFreqs85 = transFreqs85/mean(scaleFactor);

{'Meas (scaled) [MHz]' 'Expect [MHz]'}
[scaled_transFreqs85*1000 Rb85.freqs*1000] % in MHz

clear scaleFactor scaled_transFreqs85 transFreqs85 avg61_62 fu
















