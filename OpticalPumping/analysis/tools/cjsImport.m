function [cellArrayofStruc] = cjsImport(fileType,delimiter,headerLines)
%cjsImport imports all .fileType in pwd and puts them in a cell array containing
%the fileName
%
%   Assumptions:
%       the file starts with an index
%       

%scrub inputs
if not(ischar(fileType))
    error('Invalid Argument: Input is not a string.');
end    

%grab the file names
files = regexp(ls,['[-\.\w]*\.',fileType],'match');
%grab the file indices
index = regexp(files, '^([0-9]*)','tokens');
%convert files indices into integers
for i = 1:length(index)
    indices(i) = str2num(index{i}{1}{1});
end
%sort files by index
[~,IX] = sort(indices);
files = files(IX);

if (size(files)==[0,0])   %checks for matches
    cellArrayofStruc = 0;
    disp(['No ',fileType,' in pwd']);
else                      %import the data into a cell array
    for i = 1:length(files)
        x.data = importdata(files{i},delimiter,headerLines);
        x.data = x.data.data;
        x.fileName = files{i};
        cellArrayofStruc{i} = x;
    end
end

end
