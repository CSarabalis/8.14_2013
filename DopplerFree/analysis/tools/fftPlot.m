function bananas = fftPlot(data,index,t)

    x = data{index};
    L = max(size(x.time(t)));
    Fs = (x.time(2)-x.time(1))^(-1);
    NFFT = 2^nextpow2(L);
    Y = fft(x.fp(t)-mean([max(x.fp(t)),min(x.fp(t))]),NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    subplot(2,1,1)
    plot(f(2:end), 2*abs(Y(2:NFFT/2+1)), '.')
    subplot(2,1,2)
    plot(x.time(t), x.fp(t),'.')
    %xlabel('Frequency [Hz]')
    %ylabel('FT of voltage')
    title(x.name)
    
    bananas = Y*L;

end