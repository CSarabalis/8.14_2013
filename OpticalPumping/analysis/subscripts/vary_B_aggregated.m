% fixed X,Y currents
Bfixed_D = [166.0 -19.28];
Bfixed_E = [165.0 -20];
Bfixed_G = [148.4 -19.24];

% sweep characteristics D;E;G
SweepChars = [2 1; 2 0.2; 1.2 0.5];

% create the aggregated data table
% agg = [RF fixed freq, peak 2, peak 1, uncert 2, uncert 1, fixed I_x,
% fixed I_y, Volts(pp), sweep rate (Hz)]
agg = [tableD(:,1:5) Bfixed_D(1)*ones(size(tableD,1),1) ...
    Bfixed_D(2)*ones(size(tableD,1),1) SweepChars(1,1)*ones(size(tableD,1),1) ...
    SweepChars(1,2)*ones(size(tableD,1),1) ...
    ; tableE(:,1:5) Bfixed_E(1)*ones(size(tableE,1),1) ...
    Bfixed_E(2)*ones(size(tableE,1),1) SweepChars(2,1)*ones(size(tableE,1),1) ...
    SweepChars(2,2)*ones(size(tableE,1),1) ...
    ; tableG(:,1) (tableG(:,3)+tableG(:,5))/2 ...
    (tableG(:,2)+tableG(:,4))/2 tableG(:,7) tableG(:,6) ...
    Bfixed_G(1)*ones(size(tableG,1),1) Bfixed_G(2)*ones(size(tableG,1),1) ...
    SweepChars(3,1)*ones(size(tableG,1),1) SweepChars(3,2)*ones(size(tableG,1),1)];

% indices for each table
D_indices = [1:7];
E_indices = [8:11];
G_indices = [12:15];

figure()
hold all

Btotal = sqrt(i2b(agg(:,6) - IEarth(1),'x').^2+i2b(agg(:,7)-IEarth(2),'y').^2 ...
    +i2b(v2i(1e-3*agg(:,3))-IEarth(3),'z').^2);
errorbar(agg(:,1),Btotal,i2b(v2i(1e-3*agg(:,5)),'z'),'*')

Btotal = sqrt(i2b(agg(:,6) - IEarth(1),'x').^2+i2b(agg(:,7)-IEarth(2),'y').^2 ...
    +i2b(v2i(1e-3*agg(:,2))-IEarth(3),'z').^2);
errorbar(agg(:,1),Btotal,i2b(v2i(1e-3*agg(:,4)),'z'),'*')
title({'Agreggated :: Fixed Frequency, Varied B','Raw Data'})
xlabel('Resonance Frequency [kHz]')
ylabel('Total Magnetic Field [G]')
%fontSize(16)


%% fits

% get total Bfield :: peak 1
Btotal1 = sqrt(i2b(agg(:,6) - IEarth(1),'x').^2+i2b(agg(:,7)-IEarth(2),'y').^2 ...
    +i2b(v2i(1e-3*agg(:,3))-IEarth(3),'z').^2);

% get total Bfield :; peak 2
Btotal2 = sqrt(i2b(agg(:,6) - IEarth(1),'x').^2+i2b(agg(:,7)-IEarth(2),'y').^2 ...
    +i2b(v2i(1e-3*agg(:,2))-IEarth(3),'z').^2);

Btotal = [Btotal1 Btotal2];

%   currently doesn't take into account signal lag from tableA
figure
subplot(3,2,1)
D1 = fitagg('D',1,agg,Btotal)
subplot(3,2,2)
D2 = fitagg('D',2,agg,Btotal)
subplot(3,2,3)
E1 = fitagg('E',1,agg,Btotal)
subplot(3,2,4)
E2 = fitagg('E',2,agg,Btotal)
subplot(3,2,5)
G1 = fitagg('G',1,agg,Btotal)
subplot(3,2,6)
G2 = fitagg('G',2,agg,Btotal)


%% Investigate effect of sweep characteristics on results

shite = [D1; D2; E1; E2; G1; G2];
sweeps = [2 1; 2 1; 2 0.2; 2 0.2; 1.2 0.5; 1.2 0.5];
bdvld = [];
for i=1:6
    bdvld = [bdvld; shite(i).a sweeps(i,:) shite(i).aerr];
end
figure
subplot(3,1,1)
plot(bdvld(:,2).*bdvld(:,3),bdvld(:,1),'*')
ind1 = [1 3];
ind2 = [2 4];
subplot(2,1,1)
peak1 = linearFit(bdvld(ind1,2).*bdvld(ind1,3),bdvld(ind1,1),bdvld(ind1,4))
subplot(2,1,2)
peak2 = linearFit(bdvld(ind2,2).*bdvld(ind2,3),bdvld(ind2,1),bdvld(ind2,4))

%Peak 1 sweep rate dependence
% dB/df = 3.46e-05 SR + 0.00183
%Peak 2 sweep rate dependence
% dB/df = 2.12e-05 SR + 0.00124


% This implies that the true dB/df for peak 1 is 0.00183
%                       true dB/df for peak 2 is 0.00124

%% calculations

gf1mub = peak1.b;
uncert_gf1mub = peak1.berr;

gf2mub = peak2.b;
uncert_gf2mub = peak2.berr;

gf1ongf2 = gf1mub/gf2mub
uncert_gf2ongf1 = sqrt(uncert_gf1mub^2/gf2mub^2 + (uncert_gf2mub*gf1mub/gf2mub^2)^2)

clear gf1mub gf2mub uncert_gf1mub uncert_gf2mub bdvld shite sweeps ind1 ...
    ind2 peak1 peak2 Btotal Btotal1 Btotal2 D1 D2 E1 E2 G1 G2 SweepChars ...
    Bfixed_D Bfixed_E Bfixed_G D_indices E_indices G_indices i agg

