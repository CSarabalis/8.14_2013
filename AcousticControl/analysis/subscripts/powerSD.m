%% may 14

for i=1:5
data = may14{i};
x = data.qpdX;
y = data.qpdY;

Fs = data.sampleRate;
t = 1/Fs:1/Fs:data.intTime;
nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;

% Create a single-sided spectrum
Xpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs); 
figure
plot(Xpsd);

nfft = 2^nextpow2(length(y));
Pxx = abs(fft(y,nfft)).^2/length(y)/Fs;

% Create a single-sided spectrum
Ypsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs); 
figure
plot(Ypsd);
end


%% may 16
%for i=1:2
i=1;
data = may16{i};
x = data.qpdX;
y = data.qpdY;

Fs = data.sampleRate;
t = 1/Fs:1/Fs:data.intTime;
nfft = 2^nextpow2(length(x));
Pxx = abs(fft(x,nfft)).^2/length(x)/Fs;

% Create a single-sided spectrum
Xpsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs); 
figure
plot(Xpsd);

nfft = 2^nextpow2(length(y));
Pxx = abs(fft(y,nfft)).^2/length(y)/Fs;

% Create a single-sided spectrum
Ypsd = dspdata.psd(Pxx(1:length(Pxx)/2),'Fs',Fs); 
figure
plot(Ypsd);
%end