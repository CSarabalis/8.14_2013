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


%% Lorentzians: Cluster 1

obj=struct;
t=2129:6807;
obj.domain = t;
model = @(x,a)lorentzian(x,[a( 1) a( 2) a( 3)],[0.012106214141345   0.033257598917282   0.002347660047655])...
             +lorentzian(x,[a( 4) a( 5) a( 6)],[0.063036755427350   0.079010798505590   0.004566232530395])...
             +lorentzian(x,[a( 7) a( 8) a( 9)],[0.033720457115045   0.105694642400051   0.003468856169878])...
             +lorentzian(x,[a(10) a(11) a(12)],[0.004675242093907   0.123530553057868   0.005186076120651])...
             +lorentzian(x,[a(13) a(14) a(15)],[0.005048445283531   0.150416957028192   0.003711699131836])...
             +lorentzian(x,[a(16),a(17),a(18)],[0.001873754756358   0.176000000000000   0.003800000000000])...
             +a(19)*0.150961207022415      ...
             +a(20)*0.012610040466719 * x  ...
             -a(21)*0.072666565742134 * x.^2;
[obj.afit,obj.aerr,obj.chisq,obj.yfit,obj.corr]=levmar(da{79}.time(t),da{79}.bal(t),0.001*ones(length(t),1),...
  model,ones(1,21),0,0);
obj.model = model;
fit{1} = obj;

 %% Lorentzians: Cluster 2
 
obj=struct;
t=1850:7096;
obj.domain = t;
model = @(x,a) lorentzian(x,[a( 1),a( 2),a( 3)],[0.008    0.0730    0.0040]) ...
             + lorentzian(x,[a( 4),a( 5),a( 6)],[0.027    0.0824    0.0080]) ...
             + lorentzian(x,[a( 7),a( 8),a( 9)],[0.062    0.0920    0.0062]) ...
             + lorentzian(x,[a(10),a(11),a(12)],[0.052    0.1025    0.0055]) ...
             + lorentzian(x,[a(13),a(14),a(15)],[0.009    0.1105    0.0055]) ...
             + a(16)*3.593021745559644*(x-a(17)*0.0851969455859337).^2 ...
             + a(18)*0.167178685302813 ...
             - a(19)*3.942805084840015*x.^3;
[obj.afit,obj.aerr,obj.chisq,obj.yfit,obj.corr]=levmar(da{82}.time(t),da{82}.bal(t),0.001*ones(length(t),1),...
  model,ones(1,19),0,0);
obj.model = model;
cluster{2} = obj;

%% Lorentzians Cluster 3

obj=struct;
t=3512:4712;
obj.domain = t;
model = @(x,a)lorentzian(x,[a(1),a(2),a(3)],[0.0046,0.0763,0.0025])+...
              lorentzian(x,[a(4),a(5),a(6)],[0.148,0.11045,0.004])+...
              lorentzian(x,[a(7),a(8),a(9)],[0.136,0.1278,0.004])+...
              -0.0139*a(10);
[obj.afit,obj.aerr,obj.chisq,obj.yfit,obj.corr]=levmar(da{84}.time(t),da{84}.bal(t),0.001*ones(length(t),1),...
  model,ones(1,10),0,0);
obj.model = model;


%% Lorentzians Cluster 4

obj=struct;
t=3100:6000;
obj.domain = t;
model = @(x,a)lorentzian(x,[a(1),a(2),a(3)],[0.0276    0.0869    0.0010])+...
              lorentzian(x,[a(4),a(5),a(6)],[0.1067    0.1107    0.0024])+...
              lorentzian(x,[a(7),a(8),a(9)],[0.0681    0.1246    0.0018])+...
              lorentzian(x,[a(10),a(11),a(12)],[0.0036    0.1338    0.0021])+...
              lorentzian(x,[a(13),a(14),a(15)],[0.0051    0.1478    0.0022])+...
              lorentzian(x,[a(16),a(17),a(18)],[0.0019    0.1623    0.0020])+...
              -a(19)*0.4478+a(20)*3.4694*x-a(21)*28.3112*x.^2+a(22)*67.1767*x.^3;
[obj.afit,obj.aerr,obj.chisq,obj.yfit,obj.corr]=levmar(da{86}.time(t),da{86}.bal(t),0.001*ones(length(t),1),...
  model,ones(1,22),0,0);
obj.model = model;
