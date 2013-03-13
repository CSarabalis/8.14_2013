cd('../data/oscilloscope/')

csvFiles = dir('*.CSV'); 
numfiles = length(csvFiles);
mydata = cell(1, numfiles);

for k = 1:numfiles 
  mydata{k} = importdata(csvFiles(k).name, ',',2); 
end

figure()
for k=1:numfiles
    subplot(numfiles,1,k)
    hold all
    plot(mydata{k}.data(:,1),mydata{k}.data(:,2))
    plot(mydata{k}.data(:,1),mydata{k}.data(:,3))
end

clear mydata k csvFiles numfiles

%% change dirs
cd('../../analysis')