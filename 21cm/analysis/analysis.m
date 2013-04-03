setup

%radFileParser('../data/1309118.rad','04-01-13')
data=radFileParser('../data/galx150to210.rad','04-03-13');

for i=1:7
    figure()
    roughPlot(data,i)
end

%indices = cutTheJunkOut(data(i).counts,data(i).counts,200,100)