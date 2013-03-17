%% Fixed Frequency, Sweep B: Table D and G

ramp = tableD;
triangleUpramp = tableE([1,3],:);
triangleDownramp = tableE([2,4],:);
triangleUpramp2 = tableG([1,3],:);
triangleDownramp2 = tableG([2,4],:);


%% Table D
% Sweep Characteristics: Ramp, 2Vpp, 1Hz

Bfixed = [166.0 -19.28];
% linear fit of peak 1
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*ramp(:,3))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
figure
subplot(2,1,1)
fitD1 = linearFit(Btotal,ramp(:,1),i2b(v2i(ramp(:,5)),'z'))
%plot model
hold on
plot(Btotal,fitD1.a*Btotal+fitD1.b,'-r')
%annotate
title({'Table D :: Fixed Frequency, Varied B','Peak 1, Ramp 2 V/s'})
ylabel('Resonance Frequency [kHz]')
xlabel('Total Magnetic Field [G]')
fontSize(16)

% linear fit of peak 2
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*ramp(:,2))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
%figure
subplot(2,1,2)
fitD2 = linearFit(Btotal,ramp(:,1),i2b(v2i(ramp(:,4)),'z'))
%plot model
hold on
plot(Btotal,fitD2.a*Btotal+fitD2.b,'-r')
%annotate
title({'Table D :: Fixed Frequency, Varied B','Peak 2, Ramp 2 V/s'})
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)



%% Table E
% Temp: 40.2C
% Sweep Characteristics: Triangle, 2Vpp, 0.2Hz

Bfixed = [165.9 -19.30];
% linear fit of peak 1
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleUpramp(:,3))-IEarth(3),'z').^2);

% Up ramps
%   currently doesn't take into account signal lag from tableA
figure
subplot(2,1,1)
fitE1U = linearFit(Btotal,triangleUpramp(:,1),i2b(v2i(triangleUpramp(:,5)),'z'))
%plot model
hold on
plot(Btotal,fitE1U.a*Btotal+fitE1U.b,'-r')
%annotate
title({'Table E :: Fixed Frequency, Varied B','Peak 1'})
ylabel('Resonance Frequency [kHz]')
xlabel('Total Magnetic Field [G]')
fontSize(16)

% linear fit of peak 2
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleUpramp(:,2))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
%figure
subplot(2,1,2)
fitE2U = linearFit(Btotal,triangleUpramp(:,1),i2b(v2i(triangleUpramp(:,4)),'z'))
%plot model
hold on
plot(Btotal,fitE2U.a*Btotal+fitE2U.b,'-r')
%annotate
title({'Table E :: Fixed Frequency, Varied B','Peak 2'})
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)

% Down ramps
Bfixed = [166.0 -19.28];
% linear fit of peak 1
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleDownramp(:,3))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
figure
subplot(2,1,1)
fitE1D = linearFit(Btotal,triangleDownramp(:,1),i2b(v2i(triangleDownramp(:,5)),'z'))
%plot model
hold on
plot(Btotal,fitE1D.a*Btotal+fitE1D.b,'-r')
%annotate
title({'Table E :: Fixed Frequency, Varied B','Peak 1, Down ramp'})
ylabel('Resonance Frequency [kHz]')
xlabel('Total Magnetic Field [G]')
fontSize(16)

% linear fit of peak 2
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleDownramp(:,2))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
%figure
subplot(2,1,2)
fitE2D = linearFit(Btotal,triangleDownramp(:,1),i2b(v2i(triangleDownramp(:,4)),'z'))
%plot model
hold on
plot(Btotal,fitE2D.a*Btotal+fitE2D.b,'-r')
%annotate
title({'Table E :: Fixed Frequency, Varied B','Peak 2, Down ramp'})
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)



%% Table G
% Temp: 42.1C
% Sweep characteristics: Triangle, 1.2Vpp, 0.5Hz

