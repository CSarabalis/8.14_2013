function bananas = findPeaks(data,index)
% fuck yourself cunt
plot(data{index}.bal,'.')
title(data{index}.name)
%[x y] = ginput;

maxY = max(data{index}.bal);
minY = min(data{index}.bal);

shifts = sort(data{index}.peakIndices);
shifts_x = shifts;
% shifts = sort(shifts,1,'descend');
% 
% shifts_length = abs(shifts(end)-shifts(1));
% x_length = abs(x(end)-x(1));
% grad = x_length/shifts_length;
% 
% shifts_x = grad*shifts + x(1);

for i=1:max(size(shifts_x))
    line([shifts_x(i) shifts_x(i)],[minY maxY],'Color','r')
    text(shifts_x(i), maxY, [num2str(10^3*data{index}.shiftsDiff(i),4) 'MHz'])
end


end