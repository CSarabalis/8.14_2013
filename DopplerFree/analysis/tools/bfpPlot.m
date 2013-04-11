function bananas = bfpPlot(data,index)

data=data{index}

subplot(2,1,1)
plot(data.time,data.bal,'.')
xlabel('Time [sec]')
ylabel('Bal voltage')
title(data.name)

subplot(2,1,2)
plot(data.time, data.fp,'.')
xlabel('Time [sec]')
ylabel('FP voltage')
title('Fabry-Perot output')

end