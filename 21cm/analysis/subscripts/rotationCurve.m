%smoothPlotIndices(longscan1, 73,10)

data = longscan1;
index = 73;

a=data(index);
span = 10;
smooth(a.counts,span)