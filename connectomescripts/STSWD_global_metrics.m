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


%% check for outliers across variables

addpath(genpath('~/Desktop/MATLAB/moutlier1'));
moutlier1(ConTable{:,[5:10]},.10) %across all 1243
moutlier1(ConTable{(ismember(ConTable.AgeGroup,1)),[5:10]},.10) %within YA 1243
moutlier1(ConTable{(ismember(ConTable.AgeGroup,2)),[5:10]},.10) %within OA 2149, 2226

%% exclude outliers

% ConTable_excl = table();
% ConTable_excl = ConTable;
% ConTable_excl(ismember(ConTable_excl.ID_demogr,1276),:) = [];
% ConTable_excl(ismember(ConTable_excl.ID_demogr,2129),:) = [];
% ConTable_excl(ismember(ConTable_excl.ID_demogr,2149),:) = [];

%% descriptives 
global_means = table();
global_means.metric = {'numfibers';'CPL';'EFF';'CC';'InterHemC';'TCOMM'};

for i = 1:6
    global_means{i,2} = cell2mat(num2cell(nanmean(ConTable{(ismember(ConTable.AgeGroup,1)),i+4})));
    global_means{i,3} = cell2mat(num2cell(nanmean(ConTable{(ismember(ConTable.AgeGroup,2)),i+4})));
    global_means{i,4} = cell2mat(num2cell(nanstd(ConTable{(ismember(ConTable.AgeGroup,1)),i+4})));
    global_means{i,5} = cell2mat(num2cell(nanstd(ConTable{(ismember(ConTable.AgeGroup,2)),i+4})));
end

global_means.Properties.VariableNames = {'metric','mean_ya','mean_oa','std_ya','std_oa'};

%% group comparisons, control for gender

addpath(genpath('~/Desktop/MATLAB/mancovan_496'))

groupcomp_global = struct();

for i = 1:6
    [groupcomp_global(i,:).T,groupcomp_global(i,:).p,...
        groupcomp_global(i,:).FANCOVAN,groupcomp_global(i,:).pANCOVAN,...
        groupcomp_global(i,:).stats] = mancovan(ConTable{:,i+4},...
        ConTable.AgeGroup,ConTable.Sex); % ,{'verbose'}
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
for i = 1:6
    global_anova(i,4) = array2table(groupcomp_global(i).FANCOVAN(1));
end
global_anova(:,[5 6]) = array2table(global_corr_p);

global_anova.Properties.VariableNames = {'measure','h_group','h_sex',...
    'F','p_group','p_sex'};

%% clear

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/

clearvars -except ConTable ConTable_excl ConTable_local global_anova global_means local_anova subjs

save('for_beehives.mat')
