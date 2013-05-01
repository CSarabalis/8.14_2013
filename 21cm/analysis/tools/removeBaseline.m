function bananas = removeBaseline(data, index, varargin)

% roughly, smallest 1/3 of data points appear to constitute the baseline.
% therefore we average the smallest 1/3 of points and subtract this from
% each point to get baseline-subtracted data
if max(size(varargin)) < 1
baselineFrac = 1/3;
else
baselineFrac = varargin{1};
end

baselineNum = data{index}.numPoints*baselineFrac;
counts = data{index}.counts;

sortedCounts = sort(counts,'ascend');

baselinePoints = sortedCounts(1:baselineNum);

baseline = mean(baselinePoints);

counts = counts - baseline;

data{index}.counts = counts;

bananas = data;



end
