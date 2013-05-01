function bananas = storePeaks(data,index)

a=data{index};

SlopeThreshold = 0.0; % downward slope (d2y/dx2) threshold for peak detection (very finnicky, needs to be tuned well)
AmpThreshold = 0.5; % y-threshold for peak amplitude
span = 3; % span of smoothing slider
peakgroup = 10; % number of points around the max that are considered part of the tip of the peak
smoothtype = 3; % 1=single pass (rectangular), 2=double pass (triangular), 3=triple pass (~gaussian)

a.P = findPeaks(a.vel, smooth3(a.counts,5), SlopeThreshold, AmpThreshold, span, peakgroup, smoothtype);

data{index} = a;

bananas = data;

end