%% basics

% setups up path so that all the functions needed in analysing can be
% called without having to cd(..) in and out,
addpath('./tools','./subscripts','./')

%make latex the default text string interpreter
set(0,'DefaultTextInterpreter','Latex')

% make text defaults
%set(0,'DefaultTextFontName','Mukti Narrow')
set(0,'DefaultTextFontSize',12)


%% reload data

if res=='n'
    load('da.mat','da','data','data_indices','home')
end

%% load up all the data
if res=='y'
% taken from analyze.m (chris's analysis file)

home = pwd;  %save current path in analysis
addpath([home,'/tools'])
addpath([home,'/subscripts'])

% grab the data
cd ../data/
data = cjsImport('csv',',',2);
cd(home)

% data restructuring
data_change_1 = 16;
data_change_2 = 71;
data_change_3 = 73;
data_end = 78;

data_alcorn = cell(1,78);

for i=1:data_change_1-1
    data_alcorn{i}=struct; % init
    data_alcorn{i}.name = data{i}.fileName; % filename
    data_alcorn{i}.time = data{i}.data(:,1); % scope time
    data_alcorn{i}.up = data{i}.data(:,3); % unpumped beam PD output
    data_alcorn{i}.scan = data{i}.data(:,5); % laser current scan output
    data_alcorn{i}.fp = data{i}.data(:,4); % fabry-perot PD output
    data_alcorn{i}.p = data{i}.data(:,2); % pumped beam PD output
end

% scan off(71)/on(72) fp drift measurements
for i=data_change_2:data_change_3-1
    data_alcorn{i}=struct; % init
    data_alcorn{i}.name = data{i}.fileName; % filename
    data_alcorn{i}.time = data{i}.data(:,1); % scope time
    data_alcorn{i}.fp = data{i}.data(:,2); % fabry-perot PD output
end

for i=[data_change_1:data_change_2-1 data_change_3:data_end]
    data_alcorn{i}=struct; % init
    data_alcorn{i}.name = data{i}.fileName; % filename
    data_alcorn{i}.time = data{i}.data(:,1); % scope time
    data_alcorn{i}.up = data{i}.data(:,2); % unpumped beam PD output
    data_alcorn{i}.bal = data{i}.data(:,3); % PD balanced output
    data_alcorn{i}.fp = data{i}.data(:,4); % fabry-perot PD output
    data_alcorn{i}.p = data{i}.data(:,5); % pumped beam PD output
end

data_indices = [1:data_change_2-1 data_change_3:data_end];

da = data_alcorn;
clear data_alcorn

clear i data_change* data_end

end
