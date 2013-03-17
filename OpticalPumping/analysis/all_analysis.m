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
geoZ

bearth_x = mean([bearth_x1, bearth_x2]);
uncert_bearth_x = mean([uncert_bearth_x1, uncert_bearth_x2])/sqrt(2);

bearth_y = mean([bearth_y1, bearth_y2]);
uncert_bearth_y = mean([uncert_bearth_y1, uncert_bearth_y2])/sqrt(2);

bearth_z = mean([bearth_z1, bearth_z2]);
uncert_bearth_z = mean([uncert_bearth_z1, uncert_bearth_z2])/sqrt(2);

IEarth = [b2i(bearth_x,'x') b2i(bearth_y,'y') ...
    b2i(bearth_z,'z')]; %currents that buck out Earth's magnetic field
uncert_IEarth = [b2i(uncert_bearth_x,'x') b2i(uncert_bearth_y,'y')...
    b2i(uncert_bearth_z,'z')]; %uncerts in buck-out currents

% IEarth = [148.05 -24 -33.3];  %old one WRONG

bearth_x
uncert_bearth_x
bearth_y
uncert_bearth_y
bearth_z
uncert_bearth_z

gf1mubonh = ((Xlin1.a^0.5+Ylin1.a^0.5+Zlin1.a^0.5)/3)
uncert_gf1mubonh = sqrt(0.5/3*((Xlin1.aerr^2/Xlin1.a+Ylin1.aerr^2/Ylin1.a+Zlin1.aerr^2/Ylin1.a)))
gf2mubonh = ((Xlin2.a^0.5+Ylin2.a^0.5+Zlin2.a^0.5)/3)
uncert_gf2mubonh = sqrt(0.5/3*((Xlin2.aerr^2/Xlin2.a+Ylin2.aerr^2/Ylin2.a+Zlin2.aerr^2/Ylin2.a)))

gf2ongf1 = gf2mubonh/gf1mubonh
uncert_gf2ongf1= sqrt(uncert_gf2mubonh^2/gf1mubonh^2 + (uncert_gf1mubonh*gf1mubonh/gf1mubonh^2)^2)

% clean-up
clear bearth_x1 bearth_x2 uncert_bearth_x1 uncert_bearth_x2 bearth_y1 bearth_y2...
    uncert_bearth_y1 uncert_bearth_y2 bearth_x bearth_y uncert_bearth_x...
    uncert_bearth_y bearth_z1 bearth_z2 uncert_bearth_z1 uncert_bearth_z2...
    bearth_z uncert_bearth_z


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

coilR


%% Fixed Frequency, Sweep B: Table D and G

vary_B_aggregated


%% Final Cleanup

clear home
%clear IEarth uncert_IEarth
