function [ indices ] = stepFunctionIndexSplit( data, discriminator, minLength )
%stepFunctionIndexSplit splits the data into clusters of smooth variation.
%   Returns a cell array of indices for which consecutive values deviate by
%   no more than discriminator and are necessarily longer than minLength.


alpha = 1;
count = 1;

for i=2:length(data)
    
    if abs(data(i-1) - data(i)) > discriminator || i == length(data)
        if i - alpha > minLength
            indices{count} = alpha:i-1;
            count = count + 1;
        end
        alpha = i;
    end

end

end
