function bananas = smoothPlot(data, index, span)

a=data(index);

plot(a.freq, smooth(a.counts,span),'.')

title(['Index: ' num2str(index)])
xlabel('Frequency [MHz]')
ylabel('Counts')

plotText = {['Time = ' a.timeText],['Az, El (+ Offset) = ' num2str(a.az) ', ' num2str(a.el)...
    ' + (' num2str(a.az_offset) ', ' num2str(a.el_offset) ')'],...
    ['Glon, Glat = ' num2str(a.glon) ', ' num2str(a.glat)],...
    ['Mode = ' num2str(a.mode) ', NumPoints = ' num2str(a.numPoints)]};

text(1420,60,plotText);


end