%% May 14

may14 = cell(5,1);


i=1;
importedData = importdata('../data/May 14/41.txt','\t',0);
may14{i}=struct;
may14{i}.qpdX = importedData(:,1); % QPD output voltages
may14{i}.qpdY = importedData(:,2);
may14{i}.sgX = importedData(:,3); % strain gauge output voltages
may14{i}.sgY = importedData(:,4);
may14{i}.freq = 0; % frequency of driving in Hz
may14{i}.Vpp = 0; % volts peak-to-peak of signal in V
may14{i}.sampleRate = 100000; % sample rate of data in Hz
may14{i}.intTime = 10; % timespan of data (integration time) in secs
may14{i}.fileName = '41.txt';
may14{i}.waveForm = 'none';
may14{i}.laserCurrent = 145.4; % laser current in mA
may14{i}.bead = 'y'; % y if bead present, n if no bead present


i=2;
importedData = importdata('../data/May 14/42.txt','\t',0);
may14{i}=struct;
may14{i}.qpdX = importedData(:,1); % QPD output voltages
may14{i}.qpdY = importedData(:,2);
may14{i}.sgX = importedData(:,3); % strain gauge output voltages
may14{i}.sgY = importedData(:,4);
may14{i}.freq = 100; % frequency of driving in Hz
may14{i}.Vpp = 5; % volts peak-to-peak of signal in V
may14{i}.sampleRate = 100000; % sample rate of data in Hz
may14{i}.intTime = 10; % timespan of data (integration time) in secs
may14{i}.fileName = '42.txt';
may14{i}.waveForm = 'sine';
may14{i}.laserCurrent = 145.4; % laser current in mA
may14{i}.bead = 'y'; % y if bead present, n if no bead present


i=3;
importedData = importdata('../data/May 14/43.txt','\t',0);
may14{i}=struct;
may14{i}.qpdX = importedData(:,1); % QPD output voltages
may14{i}.qpdY = importedData(:,2);
may14{i}.sgX = importedData(:,3); % strain gauge output voltages
may14{i}.sgY = importedData(:,4);
may14{i}.freq = 100; % frequency of driving in Hz
may14{i}.Vpp = 5; % volts peak-to-peak of signal in V
may14{i}.sampleRate = 100000; % sample rate of data in Hz
may14{i}.intTime = 10; % timespan of data (integration time) in secs
may14{i}.fileName = '43.txt';
may14{i}.waveForm = 'square';
may14{i}.laserCurrent = 145.4; % laser current in mA
may14{i}.bead = 'y'; % y if bead present, n if no bead present


i=4;
importedData = importdata('../data/May 14/44.txt','\t',0);
may14{i}=struct;
may14{i}.qpdX = importedData(:,1); % QPD output voltages
may14{i}.qpdY = importedData(:,2);
may14{i}.sgX = importedData(:,3); % strain gauge output voltages
may14{i}.sgY = importedData(:,4);
may14{i}.freq = 100; % frequency of driving in Hz
may14{i}.Vpp = 5; % volts peak-to-peak of signal in V
may14{i}.sampleRate = 100000; % sample rate of data in Hz
may14{i}.intTime = 10; % timespan of data (integration time) in secs
may14{i}.fileName = '44.txt';
may14{i}.waveForm = 'sine';
may14{i}.laserCurrent = 145.4; % laser current in mA
may14{i}.bead = 'n'; % y if bead present, n if no bead present


i=5;
importedData = importdata('../data/May 14/45.txt','\t',0);
may14{i}=struct;
may14{i}.qpdX = importedData(:,1); % QPD output voltages
may14{i}.qpdY = importedData(:,2);
may14{i}.sgX = importedData(:,3); % strain gauge output voltages
may14{i}.sgY = importedData(:,4);
may14{i}.freq = 100; % frequency of driving in Hz
may14{i}.Vpp = 5; % volts peak-to-peak of signal in V
may14{i}.sampleRate = 100000; % sample rate of data in Hz
may14{i}.intTime = 10; % timespan of data (integration time) in secs
may14{i}.fileName = '45.txt';
may14{i}.waveForm = 'square';
may14{i}.laserCurrent = 145.4; % laser current in mA
may14{i}.bead = 'n'; % y if bead present, n if no bead present


clear importedData i

%figure
%plot([0.00001:0.00001:10]',may14{1}.qpdX,'.')


%% May 16

files = dir('../data/May 16');
files = files(3:end);

may16 = cell(size(files));

Vpp = [0 3 2 1 0.5 0.25 0.125 0.62 0.3 0 3];
freq = [0 500 500 500 500 500 500 500 500 0 500];
waveForm = {'none' 'square' 'square' 'square' 'square' 'square' 'square' 'square' 'square' 'none' 'square'};
bead = {'y' 'y' 'y' 'y' 'y' 'y' 'y' 'y' 'y' 'n' 'n'};

for i=1:max(size(files))
name = ['../data/May 16/' files(i).name];
importedData = importdata(name,'\t',0);
may16{i}.qpdX = importedData(:,1); % QPD output voltages
may16{i}.qpdY = importedData(:,2);
may16{i}.sgX = importedData(:,3); % strain gauge output voltages
may16{i}.sgY = importedData(:,4);
may16{i}.freq = freq(i); % frequency of driving in Hz
may16{i}.Vpp = Vpp(i); % volts peak-to-peak of signal in V
may16{i}.sampleRate = 100000; % sample rate of data in Hz
may16{i}.intTime = 3; % timespan of data (integration time) in secs
may16{i}.fileName = files(i).name;
may16{i}.waveForm = waveForm{i};
may16{i}.laserCurrent = 147.1; % laser current in mA
may16{i}.bead = bead{i}; % y if bead present, n if no bead present
end


clear Vpp freq waveForm bead files i importedData name
