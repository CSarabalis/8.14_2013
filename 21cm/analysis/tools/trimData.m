function bananas = trimData(data,index)

% finds discontinuities greater than threshold and limits data range to
% within those discontinuities (we expect 2 for each file)

threshold = 10;

numPoints = max(size(data{index}.counts));
counts = data{index}.counts;
freqs = data{index}.freq;
vels = data{index}.vel;


for i=2:numPoints
if counts(i) - counts(i-1) > threshold
begin = i;
end
if counts(i) - counts(i-1) < (-1*threshold)
finish = i-1;
break
end
end

counts = counts(begin:finish);
freqs = freqs(begin:finish);
vels = vels(begin:finish);

data{index}.counts = counts;
data{index}.freq = freqs;
data{index}.vel= vels;
data{index}.numPoints = finish-begin;

bananas = data;



end