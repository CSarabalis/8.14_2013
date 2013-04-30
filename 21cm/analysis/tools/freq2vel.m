function bananas = freq2vel(freqs)

% freqs is assumed to be in MHz
% vel outputs in km/sec

x = freqs-1420.4; % subtract hydrogen hf line to convert to doppler shifts
dopplerFactor = 2.998e8/1420.4e6; % c/f_0, converts df to dv
x = x*10^6*dopplerFactor/10^3;

bananas = x;

end