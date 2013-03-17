% setups up path so that all the functions needed in analysing can be
% called without having to cd(..) in and out,
addpath('./tools','./subscripts','./')

% load data.mat file with data tables
load('../data/data.mat')

%make latex the default text string interpreter
set(0,'DefaultTextInterpreter','Latex')

% make text defaults
set(0,'DefaultTextFontName','Mukti Narrow')
set(0,'DefaultTextFontSize',12)