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
