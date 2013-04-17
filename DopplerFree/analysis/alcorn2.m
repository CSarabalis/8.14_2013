%% Startup
res='n'
setup
clear res

%% indexImport new data

% new_range = 79:87;
% 
% for i=new_range
%     da{i} = indexImport(i);
% end

new_range = 88:91;

for i=new_range
    da{i} = indexImport2(i);
end

clear i new_range


%% input peak and FP data from raw

i=91;

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

clear i

%% save your work from above
saveQ = 'y';

if saveQ == 'y'
    save('da.mat','da','data','bal_indices','sc_indices','sc_test_indices','home')
end

clear i saveQ

%% decide which peaks are which

FP_len = 0.3216; %GHz
peakDecide % needs to be replaced with peakDecideLorentzian which uses the data from Chris's lorentzian fits
clear FP_len

%% model testing

modelTesting % in subscripts



%% calculate A + B

% calculated using ACEF model from combination of peaks 1 + 4. I.E. kind of
% bullshit

% Rb87
A87 = [];
B87 = [];
% 3-2, 2-1
dum = inv([[getCoeffs(3,87)]; [getCoeffs(2,87)]])*10^3*[peak4.A(1); peak4.A(2)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];
% 2-1, 1-0
dum = inv([[getCoeffs(2,87)]; [getCoeffs(1,87)]])*10^3*[peak4.A(2); peak1.A(3)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];
% 3-2, 1-0
dum = inv([[getCoeffs(3,87)]; [getCoeffs(1,87)]])*10^3*[peak4.A(1); peak1.A(3)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];

% Rb87 error propagation
A87u = [];
B87u = [];
% 3-2, 2-1
dum = inv([[getCoeffs(3,87)]; [getCoeffs(2,87)]])*10^3*[peak4.Au(1); peak4.Au(2)];
A87u = [A87u; dum(1)];
B87u = [B87u; dum(2)];
% 2-1, 1-0
dum = inv([[getCoeffs(2,87)]; [getCoeffs(1,87)]])*10^3*[peak4.Au(2); peak1.Au(3)];
A87u = [A87u; dum(1)];
B87u = [B87u; dum(2)];
% 3-2, 1-0
dum = inv([[getCoeffs(3,87)]; [getCoeffs(1,87)]])*10^3*[peak4.Au(1); peak1.Au(3)];
A87u = [A87u; dum(1)];
B87u = [B87u; dum(2)];

A87 = [A87 abs(A87u)];
B87 = [B87 abs(B87u)];


% Rb85
% 3-2, 2-1
dum = inv([[getCoeffs(3,85)]; [getCoeffs(2,85)]])*10^3*[peak3.C(1); peak2.C(1)];
A85 = dum(1);
B85 = dum(2);

% Rb85 error propagation
% 3-2, 2-1
dum = inv([[getCoeffs(3,85)]; [getCoeffs(2,85)]])*10^3*[peak3.Cu(1); peak2.Cu(1)];
A85u = dum(1);
B85u = dum(2);

A85 = [A85 abs(A85u)];
B85 = [B85 abs(B85u)];

clear dum



%% vary FP length and compute pvals for each model

modelPs = [];

for FP_len = [0:1:500]*10^-3;

dummy_da = da;
for j = [79 82 84 86];
    dummy_da = getShifts(dummy_da,j,FP_len);
end

peakDecide;
modelTesting;

modelPs = [modelPs; FP_len peak1.Ap peak1.Bp peak2.Cp peak3.Cp peak4.Ap peak4.Bp];

end

figure()
for j=2:7
hold all
plot(modelPs(:,1), modelPs(:,j),'.')
end
legend('Peak 1 ACEF model','Peak 1 ABC model','Peak 2','Peak 3','Peak 4 ACEF model','Peak 4 ABC model')
xlabel('Fabry-Perot length [m]','Interpreter','tex')
ylabel('P-value [normed]','Interpreter','tex')
title('Calibrating Fabry-Perot length')


clear j FP_len modelPs dummy_da


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

%% fabry-perot ffts

dummy = [];

for i=90
    figure()
    dummy = [dummy fftPlot(da,i)];
end

clear i

%% find peaks

i=80;
%plots the peaks overlaid with the calculated shifts. for reference
figure()
findPeaks(da,i)

clear i

%% Rb87 analysis

Rb87.transitions = {'2-3';'1-2';'0-1'};
Rb87.freqs = [267; 157; 72]*10^(-3); % in GHz

avg61_62 = shiftsAvg(da, 61:62);
fu = avg61_62.shifts;

transFreqs87 = [2*(fu(3)-fu(1)); fu(6)-fu(3); fu(8)-fu(6)]

scaleFactor = transFreqs87./Rb87.freqs;
scaled_transFreqs87 = transFreqs87/mean(scaleFactor);

{'Meas (scaled) [MHz]' 'Expect [MHz]'}
[scaled_transFreqs87*1000 Rb87.freqs*1000] % in MHz

clear scaleFactor scaled_transFreqs87 transFreqs87 avg61_62 fu

%% Rb85 analysis

Rb85.transitions = {'3-4';'2-3';'1-2'};
Rb85.freqs = [121; 63; 29]*10^(-3); % in GHz

%avg42_43 = shiftsAvg(da, 42:43);
%fu = avg42_43.shifts;

fu = da{20}.shifts;

% transFreqs85 = [1*(fu(5)-fu(3)); fu(3)-fu(2); fu(2)-fu(1)];
transFreqs85 = [1*(fu(3)-fu(1)); fu(4)-fu(3); fu(5)-fu(4)];

scaleFactor = transFreqs85./Rb85.freqs;
scaled_transFreqs85 = transFreqs85/mean(scaleFactor);

{'Meas (scaled) [MHz]' 'Expect [MHz]'}
[scaled_transFreqs85*1000 Rb85.freqs*1000] % in MHz

clear scaleFactor scaled_transFreqs85 transFreqs85 avg42_43 fu








