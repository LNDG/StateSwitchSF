%% State-Switch Dynamic Connectome Analysis
% Sarah Polk
%import connectomes
%import demographic data
%extract topology info
%run comparisons

%% exlusion notes
%Pilots: 1213,1215,1221,1227,2128
%MRI missing?: 1126 (no DWI), 1215 (couldn't be processed), 1227 (no
% reverse acquisition)
%No MRI appt: 1138,1144,1158,1163
%No EEG appt: 1125, 1214

%% setup
%add necessary toolboxes
%Brain Connectivity Toolbox - https://sites.google.com/site/bctnet/ 
%Community Algorithm Toolbox - https://github.com/CarloNicolini/communityalg
addpath(genpath('~/Desktop/MATLAB/BCT/2017_01_15_BCT'));
addpath(genpath('~/Desktop/MATLAB/communityalg-master'));

%% import connectomes
%change to script directory
cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/A_scripts

% yes thresholding, set thr = 1
% no thresholding, set thr = 0
% first run: sparsity = 10
% can leave varargin at default
importconnectomes_basicanalysis_SP(164, 0, 10) 

%% import demographic data
%change to demographics directory
cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_Data/demographics

demogr_table = xlsread('Questionnaire_STSWD_NoPilot_Clean.xlsx');
demogr_short = table(demogr_table(:,1), demogr_table(:,16),demogr_table(:,17), ...
    (datenum((demogr_table(:,85)) - (demogr_table(:,18))))/365.25);

demogr_short.Properties.VariableNames{'Var1'} = 'ID_demogr';
demogr_short.Properties.VariableNames{'Var2'} = 'AgeGroup';
demogr_short.Properties.VariableNames{'Var3'}  = 'Sex';
demogr_short.Properties.VariableNames{'Var4'}  = 'Age';

% delete participants with no DWI from demographics table
demogr_short(ismember(demogr_short.ID_demogr,[1213,1215,1221,1227,2128,1126,...
    1227,1138,1144,1158,1163]),:) = [];

%% gather data to compare
%change back to scripts directory
cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/A_scripts

[ConTable,ConTable_local, subjs] = extracttopologyinfo_SP('ID_list.txt', 10);

% delete pilots' DWI info 
for i = [2142 2253 2254 2255]
    toDelete = sprintf('sub-STSWD%d',i);
    ConTable(ismember(ConTable.subjs,toDelete),:) = [];
    ConTable_local(ismember(ConTable_local.subjs,toDelete),:) = [];
    subjs(ismember(subjs,toDelete)) = [];
end

subjs = erase(subjs,'sub-STSWD');

ConTable = [demogr_short ConTable];
ConTable.subjs = [];
ConTable_local = [demogr_short ConTable_local];
ConTable_local.subjs = [];

cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_Data

writetable(ConTable, 'STSWD_connectome_thr10.txt');
writetable(ConTable_local, 'STSWD_connectome_local_thr10.txt');

%% analyze GLOBAL metrics, find outliers, compare age groups
% use STSWD_global_metrics.m
% (/Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/A_scripts/)

%% analyze LOCAL metrics, find outliers, compare age groups
% use STSWD_local_metrics.m
% (/Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/A_scripts/)

%% plots

% for histogram of glbal metrics: plot_STSWD_hist_yavoa.m or
% plot_STSWD_hist_yavoa_EXCL.m

% for bar plots of age group comparisons: plot_STSWD_bar_yavoa_EXCL.m