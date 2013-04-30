%% Initialize Environment

setup

%radFileParser('../data/1309118.rad','04-01-13')

%% galaxy long scans
gal03apr=radFileParser('../data/galx150to210.rad','04-03-13');

%plotIndices(gal03apr,2:7)

%longscans

longscan1 = radFileParser('../data/410257.rad','04-08-13');

%% galaxy lat scans

latscang175 = radFileParser('../data/latScanOfG170.rad', '04-08-13');

latscang190 = radFileParser('../data/latScanOfG190.rad','04-08-13');

%plotIndices(latscang175,2:6)
%plotIndices(latscang190,2:14)

%latscans

%% sun

sun08apr=radFileParser('../data/1309818.rad','04-08-13');

%plotIndices(sun08apr,1:57)


%indices = cutTheJunkOut(data(i).counts,data(i).counts,200,100)

%% sun az scan

azscan1 = radFileParser('../data/417307.rad','04-17-13');
azscan2 = radFileParser('../data/417345.rad','04-17-13');

%% sun el scan

elscan1 = radFileParser('../data/417417.rad','04-17-13');