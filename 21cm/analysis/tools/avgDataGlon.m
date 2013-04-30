function bananas = avgDataGlon(data)

indicesList = sameGlon(data);

avgData = cell(size(indicesList,1),1);

for i=1:max(size(avgData))
    indices = indicesList{i,2};
    avgData{i} = data{indices(1)};
    avgData{i}.glon = indicesList{i,1};
    [b n] = avgCounts(data,indices);
    avgData{i}.counts = b;
    avgData{i}.n = n;
end

bananas = avgData;


end