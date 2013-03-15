%% Table B analysis

%compute the total magnetic field
Btotal = sqrt(i2b(tableB(:,1) - IEarth(1),'x').^2+i2b(tableB(:,2)-IEarth(2),'y').^2+i2b(tableB(:,3)-IEarth(3),'z').^2);

%compute the uncertainty in the frequency_______________________

%time      (y-axis)
sigInstrumentPrecision = 1; %ms
sigStatPeak1 = 6.19; %ms
sigStatPeak2 = 3.54; %ms
numberOfSweeps = 8;
sigXatMax = 10; %ms
sigSweepRateCorrectionError = fitA.aerr; %s
%mag field (x-axis)
sigi = sqrt(0.1^2+0.1^2); %0.1 mA from precision, 0.1 mA from meter discrepancy
sigRelCoilRadius = 0.25./[7.3 8.9 11.0]; %measurements in inches
sigIEarth = [1.8 0.29 0.40]; %mA

tableB(:,10) =sqrt(sigInstrumentPrecision^2 + sigStatPeak1^2/numberOfSweeps +...
    sigXatMax^2 + (sigSweepRateCorrectionError.*(tableB(:,8)-tableB(:,7))./tableB(:,9)).^2)...
    *0.001.*(tableB(:,8)-tableB(:,7))./tableB(:,9)+...
    469.6848*sqrt(i2b(tableB(:,1) - IEarth(1),'x').^4.*((sigi^2+sigIEarth(1)^2)./(tableB(:,1) - IEarth(1)).^2+sigRelCoilRadius(1)^2)+...
    i2b(tableB(:,2) - IEarth(2),'y').^4.*((sigi^2+sigIEarth(2)^2)./(tableB(:,2) - IEarth(2)).^2+sigRelCoilRadius(2)^2)+...
    i2b(tableB(:,3) - IEarth(3),'z').^4.*((sigi^2+sigIEarth(3)^2)./(tableB(:,3) - IEarth(3)).^2+sigRelCoilRadius(3)^2))./Btotal;

tableB(:,11) =sqrt(sigInstrumentPrecision^2 + sigStatPeak1^2/numberOfSweeps +...
    sigXatMax^2 + (sigSweepRateCorrectionError.*(tableB(:,8)-tableB(:,7))./tableB(:,9)).^2)...
    *0.001.*(tableB(:,8)-tableB(:,7))./tableB(:,9)+...
    705.2103*sqrt(i2b(tableB(:,1) - IEarth(1),'x').^4.*((sigi^2+sigIEarth(1)^2)./(tableB(:,1) - IEarth(1)).^2+sigRelCoilRadius(1)^2)+...
    i2b(tableB(:,2) - IEarth(2),'y').^4.*((sigi^2+sigIEarth(2)^2)./(tableB(:,2) - IEarth(2)).^2+sigRelCoilRadius(2)^2)+...
    i2b(tableB(:,3) - IEarth(3),'z').^4.*((sigi^2+sigIEarth(3)^2)./(tableB(:,3) - IEarth(3)).^2+sigRelCoilRadius(3)^2))./Btotal;



%%
% %plot the total B field calculated from Helmholtz currents and measured by
% %   the magnetometer
% figure
% plot(Btotal,tableB(:,4)*0.001,'.')
% title('Magnetic Field Consistency Check')
% xlabel('Magnitude of B Calculated from Currents [G]')
% ylabel('B Measured by Magnetometer [G]')
% %seems to be a mismatch between positive and negative readings
% figure
% plot(Btotal,abs(tableB(:,4)*0.001),'.')
% title('Magnetic Field Consistency Check')
% xlabel('Magnitude of B Calculated from Currents [G]')
% ylabel('Magnitude of B Measured by Magnetometer [G]')

