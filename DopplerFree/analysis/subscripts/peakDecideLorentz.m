c = 2.998*10^8;  % speed of light
n_air = 1.000277;  % refractive index of air
fsr = 10^-9*(c/(2*n_air*FP_len)); % calculate free spectral range of FP. FSR = 321.9 MHz

peak1=struct;
peak1.shifts = [];
peak1.shiftsDiff = [0;diff(peak1.shifts)];
peak1.uncerts = (1/(2*pi))*[]
peak1.uncerts = (peak1.uncerts(:,1).^2 + peak1.uncerts(:,2).^2 + peak1.uncerts(:,3).^2).^(0.5);
peak1.uncerts = fsr*peak1.uncerts;

peak4=struct;
peak4.shifts = [];
peak4.shiftsDiff = [0;diff(peak4.shifts)];
peak4.uncerts = (1/(2*pi))*[];
peak4.uncerts = (peak4.uncerts(:,1).^2 + peak4.uncerts(:,2).^2 + peak4.uncerts(:,3).^2).^(0.5);
peak4.uncerts = fsr*peak4.uncerts;

peak3=struct;
peak3.shifts = [];
peak3.shiftsDiff = [0;diff(peak3.shifts)];
peak3.uncerts = (1/(2*pi))*[];
peak3.uncerts = (peak3.uncerts(:,1).^2 + peak3.uncerts(:,2).^2 + peak3.uncerts(:,3).^2).^(0.5);
peak3.uncerts = fsr*peak3.uncerts;

peak2=struct;
peak2.shifts = [];
peak2.shiftsDiff = [0;diff(peak2.shifts)];
peak2.uncerts = (1/(2*pi))*[];
peak2.uncerts = (peak2.uncerts(:,1).^2 + peak2.uncerts(:,2).^2 + peak2.uncerts(:,3).^2).^(0.5);
peak2.uncerts = fsr*peak2.uncerts;


clear fsr n_air c