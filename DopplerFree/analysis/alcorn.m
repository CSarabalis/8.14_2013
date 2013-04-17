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

%get splittings
T = 4e-5; %time between samples
x = [3.325760e-02,7.901080e-02,1.056946e-01,1.235306e-01,1.504170e-01,1.760000e-01]; %scalings from model
for i = 1:length(x)
  obj.shifts(i) = (x(i)*obj.afit(3*i-1)-x(1)*obj.afit(3*1-1));  %splittings in seconds
end
obj.shifts = obj.shifts/T;
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

%get splittings
T = 4e-5; %time between samples
x = [7.300000e-02,8.240000e-02,9.200000e-02,1.025000e-01,1.105000e-01]; %scalings from model
for i = 1:length(x)
  obj.shifts(i) = (x(i)*obj.afit(3*i-1)-x(1)*obj.afit(3*1-1));  %splittings in seconds
end
obj.shifts = obj.shifts/T; %splittings in indices

clear x T
%% Lorentzians Cluster 3

obj=struct;
t=3512:4712;
obj.domain = t;
obj.avgFile = 84;
model = @(x,a)lorentzian(x,[a( 1),a( 2),a( 3)],[0.005715429224014   0.075754309037678   0.002971520649524])+...
              lorentzian(x,[a( 4),a( 5),a( 6)],[0.069112105997450   0.108235446739133   0.002783027756830])+...
              lorentzian(x,[a( 7),a( 8),a( 9)],[0.114605947835033   0.111433974199945   0.003578844699006])+...
              lorentzian(x,[a(10),a(11),a(12)],[0.105313573686246   0.128938541446383   0.003310431346580])+...
              lorentzian(x,[a(13),a(14),a(15)],[0.116621650418563   0.128658480963908   0.003902876415531])+...
              - 0.013698026823913*a(16) ...
              + a(17) * x               ...
              + a(18) * x.^2;
[obj.afit,obj.aerr,obj.chisq,obj.yfit,obj.corr]=levmar(da{obj.avgFile}.time(t),da{obj.avgFile}.bal(t),0.001*ones(length(t),1),...
  model,ones(1,18),0,0);
obj.model = model;

%get splittings
T = 8e-5; %time between samples
x = [7.575431e-02,1.082354e-01,1.114340e-01,1.289385e-01,1.286585e-01]; %scalings from model
for i = 1:length(x)
  obj.shifts(i) = (x(i)*obj.afit(3*i-1)-x(1)*obj.afit(3*1-1));  %splittings in seconds
end
obj.shifts = sort(obj.shifts/T); %sorted splittings in indices

clear x T

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

%get splittings
T = 4e-5; %time between samples
x = [8.690000e-02,1.107000e-01,1.246000e-01,1.338000e-01,1.478000e-01,1.623000e-01]; %scalings from model
for i = 1:length(x)
  obj.shifts(i) = (x(i)*obj.afit(3*i-1)-x(1)*obj.afit(3*1-1));  %splittings in seconds
end
obj.shifts = obj.shifts/T;

clear x T
