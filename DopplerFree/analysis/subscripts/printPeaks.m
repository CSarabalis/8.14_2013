function [ a ] = printPeaks( peaks )
%printPeaks Prints the peaks of a structure of datatips

a = zeros(length(peaks),1)
for i = 1:length(a)
  a(i) = peaks(i).Position(1);
end

end