figure
hold on
subplot(2,2,1)
% Table B: First Peak
	indices = ~isnan(tableB(:,5));
	resFreqOne = tableB(indices,5)./tableB(indices,9); %convert into fraction of sweep
	resFreqOne = tableB(indices,7) + resFreqOne.*(tableB(indices,8)-tableB(indices,7)); %convert into kHz
    display('First Peak Frequency vs. B')
	fitB1 = linearFit(Btotal(indices),resFreqOne - fitA.a*(tableB(indices,8)-tableB(indices,7))./tableB(indices,9),tableB(indices,10)) %correction in arg2: 200 kHz is the sweep rate
	%plot model
    hold on
	plot(Btotal(indices),466.54*Btotal(indices),'-r')
	%annotate
	title('Table B: Peak 1')
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
	fontSize(14)
	%print results
	display('Expected g*mu_B/h = 4.665415e9')
	display(['Measured: ',num2str(fitB1.a*1e7,'%10.5e'),' \pm ', num2str(fitB1.aerr*1e7,'%10.5e')])

subplot(2,2,3)
% Table B: Second Peak
	indices = ~isnan(tableB(:,6));
	resFreqTwo = tableB(indices,6)./tableB(indices,9); %convert into fraction of sweep
	resFreqTwo = tableB(indices,7) + resFreqTwo.*(tableB(indices,8)-tableB(indices,7)); %convert into kHz
	display('First Peak Frequency vs. B')
	fitB2 = linearFit(Btotal(indices),resFreqTwo - fitA.a*(tableB(indices,8)-tableB(indices,7))./tableB(indices,9),tableB(indices,11)) %correction in arg2: 200 kHz is the sweep rate
	%plot model
	hold on
	plot(Btotal(indices),699.81*Btotal(indices),'-r')
	%annotate
	title('Table B: Peak 2')
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
	fontSize(14)
	%print 
	display('Expected g*mu_B/h = 6.998123e9')
    display(['Measured: ',num2str(fitB2.a*1e7,'%10.5e'),' \pm ', num2str(fitB2.aerr*1e7,'%10.5e')])

Btotal = sqrt(i2b(tableH(:,1) - IEarth(1),'x').^2+i2b(tableH(:,2)-IEarth(2),'y').^2+i2b(tableH(:,3)-IEarth(3),'z').^2);

numberOfSweeps = 32;

tableH(:,10) =sqrt(sigInstrumentPrecision^2 + sigStatPeak1^2/numberOfSweeps +...
    sigXatMax^2 + (sigSweepRateCorrectionError.*(tableH(:,8)-tableH(:,7))./tableH(:,9)).^2)...
    *0.001.*(tableH(:,8)-tableH(:,7))./tableH(:,9)+...
    469.6848*sqrt(i2b(tableH(:,1) - IEarth(1),'x').^4.*((sigi^2+sigIEarth(1)^2)./(tableH(:,1) - IEarth(1)).^2+sigRelCoilRadius(1)^2)+...
    i2b(tableH(:,2) - IEarth(2),'y').^4.*((sigi^2+sigIEarth(2)^2)./(tableH(:,2) - IEarth(2)).^2+sigRelCoilRadius(2)^2)+...
    i2b(tableH(:,3) - IEarth(3),'z').^4.*((sigi^2+sigIEarth(3)^2)./(tableH(:,3) - IEarth(3)).^2+sigRelCoilRadius(3)^2))./Btotal;

tableH(:,11) =sqrt(sigInstrumentPrecision^2 + sigStatPeak1^2/numberOfSweeps +...
    sigXatMax^2 + (sigSweepRateCorrectionError.*(tableH(:,8)-tableH(:,7))./tableH(:,9)).^2)...
    *0.001.*(tableH(:,8)-tableH(:,7))./tableH(:,9)+...
    705.2103*sqrt(i2b(tableH(:,1) - IEarth(1),'x').^4.*((sigi^2+sigIEarth(1)^2)./(tableH(:,1) - IEarth(1)).^2+sigRelCoilRadius(1)^2)+...
    i2b(tableH(:,2) - IEarth(2),'y').^4.*((sigi^2+sigIEarth(2)^2)./(tableH(:,2) - IEarth(2)).^2+sigRelCoilRadius(2)^2)+...
    i2b(tableH(:,3) - IEarth(3),'z').^4.*((sigi^2+sigIEarth(3)^2)./(tableH(:,3) - IEarth(3)).^2+sigRelCoilRadius(3)^2))./Btotal;

