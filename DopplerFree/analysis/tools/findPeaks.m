function bananas = findPeaks(data,index)

plot(data{index}.bal,'.')
[x y] = ginput;

maxY = max(data{index}.bal);
minY = min(data{index}.bal);

shifts = data{index}.shifts;

shifts_length = shifts(end)-shifts(1);
x_length = x(end)-x(1);
grad = x_length/shifts_length;

shifts_x = grad*shifts + x(1);

for i=1:max(size(shifts_x))
    line([shifts_x(i) shifts_x(i)],[minY maxY])
    text(shifts_x(i), maxY, num2str(shifts(i)))
end


end