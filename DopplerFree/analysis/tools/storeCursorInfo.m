function data = storeCursorInfo(data, index, cursor_info, varargin)

% assumes youve already gone through and placed a cursor on top of each
% peak, then exported cursor data to the workspace

data{index}.peakIndices=[];
data{index}.peakPositions = [];

for i=1:max(size(cursor_info))
data{index}.peakPositions = [data{index}.peakPositions; cursor_info(i).Position];
data{index}.peakIndices = [data{index}.peakIndices; cursor_info(i).DataIndex];
end




% if varargin{1} == 'save'
%     save('da.mat', 'da','data','data_indices','home')
% else
%     save('test.mat', 'da','data','data_indices','home')
% end

end