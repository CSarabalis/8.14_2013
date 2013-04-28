function bananas = roughPlotIndices(data, indices)

for i=1:max(size(indices))
    figure()
    roughPlot(data,indices(i))
end

end