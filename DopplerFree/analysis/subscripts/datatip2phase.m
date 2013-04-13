function [ phases ] = datatip2phase( data, peaks, wave, prec )
%datatip2phase Takes data struct and two structures exported from data tips
%   the first with peak info the second with sin wave info, 
%   and arcsinifies the information.

%grab # of peaks
numPeak = length(peaks);

%pull out peak positions
x = zeros(numPeak, 1);
for i = 1:numPeak
  x(i) = peaks(i).Position(1);
end

%sort peaks ascending
x = sort(x);

%get FP values
y = zeros(numPeak,1);
for i = 1:numPeak
  y(i) = data.fp(x(i));
end

%pull out amplitude and offset
amplitude = abs(wave(1).Position(2)-wave(2).Position(2))/2 - prec;
offset = mean([wave(1).Position(2);wave(2).Position(2)]);

%store final values
phases = asin((y - offset)/amplitude);

end

