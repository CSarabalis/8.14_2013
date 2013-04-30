function bananas = smoothPlotIndices(data, indices, span)

for i=1:max(size(indices))
    figure()
    smoothPlot(data,indices(i), span)
end

end