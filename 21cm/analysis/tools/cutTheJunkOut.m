function [ indices ] = cutTheJunkOut( displayedData, stepData, disc, length )
%cutTheJunkOut takes human input to determine whether or not to keep a
%section of data

h = figure;
indices = stepFunctionIndexSplit(stepData,disc,length);
for i=1:max(size(indices))
    plot(displayedData(indices{i}),'.')
    answer = input('Do you want this range? (y=1/n=0): ');
    figure(h)
    approval(i) = answer;
end
close

indices = indices(find(approval));
    
end

