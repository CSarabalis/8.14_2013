%% Convert data into appropriate units, quantities

sweeprate = (tableF(:,8)-tableF(:,7))./tableF(:,9);
sweepstart = tableF(:,7);
peak_1_freq = tableF(:,5).*sweeprate + sweepstart;
peak_2_freq = tableF(:,6).*sweeprate + sweepstart;
instr_uncert = ones(size(tableF,1),1)*0.001;

%% Varying Y-coil current

yrange = [1:15];

y_mag_field = i2b(tableF(:,2),'y');

figure
hold on
errorbar(y_mag_field(yrange),peak_1_freq(yrange),instr_uncert(yrange),'*r')
errorbar(y_mag_field(yrange),peak_2_freq(yrange),instr_uncert(yrange),'*')
xlabel('Magnetic field generated by Y-coil [G]')
ylabel('Resonance frequency of absorption peaks [kHz]')
title('Resonance peak movement as Y-coil current varies')

clear yrange y_mag_field

% indicates Iy_earth is -19.3mA

%% Varying X-coil current

xrange = [16:27];

x_mag_field = i2b(tableF(:,1),'x');

figure
hold on
errorbar(x_mag_field(xrange),peak_1_freq(xrange),instr_uncert(xrange),'*r')
errorbar(x_mag_field(xrange),peak_2_freq(xrange),instr_uncert(xrange),'*')
xlabel('Magnetic field generated by X-coil [G]')
ylabel('Resonance frequency of absorption peaks [kHz]')
title('Resonance peak movement as X-coil current varies')

clear xrange x_mag_field 

% indicates Ix_earth is 148.5mA

%% Varying Z-coil current
% 
% zrange = [28:];
% 
% z_mag_field = i2b(tableF(:,1),'z');
% 
% figure
% hold on
% errorbar(z_mag_field(zrange),peak_1_freq(zrange),instr_uncert(zrange),'*r')
% errorbar(z_mag_field(zrange),peak_2_freq(zrange),instr_uncert(zrange),'*')
% xlabel('Magnetic field generated by Z-coil [G]')
% ylabel('Resonance frequency of absorption peaks [kHz]')
% title('Resonance peak movement as Z-coil current varies')
% 
% clear zrange z_mag_field 

%% 

clear sweeprate sweepstart peak_1_freq peak_2_freq instr_uncert