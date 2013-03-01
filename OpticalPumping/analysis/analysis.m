%% Notes and Startup

%tableA [ Sweep Rate kHz/s, Resonance Frequency kHz, Standard Deviation kHz ]
%
%       Description:
%		contains sweep rate error analysis. data collected by varying
%		the sweep rate and finding the absorption peak

%tableB   [ 1:Current in the X [mA], 
%           2:Current in the Y [mA],
%           3:Current in the Z [mA],
%           4:Magnetic Field as Measured by the Magnetometer [mG],
%           5:Resonance Frequency of the First Peak [s],
%           6:Resonance Frequency of the Second Peak [s],
%           7:Beginning of Sweep [kHz],
%           8: End of Sweep [kHz],
%           9: Duration of Sweep [s] ]
%
%       Description:
%         fixed magnetic field, sweeping coil drive frequency
%
%       Date: 2/15/13

%tableC [ Average Voltage as Measured by the Oscilloscope [mV], 
%         Current Measure by the Multimeter [mA] ]
%
%       Description:
%       used for the determination of the resistance

%tableD [ RF Coil Frequency [kHz], First Peak Resonance Frequency [mV],
%         Second Peak Frequency [mV], Instrument Precision for Peak 1 [mv],
%         Instrument Precision for Second Peak [mV], Discrepancy Between
%         Measurements by Chris and Tom for Peak 1 [mV], Discrepancy for
%         Peak 2 [mV] ]
%
%       Description:
%       fixed frequency, sweep B
%       driven by a ramp

%tableE   [ RF Coil Frequency [kHz],
%           First Peak Resonance Frequency [mV],
%           Second Peak Frequency [mV],
%           Instrument Precision for Peak 1 [mv],
%           Instrument Precision for Second Peak [mV],
%           Discrepancy Between Measurements by Chris and Tom for Peak 1 [mV],
%           Discrepancy for Peak 2 [mV] ]
%
%       Description:
%         fixed frequency, sweep B
%         driven by a triangle wave

%tableF [ 1:Current in the X [mA], 2:Current in the Y [mA], 3:Current in the Z [mA],
%         4:Magnetic Field as Measured by the Magnetometer [mG],
%         5:Resonance Frequency of the First Peak [s], 6:Resonance
%         Frequency of the Second Peak [s], 7:Beginning of Frequency Sweep
%         [kHz], 8:End of Frequency Sweep [kHz], 9:Duration of Sweep [s]  ]
%
%       Description:
%		contains resonance frequencies for varying magnetic field
%		along the z axis
%       NB: averaging over 8 runs on oscilloscope, resonance freqs uncerts
%       should be treated as uncert in mean
%       NB2: Instrumental uncert in 5 & 6 is +-1ms
%
%       Temperature of vapour chamber: 42.4 deg celsius
%       Date recorded: Mon 25 Feb

%tableG   [ 1:RF Coil Frequency [kHz],
%           2:Chris Peak 1 Resonance Frequency [mV],
%           3:Chris Peak 2 Frequency [mV],
%           4:Tom Peak 1 [mV],
%           5:Tom Peak 2 [mV],
%           6:Instrument Precision for First Peak Chris [mv],
%           7:Instrument Precision for Second Peak Chris [mV],
%           8:Sweep amplitude [Vpp],
%           9:Sweep time [s],
%           10:Sweep offset [V],
%           11:[Up-ramp=1, down-ramp=0],
%           12:Instrument Precision for First Peak Tom [mV],
%           13:Instrument prec for second peak Tom [mV] ]
%
%       Description:
%       fixed frequency, sweep B
%
%       Ix = 148.4, Iy = -19.24, Iz is being swept
%
%       NB: Triangle wave, both up (1) and down (0) ramps recorded
%       NB2: One measurement made by Chris, a second by Tom. Instrument
%       precsion determined by wiggling left/right one notch with
%       oscilloscope cursor
%       NB3: Averaging over 16 oscilloscope runs.
%
%       Temperature of vapour chamber: 42.1 deg celsius
%       Date recorded: Mon 25 Feb

%tableB   [ 1:Current in the X [mA], 
%           2:Current in the Y [mA],
%           3:Current in the Z [mA],
%           4:Magnetic Field as Measured by the Magnetometer [mG],
%           5:Resonance Frequency of the First Peak [s],
%           6:Resonance Frequency of the Second Peak [s],
%           7:Beginning of Sweep [kHz],
%           8: End of Sweep [kHz],
%           9: Duration of Sweep [s] ]
%
%       Description:
%         fixed magnetic field, sweeping coil drive frequency
%
%       Date: 2/27/13

home = pwd;

%load the data
cd ../data;
load data.mat;
cd(home);
addpath ./tools;
addpath ./subscripts;
IEarth = [165.7 -19.3 -33.3];  %currents that buck out Earth's magnetic field

%% Error analysis for sweep rate

