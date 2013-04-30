function bananas = sameGlon(data)

indicesList = cell(1,2);

for i=1:max(size(data))
    complete = 0;
    for j=1:size(indicesList,1)
        if abs(data{i}.glon - indicesList{j,1}) < 0.5
            indicesList{j,2} = [indicesList{j,2} i];
            complete = 1;
        end
    end
    
    if ~complete
        indicesList{size(indicesList,1)+1,2} = [];
        indicesList{end,1} = data{i}.glon;
        indicesList{end,2} = [i];
    end
end

bananas = indicesList(2:end,:);


end