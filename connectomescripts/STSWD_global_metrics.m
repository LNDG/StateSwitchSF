function [global_anova,global_means,gl_outliers,gl_outliers_ya,gl_outliers_oa] = STSWD_global_metrics(outliers,multivaroutliers)

%% global metrics 

% dependencies:
% - ConTable (STSWD_master.m)

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/

load('for_metrics.mat')

%% check for outliers per measure (global) 

if outliers ~= 0

    %across groups

    gl_outliers = struct();
    for i = 1:7
        gl_outliers.global(:,i) = isoutlier(ConTable{:,i+4},'mean'); 

        for j = 1:94
            if gl_outliers.global(j,i) == 1
                gl_outliers.globalwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
            else
                gl_outliers.globalwhich(j,i) = 0;
            end

            gl_outliers.nglobal(j,1) = str2num(cell2mat(subjs(j)));
            gl_outliers.nglobal(j,2) = sum(gl_outliers.global(j,:)); 
        end
    end

    gl_outliers_ya = struct();
    for i = 1:7
        gl_outliers_ya.global(:,i) = isoutlier(ConTable{ismember(ConTable.AgeGroup,1),i+4},'mean'); 

        for j = 1:41
            if gl_outliers_ya.global(j,i) == 1
                gl_outliers_ya.globalwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
            else
                gl_outliers_ya.globalwhich(j,i) = 0;
            end
            gl_outliers_ya.nglobal(j,1) = str2num(cell2mat(subjs(j)));
            gl_outliers_ya.nglobal(j,2) = sum(gl_outliers_ya.global(j,:)); 
        end
    end

    gl_outliers_oa = struct();
    for i = 1:7
        gl_outliers_oa.global(:,i) = isoutlier(ConTable{ismember(ConTable.AgeGroup,2),i+4},'mean'); 

        for j = 1:53
            if gl_outliers_oa.global(j,i) == 1
                gl_outliers_oa.globalwhich(j,i) = str2num(cell2mat(subjs(j+41))); % which ID
            else
                gl_outliers_oa.globalwhich(j,i) = 0;
            end
            gl_outliers_oa.nglobal(j,1) = str2num(cell2mat(subjs(j+41)));
            gl_outliers_oa.nglobal(j,2) = sum(gl_outliers_oa.global(j,:)); 
        end
    end

end

%% check for outliers across variables

if multivaroutliers ~= 0

    addpath(genpath('~/Desktop/MATLAB/moutlier1'));
    moutlier1(ConTable{:,[5:11]},.10) %across all 1243
    moutlier1(ConTable{(ismember(ConTable.AgeGroup,1)),[5:11]},.10) %within YA 1243
    moutlier1(ConTable{(ismember(ConTable.AgeGroup,2)),[5:11]},.10) %within OA 2219, 2226

end

%% descriptives 
global_means = table();
global_means.metric = {'numfibers';'CPL';'EFF';'CC';'InterHemC';'TCOMM';'MAD'};

for i = 1:7
    global_means{i,2} = cell2mat(num2cell(nanmean(ConTable{(ismember(ConTable.AgeGroup,1)),i+4})));
    global_means{i,3} = cell2mat(num2cell(nanmean(ConTable{(ismember(ConTable.AgeGroup,2)),i+4})));
    global_means{i,4} = cell2mat(num2cell(nanstd(ConTable{(ismember(ConTable.AgeGroup,1)),i+4})));
    global_means{i,5} = cell2mat(num2cell(nanstd(ConTable{(ismember(ConTable.AgeGroup,2)),i+4})));
end

global_means.Properties.VariableNames = {'metric','mean_ya','mean_oa','std_ya','std_oa'};

%% group comparisons, control for gender

addpath(genpath('~/Desktop/MATLAB/mancovan_496'))

groupcomp_global = struct();

for i = 1:7
    [groupcomp_global(i,:).T,groupcomp_global(i,:).p,...
        groupcomp_global(i,:).FANCOVAN,groupcomp_global(i,:).pANCOVAN,...
        groupcomp_global(i,:).stats] = mancovan(ConTable{:,i+4},...
        ConTable.AgeGroup,ConTable.Sex); % ,{'verbose'}
end

%% correction for multiple comparisons
addpath(genpath('~/Desktop/MATLAB/bonf_holm'))

for i = 1:7
    global_p(i,[1:2]) = (groupcomp_global(i).p);
end

[global_corr_p,h] = bonf_holm(global_p([1:7],:),0.05);

%% summary table

global_anova(:,1) = table({'numfibers';'CPL';'EFF';'CC';'InterHemC';'TCOMM';'MAD'});
global_anova(:,[2 3]) = array2table(h);
for i = 1:7
    global_anova(i,4) = array2table(groupcomp_global(i).FANCOVAN(1));
end
global_anova(:,[5 6]) = array2table(global_corr_p);

global_anova.Properties.VariableNames = {'measure','h_group','h_sex',...
    'F','p_group','p_sex'};

%% clear

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/

clearvars -except ConTable gl_outliers gl_outliers_ya gl_outliers_oa global_anova global_means subjs

save('for_beehives.mat')

end