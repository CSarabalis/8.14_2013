function data = radFileParser(fileName, dateStr)
    %  Created by Katie Harrington (kharring@mit.edu) July 2011
    %  WARNING: This code has been know to throw errors if you have 
    %           mode 1 and mode 4 measurements in the same file.
    %           It will work for mode 1 or mode 4 if the file contains
    %           only that mode.
    %
    %  filename is the location of the .rad file
    %       ex:  'data/galaxy_scan.rad'
    %
    %  dateStr is a string containing the date the .rad file was taken on
    %  in the form of MM-DD-YY'
    %       ex: '07-21-11'
    %
    %  data is an array of structures where each structure corresponds to a
    %  single scan taken by the telescope. Each structure has fields:
    %       time, timeText
    %       az, el
    %       az_offset, el_offset
    %       glon, glat
    %       startFreq, stepFreq
    %       mode, numPoints
    %       counts, freq   <<-- The result of the scan. you can run
    %                           plot(data(i).freq, data(i).counts, 'x') 
    %                           to see the results of the i-th scan
    
    
    
    newData1 = importdata(fileName);

    %vars = fieldnames(newData1);
    
    textdata = newData1.textdata;
    index = 1;
    for i = 1:size(textdata,1) %go through file line by line
        if textdata{i,1}(1) == '*' %if the line is a comment
            continue; 
        end

        data(index).timeText = textdata{i,1};
         
        thing = regexp(data(index).timeText, ':');
        
        data(index).time = datenum(strcat(dateStr, ' ', data(index).timeText(thing(2)+1:end)));
        
        data(index).az = round(str2double(textdata{i,2}));
        data(index).el = round(str2double(textdata{i,3}));
        data(index).az_offset = str2double(textdata{i,4});
        data(index).el_offset = str2double(textdata{i,5});
        data(index).glon = str2double(textdata{i,6});
        data(index).glat = str2double(textdata{i,7});
        data(index).startFreq = str2double(textdata{i,8});
        data(index).stepFreq = str2double(textdata{i,9});
        data(index).mode = str2double(textdata{i,10});
        data(index).numPoints = str2double(textdata{i,11});
        
        data(index).counts = zeros(data(index).numPoints,1);
        data(index).freq = zeros(data(index).numPoints,1);
        
        for n = 1:data(index).numPoints
            data(index).counts(n) = str2double(textdata{i,11+n});
            data(index).freq(n) = data(index).startFreq + data(index).stepFreq * (n-1);
        end
        
        data(index).sum = sum(data(index).counts);
        
        %data(index).counts = data(index).counts(11:end-11);
        %data(index).freq = data(index).freq(11:end-11);
        
        index = index + 1;
    end
end