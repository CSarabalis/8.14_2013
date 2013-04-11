function bananas = getOrders(data, index)

% get m (refrac order) of peak. MUST start with 'down' i.e. back of the
% sine wave
figure()
plot(data{index}.time, data{index}.fp,'.')
title(data{index}.name)
[x y] = ginput;

%data{index}.peakOrder=[];
for i=1:max(size(x))
    data{index}.peakPositions(:,1)
    
    % WRITE A FUNCTION THAT FIGURES OUT WHICH BIN (m) THE PEAK IS IN
    
    %da{index}.peakOrder=[da{index}.peakOrder
end

bananas = {x y n bin};

end
