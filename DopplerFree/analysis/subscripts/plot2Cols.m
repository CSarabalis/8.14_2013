function [] = plotBalFp( data, i, j )
%plot2Cols Plots col i in suplot 1 and j in 2

figure
subplot(2,1,1)
plot(data.bal(:,i),'.')
subplot(2,1,2)
plot(data.fp(:,j),'.')

end