% %plot the total B field calculated from Helmholtz currents and measured by
% %   the magnetometer
% figure
% plot(Btotal,x(:,4)*0.001,'.')
% title('Magnetic Field Consistency Check')
% xlabel('Magnitude of B Calculated from Currents [G]')
% ylabel('B Measured by Magnetometer [G]')
% %seems to be a mismatch between positive and negative readings
% figure
% plot(Btotal,abs(x(:,4)*0.001),'.')
% title('Magnetic Field Consistency Check')
% xlabel('Magnitude of B Calculated from Currents [G]')
% ylabel('Magnitude of B Measured by Magnetometer [G]')

subplot(2,2,2)
% Table H: First Peak
	indices = ~isnan(tableH(:,5));
	resFreqOne = tableH(indices,5)./tableH(indices,9); %convert into fraction of sweep
	resFreqOne = tableH(indices,7) + resFreqOne.*(tableH(indices,8)-tableH(indices,7)); %convert into kHz
	display('First Peak Frequency vs. B')
	fitH1 = linearFit(Btotal(indices),resFreqOne - fitA.a*(tableH(indices,8)-tableH(indices,7))./tableH(indices,9),tableH(indices,10)) %correction in arg2: 200 kHz is the sweep rate
	%plot model
	hold on
	plot(Btotal(indices),466.54*Btotal(indices),'-r')
	%annotate
	title('Table H: Peak 1')
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
	fontSize(14)
	%print results
	display('Expected g*mu_B/h = 4.665415e9')
	display(['Measured: ',num2str(fitH1.a*1e7,'%10.5e'),' \pm ', num2str(fitH1.aerr*1e7,'%10.5e')])

subplot(2,2,4)
% Tabel H: Second Peak
	indices = ~isnan(tableH(:,6));
	resFreqTwo = tableH(indices,6)./tableH(indices,9); %convert into fraction of sweep
	resFreqTwo = tableH(indices,7) + resFreqTwo.*(tableH(indices,8)-tableH(indices,7)); %convert into kHz
	display('First Peak Frequency vs. B')
	fitH2 = linearFit(Btotal(indices),resFreqTwo - fitA.a*(tableH(indices,8)-tableH(indices,7))./tableH(indices,9),tableH(indices,11)) %correction in arg2: 200 kHz is the sweep rate
	%plot model
	hold on
	plot(Btotal(indices),699.81*Btotal(indices),'-r')
	%annotate
	title('Table H: Peak 2')
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
	fontSize(14)
	%print 
	display('Expected g*mu_B/h = 6.998123e9')
	display(['Measured: ',num2str(fitH2.a*1e7,'%10.5e'),' \pm ', num2str(fitH2.aerr*1e7,'%10.5e')])
%% Combining the Tables

