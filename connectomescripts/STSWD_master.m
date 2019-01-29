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
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/G_Git/githubrepos/StateSwitchSF/connectomescripts

% yes thresholding, set thr = 1
% no thresholding, set thr = 0
% first run: sparsity = 10
% can leave varargin at default - set to 'ORGinv' for noSIFT
% change path per parcellation

SIFTpath = '/Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/DST/SIFT'
noSIFTpath = '/Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/DST/noSIFT'

importconnectomes_basicanalysis_SP(SIFTpath, 164, 0, 10) 

%% import demographic data
%change to demographics directory
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_Data/demographics

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
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/G_Git/githubrepos/StateSwitchSF/connectomescripts

[ConTable,ConTable_local, subjs] = extracttopologyinfo_SP(SIFTpath, 'ID_list.txt', 10);

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

% remove cerebellum
ConTable_local.STR75 = [];
ConTable_local.STR164 = [];
ConTable_local.DEG75 = [];
ConTable_local.DEG164 = [];
ConTable_local.STRnt75 = [];
ConTable_local.STRnt164 = [];

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/DST

writetable(ConTable, 'STSWD_connectome_thr10.txt');
writetable(ConTable_local, 'STSWD_connectome_local_thr10.txt');

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes

save('for_metrics.mat')

%% analyze GLOBAL metrics, find outliers, compare age groups

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/G_Git/githubrepos/StateSwitchSF/connectomescripts

[global_anova,global_means] = STSWD_global_metrics(0,0)
% set first value to ~0 for single variable outliers
%   (gl_outliers, gl_outliers_ya, gl_outliers_oa)
% set second value to ~0 for multivariate outliers

%% analyze LOCAL metrics, find outliers, compare age groups

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/G_Git/githubrepos/StateSwitchSF/connectomescripts

[local_anova] = STSWD_local_metrics(0,0)
% set first value to ~0 for single variable outliers
%   (lo_outliers, lo_outliers_ya, lo_outliers_oa)
% set second value to ~0 for multivariate outliers

%% plots 
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/G_Git/githubrepos/StateSwitchSF/figurescripts

savewhere = ('/Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/C_Figures/global_metrics');

% global metrics distributions
hist_YAvOA('numfibers',savewhere,'numfibers_hist','Number of fibers per age group','Number of fibers')
hist_YAvOA('CPL',savewhere,'CPL_hist','Characteristic path length per age group','Characteristic path length')
hist_YAvOA('EFF',savewhere,'EFF_hist','Global efficiency per age group','Global efficiency')
hist_YAvOA('CC',savewhere,'CC_hist','Average clustering coefficient per age group','Average clustering coefficient')
hist_YAvOA('InterHemC',savewhere,'InterHemC_hist','Interhemispheric connectivity per age group','Interhemispheric connectivity')
hist_YAvOA('TCOMM',savewhere,'TCOMM_hist','Communicability per age group','Communicability')
hist_YAvOA('MAD',savewhere,'MAD_hist','Mean anatomical distance per age group','Mean anatomical distance')

% global metrics bar/beehive plots (after running STSWD_global_metrics.m)
bar_YAvOA('numfibers',savewhere,'numfibers_beehive','Number of fibers per age group','Number of fibers')
bar_YAvOA('CPL',savewhere,'CPL_beehive','Characteristic path length per age group','Characteristic path length')
bar_YAvOA('EFF',savewhere,'EFF_beehive','Global efficiency per age group','Global efficiency')
bar_YAvOA('CC',savewhere,'CC_beehive','Average clustering coefficient per age group','Clustering coefficient')
bar_YAvOA('InterHemC',savewhere,'InterHemC_beehive','Interhemispheric connectivity per age group','Interhemispheric connectivity')
bar_YAvOA('TCOMM',savewhere,'TCOMM_beehive','Communicability per age group','Communicability')
bar_YAvOA('MAD',savewhere,'MAD_beehive','Mean anatomical distance per age group','Mean anatomical distance')

%% visualization with brainnet viewer

addpath(genpath('~/Desktop/MATLAB/BrainNetViewer_20181219'))

% create node file STR
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes
load('164COG.mat')
no_cereb_nodes = COG([1:74 76:163],:);

sig_STR = find(ismember(local_anova.h_STR_group,1));
for i = 1:length(sig_STR)
    node_STR(i,[1:3]) = no_cereb_nodes(sig_STR(i),[1:3]);
    if local_anova.t_STR(sig_STR(i)) > 0
        node_STR(i,4) = 1;
    else node_STR(i,4) = 2;
    end
    node_STR(i,5) = 1;
end

sig_DEG = find(ismember(local_anova.h_DEG_group,1));
for i = 1:length(sig_DEG)
    node_DEG(i,[1:3]) = no_cereb_nodes(sig_DEG(i),[1:3]);
    if local_anova.t_DEG(sig_DEG(i)) > 0
        node_DEG(i,4) = 1;
    else node_DEG(i,4) = 2;
    end
    node_DEG(i,5) = 1;
end

sig_STRnt = find(ismember(local_anova.h_STRnt_group,1));
for i = 1:length(sig_STRnt)
    node_STRnt(i,[1:3]) = no_cereb_nodes(sig_STRnt(i),[1:3]);
    if local_anova.t_STRnt(sig_STRnt(i)) > 0
        node_STRnt(i,4) = 1;
    else node_STRnt(i,4) = 2;
    end
    node_STRnt(i,5) = 1;
end
