function [] = plotBalFP( data )
%plotBalFP Plots col i in suplot 1 and j in 2

figure
subplot(2,1,1)
plot(data.bal,'.')
subplot(2,1,2)
plot(data.fp,'.')

end

