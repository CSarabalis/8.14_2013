%Imports all .fileType in pwd and puts them in a cell array containing
%the fileName
%
%This version assumes the file starts with an index

function [matrixCellArray] = cjsImport(fileType)

if not(ischar(fileType))
    error('Invalid Argument: Input is not a string.');
end    

files = regexp(ls,['[\.\w]*.',fileType],'match');
disp(files)
index = regexp(files, '([0-9]*).*','tokens');
%regexp with the tokens option return a 2 dimension cell array, the first
%index specifies the match, the second the token
for i = 1:length(index)
    indices(i) = index{i}{1};
end
%not sure why indices is a cell array here
%this workaround is shitty
for i = 1:length(indices)
    foo(i) = str2num(indices{i});
end
[~,IX] = sort(foo);
files = files(IX);

if (size(files)==[0,0])
    matrixCellArray = 0;
    disp(['No ',fileType,' in pwd']);
else
    for i = 1:length(files)
        copyfile(files{i},['temp.',fileType])
        x.data = importdata(['temp.',fileType]);
        x.fileName = files{i};
        matrixCellArray{i} = x;
        delete(['temp.',fileType]);
    end
end

end
