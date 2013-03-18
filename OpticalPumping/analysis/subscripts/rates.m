%% See derivatives

figure
response = 1;
for i=1:12
    for j=1:length(data{i}.range)
        if response
            subplot(2,1,1)
            range = data{i}.range{j};
            derivative = diff([data{i}.data(range,2);data{i}.data(range(end),2)])./diff([data{i}.data(range,1);data{i}.data(range(end),1)]);
            plot(data{i}.data(data{i}.range{j},2),derivative,'.')
            xlabel('V')
            ylabel('dV/dt')
            title(['(',num2str(i),',',num2str(j),')'])
            subplot(2,1,2)
            plot(data{i}.data(data{i}.range{j},2),'.')
            xlabel('t')
            ylabel('V')
            response = input('Continue? (1=y;0=n) : ');
        end
    end
end
close
clear response derivative range

%% Do the linear and exponential fits

%loop through files 1:12
for i = 1:12
    %loop through all ranges specified by the cut script
    
    %preallocate
    data{i}.expBinned = cell(length(data{i}.range));
    data{i}.expFit = cell(length(data{i}.range));
    data{i}.linBinned = cell(length(data{i}.range));
    data{i}.linFit = cell(length(data{i}.range));
    
    for j = 1:length(data{i}.range)
        indices = data{i}.range{j};
        figure
        subplot(2,2,1:2)
        hold on
        plot(data{i}.data(indices,1),data{i}.data(indices,2),'.',...
            'Color',[.87 .92 .98]);
        title(['(',num2str(i),',',num2str(j),')']);
        %cut the data and transform it
        indices = data{i}.expRange{j};
        x = log(data{i}.direction{j}*(data{i}.data(indices,2) - data{i}.offset{j}));
        x = real(x);
        %bin and fit the data
        binned = binForFit(data{i}.data(indices,1),x,1:4:length(x));
        data{i}.expBinned{j} = binned; %store binned data
        subplot(2,2,3)
        data{i}.expFit{j} = linearFit(binned(:,1),binned(:,2),binned(:,3));
        xlabel('Time [s]')
        ylabel('Linearized Photodiode [V]')
        title('Linear Fit of Binned Linearized Data')
        if ~isnan(data{i}.linRange{j})
            %bin and fit the data
            subplot(2,2,4)
            indices = data{i}.linRange{j};
            startIndex = indices(1);
            stopIndex = indices(end);
            binned = binForFit(data{i}.data(:,1),data{i}.data(:,2),startIndex:4:stopIndex);
            data{i}.linBinned{j} = binned;  %store binned data
            data{i}.linFit{j} = linearFit(binned(:,1),binned(:,2),binned(:,3));
            xlabel('Time [s]')
            ylabel('Photodiode [V]')
            title('Linear Fit of Binned Data')
        end
        subplot(2,2,1:2)
        binned = data{i}.expBinned{j};
        %plot the binned data
        errorbar(binned(:,1),...
            data{i}.direction{j}*(exp(binned(:,2)))+data{i}.offset{j},...
            binned(:,3).*exp(binned(:,2)),'.')
        %plot the fit
        plot(binned(:,1),...
            data{i}.direction{j}*(exp(...
            data{i}.expFit{j}.a*binned(:,1)+data{i}.expFit{j}.b...
            ))+data{i}.offset{j},'-r')
            
        if ~isnan(data{i}.linRange{j})
            binned = data{i}.linBinned{j};
            errorbar(binned(:,1),binned(:,2),binned(:,3),'.g')
        end
        
    end
end

clear startIndex stopIndex binned x indices