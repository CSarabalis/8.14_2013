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

may16 = cell(2,1);


i=1;
importedData = importdata('../data/May 16/46.txt','\t',0);
may16{i}=struct;
may16{i}.qpdX = importedData(:,1); % QPD output voltages
may16{i}.qpdY = importedData(:,2);
may16{i}.sgX = importedData(:,3); % strain gauge output voltages
may16{i}.sgY = importedData(:,4);
may16{i}.freq = 0; % frequency of driving in Hz
may16{i}.Vpp = 0; % volts peak-to-peak of signal in V
may16{i}.sampleRate = 100000; % sample rate of data in Hz
may16{i}.intTime = 3; % timespan of data (integration time) in secs
may16{i}.fileName = '46.txt';
may16{i}.waveForm = 'none';
may16{i}.laserCurrent = 147.2; % laser current in mA
may16{i}.bead = 'y'; % y if bead present, n if no bead present


i=2;
importedData = importdata('../data/May 16/47.txt','\t',0);
may16{i}=struct;
may16{i}.qpdX = importedData(:,1); % QPD output voltages
may16{i}.qpdY = importedData(:,2);
may16{i}.sgX = importedData(:,3); % strain gauge output voltages
may16{i}.sgY = importedData(:,4);
may16{i}.freq = 500; % frequency of driving in Hz
may16{i}.Vpp = 3; % volts peak-to-peak of signal in V
may16{i}.sampleRate = 100000; % sample rate of data in Hz
may16{i}.intTime = 3; % timespan of data (integration time) in secs
may16{i}.fileName = '47.txt';
may16{i}.waveForm = 'square';
may16{i}.laserCurrent = 147.2; % laser current in mA
may16{i}.bead = 'y'; % y if bead present, n if no bead present
