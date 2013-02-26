%work in progress

cd ..
cd './oscilloscope'

osc_1=importdata('1_3.178_0.000_500.CSV',',',2);
osc_1.bounds = [1.008 1.355]

plot(osc_1.data(:,1), osc_1.data(:,2))