function [bananas, n] = avgCounts(data,indices)

n = max(size(indices)); % number of files being averaged

countsSum = zeros(size(data{indices(1)}.counts)); % init

for i=indices(1:end)
    countsSum = countsSum + data{i}.counts;
end

countsSum = countsSum/n; % averaging

bananas = countsSum;

end