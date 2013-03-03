%% Import data

cd ../../data/oscilloscope/
data = cjsImport('CSV',',',2);
%return to home dir
cd(home);

%% Look at all raw data
for i = 1:length(data)
    qplot(data{i},num2str(i))
end

%%  ONE TIME USE: grab the ranges to be analyzed

for i = 1:12
   data{i}.range = cutTheJunkOut(data{i}.data(:,2),data{i}.data(:,3),.1,50);
end

%% ONE TIME USE: grab ranges for analysis

figure

% for i = 1:12
%     for j = 1:length(data{i}.range)
%         plot(data{i}.data(data{i}.range{j},2),'.')
%         data{i}.direction{j} = input('1 for decaying, -1 for rising: ');
%         data{i}.offset{j}    = input('Offset: ');
%     end
% end

for i = 1:12
    for j = 1:length(data{i}.range)
        x = log(data{i}.direction{j}*(data{i}.data(data{i}.range{j},2) - data{i}.offset{j}));
        plot(data{i}.data(data{i}.range{j},1),x,'.')
        startIndex = input('Start Index: ');
        stopIndex  = input('Stop  Index: ');
        
    end
end
close