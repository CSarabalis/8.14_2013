function bananas = getOrders(data, index)

% get m (refrac order) of peak. MUST start with 'down' i.e. back of the
% sine wave
figure()
plot(data{index}.time, data{index}.fp,'.')
title(data{index}.name)
[x y] = ginput;

data{index}.peakOrder=mBin(data{index}.peakPositions(:,1),x);

bananas = data;

end
