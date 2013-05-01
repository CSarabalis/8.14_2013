function data = VmaxstoreCursorInfo(data, index, cursor_info)

% assumes youve already gone through and placed a cursor on top of each
% peak, then exported cursor data to the workspace

data{index}.VmaxIndices=[];
data{index}.VmaxPositions = [];

for i=1:max(size(cursor_info))
data{index}.VmaxPositions = [data{index}.VmaxPositions; cursor_info(i).Position];
data{index}.VmaxIndices = [data{index}.VmaxIndices; cursor_info(i).DataIndex];
end


end

%   s e n o r   n u a g e s