function bananas = mBin(peakPositions,mbins)

mvals = [];

for i=1:max(size(peakPositions))
    for j=2:max(size(mbins))
        if mbins(j)>=peakPositions(i) && mbins(j-1)<=peakPositions(i)
            mvals = [mvals; j-2];
        end
    end
end

bananas = mvals;


end