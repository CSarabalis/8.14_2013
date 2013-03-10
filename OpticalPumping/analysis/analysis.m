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

%tableH   [ 1:Current in the X [mA], 
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

%tableI   [ 1:Current in the X [mA], 
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
%         scope is now DC coupled
%
%       Date: 2/27/13

home = pwd;
setup;

%% Geo-magnetic field

tableF_analysis_geomagnetic_field

bearth_x = mean([bearth_x1, bearth_x2]);
uncert_bearth_x = mean([uncert_bearth_x1, uncert_bearth_x2]);

bearth_y = mean([bearth_y1, bearth_y2]);
uncert_bearth_y = mean([uncert_bearth_y1, uncert_bearth_y2]);

IEarth = [b2i(bearth_x,'x') b2i(bearth_y,'y') -33.3]; %currents that buck out Earth's magnetic field
uncert_IEarth = [b2i(uncert_bearth_x,'x') b2i(uncert_bearth_y,'y') 0.1];

% IEarth = [148.05 -24 -33.3];  %old one

% clean-up
clear bearth_x1 bearth_x2 uncert_bearth_x1 uncert_bearth_x2 bearth_y1 bearth_y2...
    uncert_bearth_y1 uncert_bearth_y2 bearth_x bearth_y uncert_bearth_x...
    uncert_bearth_y


%% Error analysis for sweep rate

sweepRate = tableA(:,1);
resonance = tableA(:,2);
deltaRes  = tableA(:,3);
display('Sweep Rate Error Analysis')
figure
fitA = linearFit(sweepRate,resonance,deltaRes)
%annotate
title('Sweep Rate Error Analysis')
xlabel('Sweep Rate [kHz/s]')
ylabel('Resonance Frequency [kHz]')

%cleanup
clear sweepRate resonance deltaRes

%% Processing Table B and H: Fixed B, Sweep Frequency

fixBvaryF

%% Measuring the resistance of the Coil

display('Measuring Coil Resistance')
figure
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
figure
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
figure
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

clear home
%clear IEarth uncert_IEarth
