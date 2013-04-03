setup

radFileParser('../data/1309118.rad','04-01-13')

i=3;

figure()
roughPlot(data,i)

indices = cutTheJunkOut(data(i).counts,data(i).counts,200,100)