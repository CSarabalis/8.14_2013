%% Measuring the resistance of the Coil

% main source of error: instr uncert in multimeter is 0.01mA. Error in
% average voltage measurement of oscilloscope is tiny (b.c. it is an
% average)

display('Measuring Coil Resistance')
figure

%subplot(2,1,1)
fitC = linearFit(tableC(:,1),tableC(:,2),0.01*ones(length(tableC),1))
%annotate
title({'Resistance of the Coil','Using Function Generator and Ammeter'})
xlabel('Average Voltage as Measured by the Oscilloscope [mV]')
ylabel('Current Measure by the Multimeter [mA]')
display(['Resistance of the Coil: ', num2str(1/fitC.a), '+-', num2str(fitC.aerr/fitC.a^2), ' ohms'])

% subplot(2,1,2)
% fitC = linearFit(tableC(:,2),tableC(:,1),0.01*ones(length(tableC),1))
% %annotate
% title({'Resistance of the Coil','Using Function Generator and Ammeter'})
% xlabel('Average Voltage as Measured by the Oscilloscope [mV]')
% ylabel('Current Measure by the Multimeter [mA]')
% display(['Resistance of the Coil: ', num2str(fitC.a), '+-', num2str(fitC.aerr), ' ohms'])
