%% Measuring the resistance of the Coil

display('Measuring Coil Resistance')
figure
fitC = linearFit(tableC(:,1),tableC(:,2),0.01*ones(length(tableC),1))
%annotate
title({'Resistance of the Coil','Using Function Generator and Ammeter'})
xlabel('Average Voltage as Measured by the Oscilloscope [mV]')
ylabel('Current Measure by the Multimeter [mA]')
display(['Resistance of the Coil: ', num2str(1/fitC.a), '+-', num2str(fitC.aerr/fitC.a^2), ' ohms'])
