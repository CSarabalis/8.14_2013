%% Import data

cd ../../data/oscilloscope/
data = cjsImport('CSV',',',2);
%return to home dir
cd(home);

%% Look at all raw data
for i = 1:length(data)
    qplot(data{i},num2str(i))
end

%%  ONE TIME USE: grab the ranges to be analyzed

for i = 1:12
   data{i}.range = cutTheJunkOut(data{i}.data(:,2),data{i}.data(:,3),.1,50);
end

%% ONE TIME USE: grab ranges for analysis

figure

%Get info necessary to transform each curve into a decaying exponential
for i = 1:12
    for j = 1:length(data{i}.range)
        plot(data{i}.data(data{i}.range{j},2),'.')
        data{i}.direction{j} = input('1 for decaying, -1 for rising: ');
        data{i}.offset{j}    = input('Offset: ');
    end
end

%loop through files 1:12
for i = 1:12
    %loop through all ranges specified by the cut script
    for j = 1:length(data{i}.range)
        %loop through to get a fit
        response = 1;
        while response
            %transform the data
            indices = data{i}.range{j};
            x = log(data{i}.direction{j}*(data{i}.data(indices,2) - data{i}.offset{j}));
            x = real(x);
            %plot for selection
            plot(indices,x,'.')
            xlabel('indices in full data set')
            ylabel('linearized voltage')
            title(['Data set: ',num2str(i),', Slice: ',num2str(j)])
            %get input
            startIndex = input('Start Index for Exp: ');
            stopIndex  = input('Stop  Index for Exp: ');
            %cut the data and transform it
            indices = startIndex:stopIndex;
            x = log(data{i}.direction{j}*(data{i}.data(indices,2) - data{i}.offset{j}));
            x = real(x);
            %bin and fit the data
            binned = binForFit(data{i}.data(indices,1),x,1:4:length(x));
            figure
            linearFit(binned(:,1),binned(:,2),binned(:,3))
            %ask for approval
            response = input('Wanna try again? ');
            close
        end
        %store indices
        data{i}.expRange{j} = indices;
        %display data and ask for the existence of a linear regime
        plot(data{i}.data(data{i}.range{j},1),data{i}.data(data{i}.range{j},2),'.')
        response = input('Is there a linear regime? ')
        if response
            while response
                %plot for selection
                plot(data{i}.range{j},data{i}.data(data{i}.range{j},2),'.')
                xlabel('indices in full data set')
                ylabel('linearized voltage')
                title(['Data set: ',num2str(i),', Slice: ',num2str(j)])
                %get input
                startIndex = input('Start Index for Exp: ');
                stopIndex  = input('Stop  Index for Exp: ');
                indices = startIndex:stopIndex;
                %bin and fit the data
                figure
                binned = binForFit(data{i}.data(:,1),data{i}.data(:,2),startIndex:4:stopIndex);
                linearFit(binned(:,1),binned(:,2),binned(:,3))
                %ask for approval
                response = input('Wanna try again? ');
                close
            end
            data{i}.linRange{j} = indices;
        else
            data{i}.linRange{j} = NaN;
        end
    end
end

close