sweepRate = tableA(:,1);
resonance = tableA(:,2);
deltaRes  = tableA(:,3);
display('Sweep Rate Error Analysis')
fitA = linearFit(sweepRate,resonance,deltaRes)
%annotate
title('Sweep Rate Error Analysis')
xlabel('Sweep Rate [kHz/s]')
ylabel('Resonance Frequency [kHz]')

%cleanup
clear sweepRate resonance deltaRes

%% Processing Table B: Fixed B, Sweep Frequency

Btotal = sqrt(i2b(tableB(:,1) - IEarth(1),'x').^2+i2b(tableB(:,2)-IEarth(2),'y').^2+i2b(tableB(:,3)-IEarth(3),'z').^2);
%plot the total B field calculated from Helmholtz currents and measured by
%   the magnetometer
figure
plot(Btotal,tableB(:,4)*0.001,'.')
title('Magnetic Field Consistency Check')
xlabel('Magnitude of B Calculated from Currents [G]')
ylabel('B Measured by Magnetometer [G]')
%seems to be a mismatch between positive and negative readings
figure
plot(Btotal,abs(tableB(:,4)*0.001),'.')
title('Magnetic Field Consistency Check')
xlabel('Magnitude of B Calculated from Currents [G]')
ylabel('Magnitude of B Measured by Magnetometer [G]')

% First Peak
indices = ~isnan(tableB(:,5));
resFreqOne = tableB(indices,5)./tableB(indices,9); %convert into fraction of sweep
resFreqOne = tableB(indices,7) + resFreqOne.*(tableB(indices,8)-tableB(indices,7)); %convert into kHz
display('First Peak Frequency vs. B')
fitB1 = linearFit(Btotal(indices),resFreqOne - 2*fitA.a*(tableB(indices,8)-tableB(indices,7))./tableB(indices,9),ones(length(resFreqOne),1)) %correction in arg2: 200 kHz is the sweep rate; mysterious factor of 2
%plot model
hold on
plot(Btotal(indices),466.54*Btotal(indices),'-r')
%annotate
title('Resonsnace Frequency of Peak 1 vs. Magnetic Field Strength')
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [kHz]')
fontSize(16)
%print results
display('Expected g*mu_B/h = 4.665415e9')
display(['Measured: ',num2str(fitB1.a*1e7,'%10.5e'),' \pm ', num2str(fitB1.aerr*1e7,'%10.5e')])

% Second Peak
indices = ~isnan(tableB(:,6));
resFreqTwo = tableB(indices,6)./tableB(indices,9); %convert into fraction of sweep
resFreqTwo = tableB(indices,7) + resFreqTwo.*(tableB(indices,8)-tableB(indices,7)); %convert into kHz
display('First Peak Frequency vs. B')
fitB2 = linearFit(Btotal(indices),resFreqTwo - 2*fitA.a*(tableB(indices,8)-tableB(indices,7))./tableB(indices,9),ones(length(resFreqTwo),1)) %correction in arg2: 200 kHz is the sweep rate; mysterious factor of 2
%plot model
hold on
plot(Btotal(indices),699.81*Btotal(indices),'-r')
%annotate
title('Resonsnace Frequency of Peak 2 vs. Magnetic Field Strength')
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [kHz]')
fontSize(16)
%print 
display('Expected g*mu_B/h = 6.998123e9')
display(['Measured: ',num2str(fitB2.a*1e7,'%10.5e'),' \pm ', num2str(fitB2.aerr*1e7,'%10.5e')])

%cleanup
clear indices resFreqOne resFreqTwo Btotal

%% Repeated Analysis Cell for Table H: Fixed B, Sweep Frequency

Btotal = sqrt(i2b(tableH(:,1) - IEarth(1),'x').^2+i2b(tableH(:,2)-IEarth(2),'y').^2+i2b(tableH(:,3)-IEarth(3),'z').^2);
%plot the total B field calculated from Helmholtz currents and measured by
%   the magnetometer
figure
plot(Btotal,tableH(:,4)*0.001,'.')
title('Magnetic Field Consistency Check')
xlabel('Magnitude of B Calculated from Currents [G]')
ylabel('B Measured by Magnetometer [G]')
%seems to be a mismatch between positive and negative readings
figure
plot(Btotal,abs(tableH(:,4)*0.001),'.')
title('Magnetic Field Consistency Check')
xlabel('Magnitude of B Calculated from Currents [G]')
ylabel('Magnitude of B Measured by Magnetometer [G]')

