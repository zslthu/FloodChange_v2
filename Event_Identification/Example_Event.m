clc; clear;

fullpath = mfilename('fullpath');
[path,name]=fileparts(fullpath);
addpath([path,'/FunsFloodEvent'])

% % load data
load([path,'/Example_data.mat'])

% % event identification
[snowfall, snowmelt] = CalSnowmelt(rainfall, ta); 
[runoffEvent, rainfallplusEvent, Tr] = IdentifyEvent(streamflow, rainfall, snowmelt, snowfall);

% % figure
PlotEvent(runoffEvent, rainfallplusEvent)
set(gcf,'position',[0 0 1600 800])

% % event feature
triggers = [rainfall, snowmelt, soilwater];
EF = EventFeature(runoffEvent, triggers, Tr);

tablename = {'I_pd' 'I_pdmax3' 'I_pa' 'I_pa_pd' 'I_sw' 'I_sm' 'I_sm_pd' 'I_smmax3_pd'};
EF_table = array2table(EF);
EF_table.Properties.VariableNames = tablename;