x = [tableB;tableH];
Btotal = sqrt(i2b(x(:,1) - IEarth(1),'x').^2+i2b(x(:,2)-IEarth(2),'y').^2+i2b(x(:,3)-IEarth(3),'z').^2);
    %First Peak_______________
	indices = ~isnan(x(:,5));
	resFreqOne = x(indices,5)./x(indices,9); %convert into fraction of sweep
	resFreqOne = x(indices,7) + resFreqOne.*(x(indices,8)-x(indices,7)); %convert into kHz
	display('First Peak Frequency vs. B')
    figure
    subplot(2,1,1)
	fitResFixB1 = linearFit(Btotal(indices),resFreqOne - fitA.a*(x(indices,8)-x(indices,7))./x(indices,9),x(indices,10)) %correction in arg2: 200 kHz is the sweep rate; mysterious factor of 2
	%plot model
	hold on
	plot(Btotal(indices),466.54*Btotal(indices),'-r')
	%annotate
	title('Zeeman Resonance Frequencies for Rb 85 in a Fixed Magnetic Field')
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
	fontSize(16)
    %plot residuals
    subplot(2,1,2)
    plot(Btotal(indices),fitResFixB1.residuals,'.')
    ylabel('Residuals [kHz]')
	%print results
	display('Expected g*mu_B/h = 4.665415e9')
	display(['Measured: ',num2str(fitResFixB1.a*1e7,'%10.5e'),' \pm ', num2str(fitResFixB1.aerr*1e7,'%10.5e')])

    %Second Peak_______________
    indices = ~isnan(x(:,6));
	resFreqTwo = x(indices,6)./x(indices,9); %convert into fraction of sweep
	resFreqTwo = x(indices,7) + resFreqTwo.*(x(indices,8)-x(indices,7)); %convert into kHz
	display('Second Peak Frequency vs. B')
    figure
    subplot(2,1,1)
	fitResFixB2 = linearFit(Btotal(indices),resFreqTwo - fitA.a*(x(indices,8)-x(indices,7))./x(indices,9),x(indices,11)) %correction in arg2: 200 kHz is the sweep rate
	%plot model
	hold on
	plot(Btotal(indices),699.81*Btotal(indices),'-r')
	%annotate
	title('Zeeman Resonance Frequencies for Rb 87 in a Fixed Magnetic Field')
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
    %plot residuals
    subplot(2,1,2)
    plot(Btotal(indices),fitResFixB2.residuals,'.')
    ylabel('Residuals [kHz]')
	fontSize(16)
	%print 
	display('Expected g*mu_B/h = 6.998123e9')
	display(['Measured: ',num2str(fitResFixB2.a*1e7,'%10.5e'),' \pm ', num2str(fitResFixB2.aerr*1e7,'%10.5e')])

%% Table I: DC Couplng
    
x = [tableI];
Btotal = sqrt(i2b(x(:,1) - IEarth(1),'x').^2+i2b(x(:,2)-IEarth(2),'y').^2+i2b(x(:,3)-IEarth(3),'z').^2);

tableI(:,10) =sqrt(sigInstrumentPrecision^2 + sigStatPeak1^2/numberOfSweeps +...
    sigXatMax^2 + (sigSweepRateCorrectionError.*(tableI(:,8)-tableI(:,7))./tableI(:,9)).^2)...
    *0.001.*(tableI(:,8)-tableI(:,7))./tableI(:,9)+...
    469.6848*sqrt(i2b(tableI(:,1) - IEarth(1),'x').^4.*((sigi^2+sigIEarth(1)^2)./(tableI(:,1) - IEarth(1)).^2+sigRelCoilRadius(1)^2)+...
    i2b(tableI(:,2) - IEarth(2),'y').^4.*((sigi^2+sigIEarth(2)^2)./(tableI(:,2) - IEarth(2)).^2+sigRelCoilRadius(2)^2)+...
    i2b(tableI(:,3) - IEarth(3),'z').^4.*((sigi^2+sigIEarth(3)^2)./(tableI(:,3) - IEarth(3)).^2+sigRelCoilRadius(3)^2))./Btotal;

