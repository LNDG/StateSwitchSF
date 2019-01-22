function [local_anova,lo_outliers,lo_outliers_ya,lo_outliers_oa] = STSWD_local_metrics(outliers,multivaroutliers)

%% local metrics 

% dependencies:
% - ConTable_local (STSWD_master.m)

cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/

load('for_metrics.mat')

%% check for outliers - per variable

if outliers ~= 0
    
    lo_outliers = struct();
    for i = 1:162
        lo_outliers.STR(:,i) = isoutlier(ConTable_local{:,i+5},'mean'); 
        lo_outliers.DEG(:,i) = isoutlier(ConTable_local{:,i+166},'mean'); 

        for j = 1:94
            if lo_outliers.STR(j,i) == 1
                lo_outliers.STRwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
            else
                lo_outliers.STRwhich(j,i) = 0;
            end
            lo_outliers.nSTR(j,1) = str2num(cell2mat(subjs(j)));
            lo_outliers.nSTR(j,2) = sum(lo_outliers.STR(j,:)); 

            if lo_outliers.DEG(j,i) == 1
                lo_outliers.DEGwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
            else
                lo_outliers.DEGwhich(j,i) = 0;
            end
            lo_outliers.nDEG(j,1) = str2num(cell2mat(subjs(j)));
            lo_outliers.nDEG(j,2) = sum(lo_outliers.DEG(j,:));

        end
    end

    lo_outliers_ya = struct();
    for i = 1:162
        lo_outliers_ya.STR(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,1),i+5},'mean'); 
        lo_outliers_ya.DEG(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,1),i+166},'mean'); 

        for j = 1:41
            if lo_outliers_ya.STR(j,i) == 1
                lo_outliers_ya.STRwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
            end
            lo_outliers_ya.nSTR(j,1) = str2num(cell2mat(subjs(j)));
            lo_outliers_ya.nSTR(j,2) = sum(lo_outliers_ya.STR(j,:)); 

            if lo_outliers_ya.DEG(j,i) == 1
                lo_outliers_ya.DEGwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
            end
            lo_outliers_ya.nDEG(j,1) = str2num(cell2mat(subjs(j)));
            lo_outliers_ya.nDEG(j,2) = sum(lo_outliers_ya.DEG(j,:));

        end
    end

    lo_outliers_oa = struct();
    for i = 1:162
        lo_outliers_oa.STR(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,2),i+5},'mean'); 
        lo_outliers_oa.DEG(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,2),i+166},'mean'); 

        for j = 1:53
            if lo_outliers_oa.STR(j,i) == 1
                lo_outliers_oa.STRwhich(j,i) = str2num(cell2mat(subjs(j+41))); % which ID
            end
            lo_outliers_oa.nSTR(j,1) = str2num(cell2mat(subjs(j+41)));
            lo_outliers_oa.nSTR(j,2) = sum(lo_outliers_oa.STR(j,:)); 

            if lo_outliers_oa.DEG(j,i) == 1
                lo_outliers_oa.DEGwhich(j,i) = str2num(cell2mat(subjs(j+41))); % which ID
            end
            lo_outliers_oa.nDEG(j,1) = str2num(cell2mat(subjs(j+41)));
            lo_outliers_oa.nDEG(j,2) = sum(lo_outliers_oa.DEG(j,:));

        end
    end
    
end

%% outliers across variables

if multivaroutliers ~= 0
    
    addpath(genpath('~/Desktop/MATLAB/moutlier1'));
    moutlier1(ConTable_local{:,[5:166]},.10) %STR none
    moutlier1(ConTable_local{:,[167:end]},.10) %DEG none

    moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,1)),[5:166]},.10) %within YA STR none
    moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,1)),[167:end]},.10) %within YA DEG none

    moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,2)),[5:166]},.10) %within OA STR none
    moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,2)),[167:end]},.10) %within OA DEG none

end

%% group comp
addpath(genpath('~/Desktop/MATLAB/mancovan_496'))

groupcomp_local = struct();

for i = 1:324
    [groupcomp_local(i,:).T,groupcomp_local(i,:).p,...
        groupcomp_local(i,:).FANCOVAN,groupcomp_local(i,:).pANCOVAN,...
        groupcomp_local(i,:).stats] = mancovan(ConTable_local{:,i+4},...
        ConTable_local.AgeGroup,ConTable_local.Sex); % ,{'verbose'}
end

%% t-tests

ttest_local = struct();

for i = 1:324
    [ttest_local(i,:).h,ttest_local(i,:).p,ttest_local(i,:).ci,...
        ttest_local(i,:).stats] = ttest2(ConTable_local{find(ismember(ConTable_local.AgeGroup,1)),i+4},...
        ConTable_local{find(ismember(ConTable_local.AgeGroup,2)),i+4}); 
end

for i = 1:162
    t_STR(i,:) = (ttest_local(i).stats.tstat);
    t_DEG(i,:) = (ttest_local(i+162).stats.tstat)
end

%% correction for multiple comparisons
addpath(genpath('~/Desktop/MATLAB/fdr_bh'))

for i = 1:324
    local_p(i,[1:2]) = (groupcomp_local(i).p);
end


[STR_h, crit_p, adj_ci_cvrg, STR_adj_p] = fdr_bh(local_p([1:162],:),0.05);
[DEG_h, crit_p, adj_ci_cvrg, DEG_adj_p] = fdr_bh(local_p([163:end],:),0.05);

% for i = 1:length(STR_adj_p)
%     for j = 1:2
%         if STR_adj_p(i,j) > 0.05
%             STR_adj_p(i,j) = NaN;
%         end
%     end
% end
% 
% for i = 1:length(DEG_adj_p)
%     for j = 1:2
%         if DEG_adj_p(i,j) > 0.05
%             DEG_adj_p(i,j) = NaN;
%         end
%     end
% end

%% create summary table
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_Data

fileID = fopen('roi_labels.txt');
roi_labels = textscan(fileID,'%s');
fclose(fileID);

local_anova(:,1) = table(roi_labels{1,1});
local_anova([75 164],:) = [];
local_anova(:,[2 3]) = array2table(STR_h);
for i = 1:162
    local_anova(i,4) = array2table(groupcomp_local(i).FANCOVAN(1));
end
local_anova(:,[5 6]) = array2table(STR_adj_p);
local_anova(:,[7 8]) = array2table(DEG_h);
for i = 1:162
    local_anova(i,9) = array2table(groupcomp_local(i+162).FANCOVAN(1));
end
local_anova(:,[10 11]) = array2table(DEG_adj_p);
local_anova(:,12) = table(t_STR);
local_anova(:,13) = table(t_DEG);

local_anova.Properties.VariableNames = {'measure','h_STR_group','h_STR_sex',...
    'F_STR','p_STR_group','p_STR_sex','h_DEG_group','h_DEG_sex','F_DEG',...
    'p_DEG_group','p_DEG_sex','t_STR','t_DEG'}; 

%% clear

clearvars -except ConTable lo_outliers lo_outliers_ya lo_outliers_oa local_anova local_means subjs

end
