function bananas = indexImport2(index)

i=index;

home = pwd;  %save current path in analysis
addpath([home,'/tools'])
addpath([home,'/subscripts'])

% grab the data
cd ../data/
data = cjsImport('csv',',',2);
cd(home)

data_alcorn{i}=struct; % init
data_alcorn{i}.name = data{i}.fileName; % filename
data_alcorn{i}.time = data{i}.data(:,1); % scope time
data_alcorn{i}.bal = data{i}.data(:,5); % PD balanced output
data_alcorn{i}.fp = data{i}.data(:,4); % fabry-perot PD output
data_alcorn{i}.p = data{i}.data(:,3); % pumped beam PD output
data_alcorn{i}.up = data{i}.data(:,2); % unpumped beam PD output

bananas = data_alcorn{i};


end