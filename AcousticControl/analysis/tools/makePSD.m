function bananas = makePSD(data)

x = data.qpdX;
y = data.qpdY;

Fs = data.sampleRate;
t = 1/Fs:1/Fs:data.intTime;

% Create a single-sided spectrum (X)
nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;
Xpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs); 

% Create a single-sided spectrum (Y)
nfft = 2^nextpow2(length(y));
Pxx = abs(fft(y,nfft)).^2/length(y)/Fs;
Ypsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs);

data.Xpsd = Xpsd.Data;
data.Ypsd = Ypsd.Data;
data.psdFreqs = Xpsd.Frequencies;

bananas = data;

end