% First Peak
indices = ~isnan(tableH(:,5));
resFreqOne = tableH(indices,5)./tableH(indices,9); %convert into fraction of sweep
resFreqOne = tableH(indices,7) + resFreqOne.*(tableH(indices,8)-tableH(indices,7)); %convert into kHz
display('First Peak Frequency vs. B')
fitH1 = linearFit(Btotal(indices),resFreqOne - 2*fitA.a*(tableH(indices,8)-tableH(indices,7))./tableH(indices,9),ones(length(resFreqOne),1)) %correction in arg2: 200 kHz is the sweep rate; mysterious factor of 2
%plot model
hold on
plot(Btotal(indices),466.54*Btotal(indices),'-r')
%annotate
title('Resonsnace Frequency of Peak 1 vs. Magnetic Field Strength')
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [kHz]')
fontSize(16)
%print results
display('Expected g*mu_B/h = 4.665415e9')
display(['Measured: ',num2str(fitH1.a*1e7,'%10.5e'),' \pm ', num2str(fitH1.aerr*1e7,'%10.5e')])

% Second Peak
indices = ~isnan(tableH(:,6));
resFreqTwo = tableH(indices,6)./tableH(indices,9); %convert into fraction of sweep
resFreqTwo = tableH(indices,7) + resFreqTwo.*(tableH(indices,8)-tableH(indices,7)); %convert into kHz
display('First Peak Frequency vs. B')
fitH2 = linearFit(Btotal(indices),resFreqTwo - 2*fitA.a*(tableH(indices,8)-tableH(indices,7))./tableH(indices,9),ones(length(resFreqTwo),1)) %correction in arg2: 200 kHz is the sweep rate; mysterious factor of 2
%plot model
hold on
plot(Btotal(indices),699.81*Btotal(indices),'-r')
%annotate
title('Resonsnace Frequency of Peak 2 vs. Magnetic Field Strength')
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [kHz]')
fontSize(16)
%print 
display('Expected g*mu_B/h = 6.998123e9')
display(['Measured: ',num2str(fitH2.a*1e7,'%10.5e'),' \pm ', num2str(fitH2.aerr*1e7,'%10.5e')])

%cleanup
clear indices resFreqOne resFreqTwo Btotal

%% Measuring the resistance of the Coil

display('Measuring Coil Resistance')
fitC = linearFit(tableC(:,1),tableC(:,2),0.01*ones(length(tableC),1))
%annotate
title({'Resistance of the Coil','Using Function Generator and Ammeter'})
xlabel('Average Voltage as Measured by the Oscilloscope [mV]')
ylabel('Current Measure by the Multimeter [mA]')
display(['Resistance of the Coil: ', num2str(1/fitC.a), '+-', num2str(fitC.aerr/fitC.a^2), ' ohms'])

%% Fixed Frequency, Sweep B: Table D and G

ramp = tableD;
triangleUpramp = tableE([1,3],:);
triangleDownramp = tableE([2,4],:);

Btotal = sqrt(i2b(166.0 - IEarth(1),'x').^2+i2b(-19.28-IEarth(2),'y').^2+i2b(v2i(1e-3*ramp(:,3))-IEarth(3),'z').^2);
%linear fit of peak 1
%   currently doesn't take into account signal lag from tableA
fitD1 = linearFit(Btotal,ramp(:,1),i2b(v2i(ramp(:,5)),'z'))
%plot model
hold on
plot(Btotal,466.54*Btotal,'-r')
%annotate
title({'Fixed Frequency, Varied B','Peak 1, Ramp 2 V/s'})
ylabel('Resonance Frequency [kHz]')
xlabel('Total Magnetic Field [G]')
fontSize(16)

Btotal = sqrt(i2b(166.0 - IEarth(1),'x').^2+i2b(-19.28-IEarth(2),'y').^2+i2b(v2i(1e-3*ramp(:,2))-IEarth(3),'z').^2);
%linear fit of peak 2
%   currently doesn't take into account signal lag from tableA
fitD2 = linearFit(Btotal,ramp(:,1),i2b(v2i(ramp(:,4)),'z'))
%plot model
hold on
plot(Btotal,699.81*Btotal,'-r')
%annotate
title({'Fixed Frequency, Varied B','Peak 2, Ramp 2 V/s'})
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)

%taking a look at the discrepancy between sweep characteristics
figure
hold on
plot(ramp(:,1),ramp(:,2),'.b')
plot(triangleDownramp(:,1),triangleDownramp(:,2),'.r')
plot(triangleUpramp(:,1),triangleUpramp(:,2),'.g')
%annotate
title('Fixed Frequency, Varied B: Discepancy from Sweep Characteristics')
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)

%comparing change over time of the points
figure
hold on
title({'Change from Day to Day','Need to Compute Total B'})
upIndicies = find(tableG(:,11));
errorbar(i2b(v2i(1e-3*tableG(upIndicies,2))-IEarth(3),'z'),tableG(upIndicies,1),tableG(upIndicies,6),'.g')
errorbar(i2b(v2i(1e-3*tableG(upIndicies,4))-IEarth(3),'z'),tableG(upIndicies,1),tableG(upIndicies,6),'.r')
errorbar(i2b(v2i(1e-3*ramp(:,3))-IEarth(3),'z'),ramp(:,1),i2b(v2i(ramp(:,5)),'z'),'.')


clear ramp triangleUpramp triangleDownramp upIndicies Btotal

%% Final Cleanup

clear home IEarth
