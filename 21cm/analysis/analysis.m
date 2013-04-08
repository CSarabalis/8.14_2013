setup

%radFileParser('../data/1309118.rad','04-01-13')

%% galaxy long scans
gal03apr=radFileParser('../data/galx150to210.rad','04-03-13');

plotIndices(gal03apr,2:7)

%longscans

%% galaxy lat scans

latscang175 = radFileParser('../data/latScanOfG170.rad', '04-08-13');

latscang190 = radFileParser('../data/latScanOfG190.rad','04-08-13');

%plotIndices(latscang175,2:6)
plotIndices(latscang190,2:14)

latscans

%% sun

sun08apr=radFileParser('../data/1309818.rad','04-08-13');

%plotIndices(sun08apr,1:57)


%indices = cutTheJunkOut(data(i).counts,data(i).counts,200,100)