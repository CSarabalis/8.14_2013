%% Startup
res='n'
setup

%% fabry-perot analysis

for i=data_indices(68:end)
    x = da{i};
    L = max(size(x.time));
    Fs = (x.time(2)-x.time(1))^(-1);
    NFFT = 2^nextpow2(L);
    Y = fft(x.fp,NFFT)/L;
    f = Fs/2*linspace(0,1,NFFT/2+1);
    
    figure()
    subplot(2,1,1)
    plot(f(2:end), 2*abs(Y(2:NFFT/2+1)), '.')
    subplot(2,1,2)
    plot(x.time, x.fp,'.')
    %xlabel('Frequency [Hz]')
    %ylabel('FT of voltage')
    title(x.name)
end

clear i x Y

%% get peak freq diffs

% fp vals
i=42;

fp = da{i}.fp(da{i}.peakIndices);

amp = 0.0111; % sin amplitude
offset = -0.308; % sin offset

m=da{i}.peakOrder;
shifts = asin((fp-offset)./amp);

% convert arcsin into freq diffs

shifts = (-1).^(m+1).*shifts+(m+1/2)*pi; % convert arcsin into phase diffs
shifts = sort(shifts/(2*pi)); % convert phase diffs to wavenumbers and sort
shifts = shifts-shifts(1); % normalize to first peak

L = 0.4655;  % length of FP
uncert_L = 0.005;  % uncert in length of FP
c = 2.998*10^8;  % speed of light
n_air = 1.000277;  % refractive index of air
fsr = c/(2*n_air*L); % calculate free spectral range of FP

shifts = shifts*fsr/10^9;  % get frequencies in GHz
shifts_diff = [0; diff(shifts)];  % get freq diffs in GHz

clear i L uncert_L c n_air fsr m amp offset fp






