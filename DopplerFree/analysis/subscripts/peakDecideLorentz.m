c = 2.998*10^8;  % speed of light
n_air = 1.000277;  % refractive index of air
fsr = 10^-9*(c/(2*n_air*FP_len)); % calculate free spectral range of FP. FSR = 321.9 MHz

%statFluc = 0.27e-3;
statFluc = 4.27e-3;

i=1;
peak1=struct;
T = 4e-5; %time/index conversion
x = [3.325760e-02,7.901080e-02,1.056946e-01,1.235306e-01,1.504170e-01,1.760000e-01]; %scalings from model %GUESSES
autocorrFSR = [0; cluster{i}.autocorr.fits{1}.peak; cluster{i}.autocorr.fits{2}.peak]; %number of indices per FSR
autocorrFSR = mean(diff(autocorrFSR));
k = fsr/autocorrFSR;
peak1.shifts = cluster{i}.shifts'*k;
peak1.shiftsDiff = [0; diff(peak1.shifts)];
x=cluster{i}.aerr(2:3:17)'.*x'*k/T;
peak1.uncerts = x; %lorentzian peak determination error
peak1.uncerts = peak1.uncerts + statFluc; % add stat flucs in peak locations

i=4;
peak4=struct;
T = 4e-5; %time/index conversion
x = [8.690000e-02,1.107000e-01,1.246000e-01,1.338000e-01,1.478000e-01,1.623000e-01]; %scalings from model
autocorrFSR = [0; cluster{i}.autocorr.fits{1}.peak; cluster{i}.autocorr.fits{2}.peak; cluster{i}.autocorr.fits{3}.peak; cluster{i}.autocorr.fits{4}.peak]; %number of indices per FSR
autocorrFSR = mean(diff(autocorrFSR));
k = fsr/autocorrFSR;
peak4.shifts = cluster{i}.shifts'*k;
peak4.shiftsDiff = [0; diff(peak4.shifts)];
x=cluster{i}.aerr(2:3:17)'.*x'*k/T;
peak4.uncerts = x; %lorentzian peak determination error
peak4.uncerts = peak4.uncerts + statFluc; % add stat flucs in peak locations

i=3; 
peak3=struct;
T = 8e-5; %time/index conversion
x = [7.575431e-02,1.082354e-01,1.114340e-01,1.289385e-01,1.286585e-01]; %scalings from model
autocorrFSR = cluster{i}.autocorr.fits{1}.peak; %number of indices per FSR
%autocorrFSR = autocorrFSR(1);
k = fsr/autocorrFSR;
peak3.shifts = cluster{i}.shifts'*k;
peak3.shiftsDiff = [0; diff(peak3.shifts)];
x=cluster{i}.aerr(2:3:14)'.*x'*k/T;
peak3.uncerts = x; %lorentzian peak determination error
peak3.uncerts = peak3.uncerts + statFluc; % add stat flucs in peak locations

i=2; 
peak2=struct;
T = 4e-5; %time/index conversion
x = [7.300000e-02,8.240000e-02,9.200000e-02,1.025000e-01,1.105000e-01]; %scalings from model
autocorrFSR = [0; cluster{i}.autocorr.fits{1}.peak; cluster{i}.autocorr.fits{2}.peak]; %number of indices per FSR
autocorrFSR = mean(diff(autocorrFSR));
k = fsr/autocorrFSR;
peak2.shifts = cluster{i}.shifts'*k;
peak2.shiftsDiff = [0; diff(peak2.shifts)];
x=cluster{i}.aerr(2:3:14)'.*x'*k/T;
peak2.uncerts = x; %lorentzian peak determination error
peak2.uncerts = peak2.uncerts + statFluc; % add stat flucs in peak locations



clear fsr n_air c x autocorrFSR T i k