tableI(:,11) =sqrt(sigInstrumentPrecision^2 + sigStatPeak1^2/numberOfSweeps +...
    sigXatMax^2 + (sigSweepRateCorrectionError.*(tableI(:,8)-tableI(:,7))./tableI(:,9)).^2)...
    *0.001.*(tableI(:,8)-tableI(:,7))./tableI(:,9)+...
    705.2103*sqrt(i2b(tableI(:,1) - IEarth(1),'x').^4.*((sigi^2+sigIEarth(1)^2)./(tableI(:,1) - IEarth(1)).^2+sigRelCoilRadius(1)^2)+...
    i2b(tableI(:,2) - IEarth(2),'y').^4.*((sigi^2+sigIEarth(2)^2)./(tableI(:,2) - IEarth(2)).^2+sigRelCoilRadius(2)^2)+...
    i2b(tableI(:,3) - IEarth(3),'z').^4.*((sigi^2+sigIEarth(3)^2)./(tableI(:,3) - IEarth(3)).^2+sigRelCoilRadius(3)^2))./Btotal;

    %First Peak_______________
	indices = ~isnan(x(:,5));
	resFreqOne = x(indices,5)./x(indices,9); %convert into fraction of sweep
	resFreqOne = x(indices,7) + resFreqOne.*(x(indices,8)-x(indices,7)); %convert into kHz
	display('DC Coupled: First Peak Frequency vs. B')
    figure
    subplot(2,1,1)
	fitI1 = linearFit(Btotal(indices),resFreqOne - fitA.a*(x(indices,8)-x(indices,7))./x(indices,9),x(indices,10)) 
	%plot model
	hold on
	plot(Btotal(indices),466.54*Btotal(indices),'-r')
	%annotate
	title({'Zeeman Resonance Frequencies for Rb 85 in a Fixed Magnetic Field','Scope is DC Coupled'})
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
	fontSize(16)
    %plot residuals
    subplot(2,1,2)
    plot(Btotal(indices),fitI1.residuals,'.')
    ylabel('Residuals [kHz]')
	%print results
	display('Expected g*mu_B/h = 4.665415e9')
	display(['Measured: ',num2str(fitI1.a*1e7,'%10.5e'),' \pm ', num2str(fitI1.aerr*1e7,'%10.5e')])

    %Second Peak_______________
    indices = ~isnan(x(:,6));
	resFreqTwo = x(indices,6)./x(indices,9); %convert into fraction of sweep
	resFreqTwo = x(indices,7) + resFreqTwo.*(x(indices,8)-x(indices,7)); %convert into kHz
	display('DC Coupled: Second Peak Frequency vs. B')
    figure
    subplot(2,1,1)
	fitI2 = linearFit(Btotal(indices),resFreqTwo - fitA.a*(x(indices,8)-x(indices,7))./x(indices,9),x(indices,11)) %correction in arg2: 200 kHz is the sweep rate
	%plot model
	hold on
	plot(Btotal(indices),699.81*Btotal(indices),'-r')
	%annotate
	title({'Zeeman Resonance Frequencies for Rb 87 in a Fixed Magnetic Field','Scope is DC Coupled'})
	xlabel('Total Magnetic Field [G]')
	ylabel('Resonance Frequency [kHz]')
    %plot residuals
    subplot(2,1,2)
    plot(Btotal(indices),fitI2.residuals,'.')
    ylabel('Residuals [kHz]')
	fontSize(16)
	%print 
	display('Expected g*mu_B/h = 6.998123e9')
	display(['Measured: ',num2str(fitI2.a*1e7,'%10.5e'),' \pm ', num2str(fitI2.aerr*1e7,'%10.5e')])
    
%% Statistical Variation in the Determination of the Peaks
peaks = zeros(8,2);
j = 0;
for i = [13:19,21]
    j = j+1;
    [~,indices] = findpeaks(data{i}.data(:,2),'MINPEAKHEIGHT',.0005,'MINPEAKDISTANCE',100);
    peaks(j,1:2) = indices';
end
[~,averagedPeaks] = findpeaks(data{i}.data(:,2),'MINPEAKHEIGHT',.002,'MINPEAKDISTANCE',100);
averagedPeaks = averagedPeaks';
display(['Sample Standard Deviation of Peak 1 from 8 runs: ',num2str(std(peaks(:,1)))]);
display(['Sample Standard Deviation of Peak 2 from 8 runs: ',num2str(std(peaks(:,2)))]);
%% Final Steps
    
%cleanup
	clear indices resFreqOne resFreqTwo Btotal x i j indices peaks averagedPeaks
    clear sigIEarth sigRelCoilRadius sigi sigSweepRateCorrectionError sigXatMax numberOfSweeps
    clear sigStatPeak1 sigStatPeak2 sigInstrumentPrecision