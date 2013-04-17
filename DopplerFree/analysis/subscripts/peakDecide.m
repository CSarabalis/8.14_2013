c = 2.998*10^8;  % speed of light
n_air = 1.000277;  % refractive index of air
fsr = 10^-9*(c/(2*n_air*FP_len)); % calculate free spectral range of FP. FSR = 321.9 MHz

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
peak1.uncerts = fsr*peak1.uncerts;

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
peak4.uncerts = fsr*peak4.uncerts;

peak3=struct;
peak3.shifts = da{84}.shifts;
peak3.shiftsDiff = [0;diff(peak3.shifts)];
peak3.uncerts = (1/(2*pi))*[0.047 0.0124 0.0005;
    0.0397 0.005 0.0005;
    0.0479 0.0143 0.0006];
peak3.uncerts = (peak3.uncerts(:,1).^2 + peak3.uncerts(:,2).^2 + peak3.uncerts(:,3).^2).^(0.5);
peak3.uncerts = fsr*peak3.uncerts;

peak2=struct;
peak2.shifts = da{82}.shifts;
peak2.shiftsDiff = [0;diff(peak2.shifts)];
peak2.uncerts = (1/(2*pi))*[0.1387 0.0277 0.0009;
    0 0.0023 0.0005;
    0.047 0.01 0.0005];
peak2.uncerts = (peak2.uncerts(:,1).^2 + peak2.uncerts(:,2).^2 + peak2.uncerts(:,3).^2).^(0.5);
peak2.uncerts = fsr*peak2.uncerts;


clear fsr n_air c