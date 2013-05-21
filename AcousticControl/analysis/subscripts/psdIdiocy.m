%% initstuff

for i=1:11
    may16{i} = makePSD(may16{i});
end

%% idiocy

indices = [1:max(size(may16))];

k = 10;
nwnbIndices = indices(~([1:11]==k));

for i=nwnbIndices
    may16{i}.Xpsd = may16{i}.Xpsd - may16{k}.Xpsd;
    may16{i}.Ypsd = may16{i}.Ypsd - may16{k}.Ypsd;
    plotPSD(may16{i});
end

k=1;
nbIndices = indices(~([1:11]==k));

for i=nbIndices
    may16{i}.Xpsd = may16{i}.Xpsd - may16{k}.Xpsd;
    may16{i}.Ypsd = may16{i}.Ypsd - may16{k}.Ypsd;
    plotPSD(may16{i});
end

k=1;
nwIndices = indices(~([1:11]==k));

for i=nwIndices
    may16{i}.Xpsd = may16{i}.Xpsd - may16{k}.Xpsd;
    may16{i}.Ypsd = may16{i}.Ypsd - may16{k}.Ypsd;
    plotPSD(may16{i});
end


