function bananas = plotPSD(data)

Xpsd = 20*log10(abs(data.Xpsd));
Ypsd = 20*log10(abs(data.Ypsd));
freqs = data.psdFreqs*10^-3;

% plots
figure
subplot(2,1,1)
plot(freqs,Xpsd,'.');
text(25,-75,{['V$_{pp}$ = ' num2str(data.Vpp) 'V'], ['$f$ = ' num2str(data.freq)],...
    ['WF: ' data.waveForm], ['Bead: ' data.bead]})
xlabel('Frequency [kHz]')
ylabel('Power/frequency [dB/Hz]')
subplot(2,1,2)
plot(freqs,Ypsd,'.');
text(25,-75,{['V$_{pp}$ = ' num2str(data.Vpp) 'V'], ['$f$ = ' num2str(data.freq)],...
    ['WF: ' data.waveForm], ['Bead: ' data.bead]})
xlabel('Frequency [kHz]')
ylabel('Power/frequency [dB/Hz]')

bananas = 1;

end