% an example to show how the optimization algorithm for type classificaiton works
clc;clear;

fullpath = mfilename('fullpath');
[path,name]=fileparts(fullpath);
addpath([path,'/FunsClassify'])

% % load data
load([path,'/Example_data.mat'])
EF_data = table2array(EF_example);

% % range of parameter
bl = [prctile(EF_data,25),prctile(EF_data(:,[1 2]),25)]; % low boundary
bu = [prctile(EF_data,75),prctile(EF_data(:,[1 2]),75)]; % upper boundary
x0 = (bl+bu)/2;

% % optimization algorithm for classification
[bestx,bestf] = sceua(x0, bl, bu, EF_data);
EClass = funct_eclass(bestx,EF_data);

histogram(EClass)