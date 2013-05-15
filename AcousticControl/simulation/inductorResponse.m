R = 130; % ohms
C = 1e-12; % farads
L = 2.3e-4; % henries
w0 = 1/sqrt(L*C); % rads per second
f0 = w0/(2*pi); % hertz 
vRMS = 1; % volts
volume = 1e-6; %m^3
mu = 1.26e-6; %H/m

w = [1e5:1e5:1e7];
vInd = vRMS.*(w.*L).*(sqrt(R.^2+(w.*L - 1./(w.*C)).^2)).^-1;
iRMS = vRMS.*(sqrt(R.^2+(w.*L - 1./(w.*C)).^2)).^-1;

EnergyInd = 0.5*L.*iRMS.^2;
EnergyDensity = EnergyInd./volume;
B = sqrt(2*mu.*EnergyDensity);
f = w.*(2*pi);

figure()
subplot(2,1,1)
plot(f,vInd, '.')
xlabel('Frequency [Hz]')
ylabel('V_L')
subplot(2,1,2)
plot(f,B*1e4,'.')
xlabel('Frequency [Hz]')
ylabel('B [G]')