% Up ramps
Bfixed = [148.4 -19.24];
% linear fit of peak 1
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleUpramp2(:,2))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
figure
subplot(2,1,1)
fitG1U = linearFit(Btotal,triangleUpramp2(:,1),i2b(v2i(triangleUpramp2(:,6)),'z'))
%plot model
hold on
plot(Btotal,fitG1U.a*Btotal+fitG1U.b,'-r')
%annotate
title({'Table G :: Fixed Frequency, Varied B','Peak 1'})
ylabel('Resonance Frequency [kHz]')
xlabel('Total Magnetic Field [G]')
fontSize(16)

% linear fit of peak 2
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleUpramp2(:,3))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
%figure
subplot(2,1,2)
fitG2U = linearFit(Btotal,triangleUpramp2(:,1),i2b(v2i(triangleUpramp2(:,7)),'z'))
%plot model
hold on
plot(Btotal,fitG2U.a*Btotal+fitG2U.b,'-r')
%annotate
title({'Table G :: Fixed Frequency, Varied B','Peak 2'})
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)


% Down ramps
Bfixed = [148.4 -19.24];
% linear fit of peak 1
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleDownramp2(:,2))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
figure
subplot(2,1,1)
fitG1D = linearFit(Btotal,triangleDownramp2(:,1),i2b(v2i(triangleDownramp2(:,6)),'z'))
%plot model
hold on
plot(Btotal,fitG1D.a*Btotal+fitG1D.b,'-r')
%annotate
title({'Table G :: Fixed Frequency, Varied B','Peak 1, Down ramp'})
ylabel('Resonance Frequency [kHz]')
xlabel('Total Magnetic Field [G]')
fontSize(16)

% linear fit of peak 2
Btotal = sqrt(i2b(Bfixed(1) - IEarth(1),'x').^2+i2b(Bfixed(2)-IEarth(2),'y').^2+i2b(v2i(1e-3*triangleDownramp2(:,3))-IEarth(3),'z').^2);

%   currently doesn't take into account signal lag from tableA
%figure
subplot(2,1,2)
fitG2D = linearFit(Btotal,triangleDownramp2(:,1),i2b(v2i(triangleDownramp2(:,7)),'z'))
%plot model
hold on
plot(Btotal,fitG2D.a*Btotal+fitG2D.b,'-r')
%annotate
title({'Table G :: Fixed Frequency, Varied B','Peak 2, Down ramp'})
ylabel('Resonance Frequency [kHz]')
xlabel('Magnetic Field in the Z [G]')
fontSize(16)

%% taking a look at the discrepancy between sweep characteristics
figure
hold on
plot(ramp(:,1),ramp(:,2),'.b')
plot(triangleDownramp(:,1),triangleDownramp(:,2),'.r')
plot(triangleUpramp(:,1),triangleUpramp(:,2),'.g')
plot(triangleDownramp2(:,1),triangleDownramp2(:,2),'.c')
plot(triangleUpramp2(:,1),triangleUpramp2(:,2),'.m')
% repeat each plot for second peak as well

legend('Table D amp','Table E downramp','Table E upramp','Table G downramp',...
    'Table G upramp')
%annotate
title('Fixed Frequency, Varied B: Discepancy from Sweep Characteristics')
ylabel('Resonance Field [mV]')
xlabel('RF Frequency [kHz]')
fontSize(16)

%% comparing change over time of the points
figure
hold on
title({'Change from Day to Day','Need to Compute Total B'})
upIndicies = find(tableG(:,11));
errorbar(i2b(v2i(1e-3*tableG(upIndicies,2))-IEarth(3),'z'),tableG(upIndicies,1),tableG(upIndicies,6),'.g')
errorbar(i2b(v2i(1e-3*tableG(upIndicies,4))-IEarth(3),'z'),tableG(upIndicies,1),tableG(upIndicies,6),'.r')
errorbar(i2b(v2i(1e-3*ramp(:,3))-IEarth(3),'z'),ramp(:,1),i2b(v2i(ramp(:,5)),'z'),'.')

%% clean-up

clear ramp triangleDownramp triangleDownramp2 triangleUpramp triangleUpramp2 ...
    Bfixed Btotal fitD1 fitD2 fitE1U fitE2D fitE2U fitE2D fitG1U fitG2D fitG2U ...
    fitG2D upIndicies