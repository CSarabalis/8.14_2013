function[xysig,data] = binForFit(varargin)
%binForFit bins the data, takes the mean and std within each bin, and
%returns a 4 column matrix with the meanX, meanY, stdY, and stdX.
%   The mesh is either an integer, the number of desired bins, or a mesh of
%   indices.  For the ith element in the mesh array, the bin will include
%   the mesh(i) point but exclude the mesh(i+1) point.
%   The last index of the mesh array is included in the last bin.
%
%binForFit(x,y,mesh)
%
%binForFit(y,mesh)

if nargin == 2
    error('This function has yet to be implemented. Get coding.')
end

%pad the end
varargin{1}(end + 1) = 0;
varargin{2}(end + 1) = 0;

%if mesh is not an array, make a linearly spaced array over the indices
%with number of bins equal to the mesh argument
if length(varargin{end}) == 1
    varargin{end} = round(linspace(1,length(varargin{1})+1,varargin{end}));
else
    varargin{end}(end) = varargin{end}(end) + 1;
end

%preallocate space for return
xysig = zeros(length(varargin{end})-1,4);

%compute mean and std of bin and store in xysig
for i = 1:length(varargin{end})-1
    x = varargin{1}(varargin{end}(i):varargin{end}(i+1)-1);
    y = varargin{2}(varargin{end}(i):varargin{end}(i+1)-1);
    xysig(i,1) = mean(x);
    xysig(i,2) = mean(y);
    xysig(i,3) = std(y)/sqrt(length(y));
    xysig(i,4) = std(x);
end

%return original data, !!ASSUMES ORIGINAL DATA IS IN COLUMN
data = [varargin{1},varargin{2}];

end
