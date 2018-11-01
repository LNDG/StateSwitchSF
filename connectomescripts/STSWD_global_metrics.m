%% global metrics 

% dependencies:
% - ConTable (STSWD_master.m)

%% check for outliers per measure (global) 

%across groups

outliers = struct();
for i = 1:6
    outliers.global(:,i) = isoutlier(ConTable{:,i+4},'mean'); 

    for j = 1:94
        if outliers.global(j,i) == 1
            outliers.globalwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
        else
            outliers.globalwhich(j,i) = 0;
        end

        outliers.nglobal(j,1) = str2num(cell2mat(subjs(j)));
        outliers.nglobal(j,2) = sum(outliers.global(j,:)); 
    end
end

outliers_ya = struct();
for i = 1:6
    outliers_ya.global(:,i) = isoutlier(ConTable{ismember(ConTable.AgeGroup,1),i+4},'mean'); 

    for j = 1:41
        if outliers_ya.global(j,i) == 1
            outliers_ya.globalwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
        else
            outliers_ya.globalwhich(j,i) = 0;
        end
        outliers_ya.nglobal(j,1) = str2num(cell2mat(subjs(j)));
        outliers_ya.nglobal(j,2) = sum(outliers_ya.global(j,:)); 
    end
end

outliers_oa = struct();
for i = 1:6
    outliers_oa.global(:,i) = isoutlier(ConTable{ismember(ConTable.AgeGroup,2),i+4},'mean'); 

    for j = 1:53
        if outliers_oa.global(j,i) == 1
            outliers_oa.globalwhich(j,i) = str2num(cell2mat(subjs(j+41))); % which ID
        else
            outliers_oa.globalwhich(j,i) = 0;
        end
        outliers_oa.nglobal(j,1) = str2num(cell2mat(subjs(j+41)));
        outliers_oa.nglobal(j,2) = sum(outliers_oa.global(j,:)); 
    end
end

clearvars i j 

%% check for outliers across variables

addpath(genpath('~/Desktop/MATLAB/moutlier1'));
moutlier1(ConTable{:,[5:10]},.10) %across all 1276, 2129
moutlier1(ConTable{(ismember(ConTable.AgeGroup,1)),[5:10]},.10) %within YA 1276
moutlier1(ConTable{(ismember(ConTable.AgeGroup,2)),[5:10]},.10) %within OA 2149

%% exclude outliers

ConTable_excl = table();
ConTable_excl = ConTable;
ConTable_excl(ismember(ConTable_excl.ID_demogr,1276),:) = [];
ConTable_excl(ismember(ConTable_excl.ID_demogr,2129),:) = [];
ConTable_excl(ismember(ConTable_excl.ID_demogr,2149),:) = [];

%% descriptives EXCLUDE 1276, 2129 and 2149

means_ya = table();
means_ya.numfibers = nanmean(ConTable_excl.numfibers(ismember(ConTable_excl.AgeGroup,1)));
means_ya.CPL = nanmean(ConTable_excl.CPL(ismember(ConTable_excl.AgeGroup,1)));
means_ya.EFF = nanmean(ConTable_excl.EFF(ismember(ConTable_excl.AgeGroup,1)));
means_ya.CC = nanmean(ConTable_excl.CC(ismember(ConTable_excl.AgeGroup,1)));
means_ya.InterHemC = nanmean(ConTable_excl.InterHemC(ismember(ConTable_excl.AgeGroup,1)));
means_ya.TCOMM = nanmean(ConTable_excl.TCOMM(ismember(ConTable_excl.AgeGroup,1)));

means_oa = table();
means_oa.numfibers = nanmean(ConTable_excl.numfibers(ismember(ConTable_excl.AgeGroup,2)));
means_oa.CPL = nanmean(ConTable_excl.CPL(ismember(ConTable_excl.AgeGroup,2)));
means_oa.EFF = nanmean(ConTable_excl.EFF(ismember(ConTable_excl.AgeGroup,2)));
means_oa.CC = nanmean(ConTable_excl.CC(ismember(ConTable_excl.AgeGroup,2)));
means_oa.InterHemC = nanmean(ConTable_excl.InterHemC(ismember(ConTable_excl.AgeGroup,2)));
means_oa.TCOMM = nanmean(ConTable_excl.TCOMM(ismember(ConTable_excl.AgeGroup,2)));

stds_ya = table();
stds_ya.numfibers = nanstd(ConTable_excl.numfibers(ismember(ConTable_excl.AgeGroup,1)));
stds_ya.CPL = nanstd(ConTable_excl.CPL(ismember(ConTable_excl.AgeGroup,1)));
stds_ya.EFF = nanstd(ConTable_excl.EFF(ismember(ConTable_excl.AgeGroup,1)));
stds_ya.CC = nanstd(ConTable_excl.CC(ismember(ConTable_excl.AgeGroup,1)));
stds_ya.InterHemC = nanstd(ConTable_excl.InterHemC(ismember(ConTable_excl.AgeGroup,1)));
stds_ya.TCOMM = nanstd(ConTable_excl.TCOMM(ismember(ConTable_excl.AgeGroup,1)));

stds_oa = table();
stds_oa.numfibers = nanstd(ConTable_excl.numfibers(ismember(ConTable_excl.AgeGroup,2)));
stds_oa.CPL = nanstd(ConTable_excl.CPL(ismember(ConTable_excl.AgeGroup,2)));
stds_oa.EFF = nanstd(ConTable_excl.EFF(ismember(ConTable_excl.AgeGroup,2)));
stds_oa.CC = nanstd(ConTable_excl.CC(ismember(ConTable_excl.AgeGroup,2)));
stds_oa.InterHemC = nanstd(ConTable_excl.InterHemC(ismember(ConTable_excl.AgeGroup,2)));
stds_oa.TCOMM = nanstd(ConTable_excl.TCOMM(ismember(ConTable_excl.AgeGroup,2)));

%% group comparisons EXCLUDE 1276, 2129, and 2149, control for gender

addpath(genpath('~/Desktop/MATLAB/mancovan_496'))

groupcomp_excl = struct();

groupcomp_global = struct();

for i = 1:6
    [groupcomp_global(i,:).T,groupcomp_global(i,:).p,...
        groupcomp_global(i,:).FANCOVAN,groupcomp_global(i,:).pANCOVAN,...
        groupcomp_global(i,:).stats] = mancovan(ConTable_excl{:,i+4},...
        ConTable_excl.AgeGroup,ConTable_excl.Sex); % ,{'verbose'}
end

%% correction for multiple comparisons
addpath(genpath('~/Desktop/MATLAB/bonf_holm'))

for i = 1:6
    global_p(i,[1:2]) = (groupcomp_global(i).p);
end

[global_corr_p,h] = bonf_holm(global_p([1:6],:),0.05);

%% summary table

global_anova(:,1) = table({'numfibers';'CPL';'EFF';'CC';'InterHemC';'TCOMM'});
global_anova(:,[2 3]) = array2table(h);
global_anova(:,[4 5]) = array2table(global_corr_p);

global_anova.Properties.VariableNames = {'measure','h_group','h_sex',...
    'p_group','p_sex'};

%% clear

clearvars -except ConTable ConTable_local ConTable_excl global_anova local_anova subjs
