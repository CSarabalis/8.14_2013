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

%% save your work from above
saveQ = 'y';

if saveQ == 'y'
    save('da.mat','da','data','bal_indices','sc_indices','sc_test_indices','home')
end

clear i saveQ

%% decide which peaks are which

peak1=struct;
peak1.shifts = da{79}.shifts;
peak1.shiftsDiff = [0;diff(peak1.shifts)];
peak1.uncerts = (1/(2*pi))*[0 0.086 0.0015; %uncert in peak, uncert in sin params (fp res), uncert in fp res
    0 0.1314 0.0015;
    0.0641 0.0081 0.0005;
    0 0.0571 0.0010;
    0.2773 0.0332 0.0005;
    0.3612 0.0888 0.0014];
peak1.uncerts = (peak1.uncerts(:,1).^2 + peak1.uncerts(:,2).^2 + peak1.uncerts(:,3).^2).^(0.5);
peak1.uncerts = 0.321*peak1.uncerts;

peak4=struct;
peak4.shifts = da{86}.shifts;
peak4.shiftsDiff = [0;diff(peak4.shifts)];
peak4.uncerts = (1/(2*pi))*[0.113 0.0059 0.0006;
    0 0.0002 0.0005;
    0 0.0012 0.0005;
    0 0 0;
    0.092 0.0068 0.0006;
    0 0.0092 0.0007;
    0 0 0];
peak4.uncerts = (peak4.uncerts(:,1).^2 + peak4.uncerts(:,2).^2 + peak4.uncerts(:,3).^2).^(0.5);
peak4.uncerts = 0.321*peak4.uncerts;

peak3=struct;
peak3.shifts = da{84}.shifts;
peak3.shiftsDiff = [0;diff(peak3.shifts)];
peak3.uncerts = (1/(2*pi))*[0.047 0.0124 0.0005;
    0.0397 0.005 0.0005;
    0.0479 0.0143 0.0006];
peak3.uncerts = (peak3.uncerts(:,1).^2 + peak3.uncerts(:,2).^2 + peak3.uncerts(:,3).^2).^(0.5);
peak3.uncerts = 0.321*peak3.uncerts;

peak2=struct;
peak2.shifts = da{82}.shifts;
peak2.shiftsDiff = [0;diff(peak2.shifts)];
peak2.uncerts = (1/(2*pi))*[0.1387 0.0277 0.0009;
    0 0.0023 0.0005;
    0.047 0.01 0.0005];
peak2.uncerts = (peak2.uncerts(:,1).^2 + peak2.uncerts(:,2).^2 + peak2.uncerts(:,3).^2).^(0.5);
peak2.uncerts = 0.3216*peak2.uncerts;


%% model testing

% A is the acef model
% B is the abc model


peak1.A = [peak1.shiftsDiff(2)+peak1.shiftsDiff(3);
    peak1.shiftsDiff(4)+peak1.shiftsDiff(5);
    peak1.shiftsDiff(6)];

peak1.Aexp = [0.2667; 0.1569; 0.0722];

peak1.Au = [peak1.uncerts(1)^2+peak1.uncerts(2)^2+peak1.uncerts(3)^2;
    peak1.uncerts(4)^2+peak1.uncerts(5)^2+peak1.uncerts(3)^2;
    peak1.uncerts(6)^2+peak1.uncerts(5)^2].^(0.5);

peak1.B = [peak1.shiftsDiff(2);
    peak1.shiftsDiff(3)];

peak1.Bexp = [0.1569; 0.0722];

peak1.Bu = [peak1.uncerts(1)^2+peak1.uncerts(2)^2;
    peak1.uncerts(1)^2+peak1.uncerts(2)^2].^0.5;



peak4.A = [peak4.shiftsDiff(2)+peak4.shiftsDiff(3);
    peak4.shiftsDiff(4)+peak4.shiftsDiff(5);
    peak4.shiftsDiff(6)];

peak4.Aexp = peak1.Aexp;

peak4.Au = [peak4.uncerts(1)^2+peak4.uncerts(2)^2+peak4.uncerts(3)^2;
    peak4.uncerts(4)^2+peak4.uncerts(5)^2+peak4.uncerts(3)^2;
    peak4.uncerts(6)^2+peak4.uncerts(5)^2].^(0.5);

peak4.B = [peak4.shiftsDiff(2);
    peak4.shiftsDiff(3)];

peak4.Bexp = peak1.Bexp;

peak4.Bu = [peak4.uncerts(1)^2+peak4.uncerts(2)^2;
    peak4.uncerts(2)^2+peak4.uncerts(3)^2].^0.5;



peak2.C = peak2.shiftsDiff(4);

peak2.exp = [29.3]*10^-3;

peak2.Cu = [peak2.uncerts(3)^2+peak2.uncerts(2)^2].^0.5;


peak3.C = peak3.shiftsDiff([2 3]);

peak3.exp = [63.4; 29.3]*10^-3;

peak3.Cu = [peak3.uncerts(2)^2+peak3.uncerts(1)^2;
    peak3.uncerts(2)^2+peak3.uncerts(3)^2].^0.5;
    


% evaluate p-values

overallP = cdf(gmdistribution([peak1.Aexp' peak4.Aexp'],[peak1.Au' peak4.Au']),[peak1.A' peak4.A'])

means = [peak1.Aexp; peak1.Bexp; peak2.exp; peak3.exp; peak4.Aexp; peak4.Bexp];
stds = [peak1.Au; peak1.Bu; peak2.Cu; peak3.Cu; peak4.Au; peak4.Bu];
datas = [peak1.A; peak1.B; peak2.C; peak3.C; peak4.A; peak4.B];

pvals = [];
for i=1:max(size(means))
    pvals = [pvals; 2*cdf(gmdistribution(0,stds(i)^2),-abs(means(i)-datas(i)))];
end

peak1.Ap = pvals(1:3);
peak1.Bp = pvals(4:5);
peak2.Cp = pvals(6);
peak3.Cp = pvals(7:8);
peak4.Ap = pvals(9:11);
peak4.Bp = pvals(12:13);

Ap = peak1.Ap(3)*peak2.Cp(1)*peak3.Cp(1)*peak4.Ap(1)*peak4.Ap(2)
Ap_given_23 = peak1.Ap(3)*peak4.Ap(1)*peak4.Ap(2)

Bp = peak1.Bp(1)*peak1.Bp(2)*peak2.Cp(1)*peak3.Cp(1)
Bp_given_23 = peak1.Bp(1)*peak1.Bp(2)



%% calculate A + B

% Rb87
A87 = [];
B87 = [];
% 3-2, 2-1
dum = inv([[getCoeffs(3,87)]; [getCoeffs(2,87)]])*10^3*[peak4.A(1); peak4.A(2)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];
% calculate errors for A and B later
% 2-1, 1-0
dum = inv([[getCoeffs(2,87)]; [getCoeffs(1,87)]])*10^3*[peak4.A(2); peak1.A(3)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];
% 3-2, 1-0
dum = inv([[getCoeffs(3,87)]; [getCoeffs(1,87)]])*10^3*[peak4.A(1); peak1.A(3)];
A87 = [A87; dum(1)];
B87 = [B87; dum(2)];

% Rb85
% 3-2, 2-1
dum = inv([[getCoeffs(3,85)]; [getCoeffs(2,85)]])*10^3*[peak3.C(1); peak2.C(1)];
A85 = dum(1);
B85 = dum(2);


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








