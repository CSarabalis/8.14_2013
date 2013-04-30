function bananas = removeBaseline(data, index)

% roughly, smallest 1/3 of data points appear to constitute the baseline.
% therefore we average the smallest 1/3 of points and subtract this from
% each point to get baseline-subtracted data

baselineNum = data{index}.numPoints/3;
counts = data{index}.counts;

sortedCounts = sort(counts,'ascend');

baselinePoints = sortedCounts(1:baselineNum);

baseline = mean(baselinePoints);

counts = counts - baseline;

data{index}.counts = counts;

bananas = data;



end