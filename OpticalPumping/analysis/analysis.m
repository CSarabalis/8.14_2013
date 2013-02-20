%% Notes and Startup

%tableA [ Sweep Rate kHz/s, Resonance Frequency kHz, Standard Deviation kHz ]
%
%       Description:
%		contains sweep rate error analysis. data collected by varying
%		the sweep rate and finding the absorption peak

%tableB [ Current in the X [mA], Current in the Y [mA], Current in the Z [mA],
%         Magnetic Field as Measured by the Magnetometer [mG],
%         Resonance Frequency of the First Peak [s],
%         Resonance Frequency of the Second Peak [s],
%         Beginning of Frequency Sweep [kHz],
%         End of Frequency Sweep [kHz],
%         Duration of Sweep [s]  ]
%
%       Description:
%		contains resonance frequencies for varying magnetic field
%		along the z axis

%tableC [ Average Voltage as Measured by the Oscilloscope [mV], 
%         Current Measure by the Multimeter [mA] ]
%
%       Description:
%       used for the determination of the resistance


home = pwd;

%load the data
cd ../data;
load data.mat;
cd(home);
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

%% Processing Table B

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
fitB1 = linearFit(Btotal(indices),resFreqOne,ones(length(resFreqOne),1))
%annotate
title('Resonsnace Frequency of Peak 1 vs. Magnetic Field Strength')
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [kHz]')

% Second Peak
indices = ~isnan(tableB(:,6));
resFreqTwo = tableB(indices,6)./tableB(indices,9); %convert into fraction of sweep
resFreqTwo = tableB(indices,7) + resFreqTwo.*(tableB(indices,8)-tableB(indices,7)); %convert into kHz
display('First Peak Frequency vs. B')
fitB2 = linearFit(Btotal(indices),resFreqTwo,ones(length(resFreqTwo),1))
%annotate
title('Resonsnace Frequency of Peak 2 vs. Magnetic Field Strength')
xlabel('Total Magnetic Field [G]')
ylabel('Resonance Frequency [kHz]')

%cleanup
clear indices resFreqOne resFreqTwo Btotal

%% Measuring the resistance of the Coil

display('Measuring Coil Resistance')
fitC = linearFit(tableC(:,1),tableC(:,2),0.01*ones(length(tableC),1))
%annotate
title({'Resistance of the Coil','Using Function Generator and Ammeter'})
display(['Resistance of the Coil: ', num2str(1/fitC.a), '+-', num2str(fitC.aerr/fitC.a^2), ' ohms'])

%% Final Cleanup

clear IEarth home