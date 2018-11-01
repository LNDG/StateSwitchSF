%% global metrics 

% dependencies:
% - ConTable_local (STSWD_master.m)

%% check for outliers - per variable

outliers = struct();
for i = 1:164
    outliers.STR(:,i) = isoutlier(ConTable_local{:,i+5},'mean'); 
    outliers.DEG(:,i) = isoutlier(ConTable_local{:,i+168},'mean'); 

    for j = 1:94
        if outliers.STR(j,i) == 1
            outliers.STRwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
        else
            outliers.STRwhich(j,i) = 0;
        end
        outliers.nSTR(j,1) = str2num(cell2mat(subjs(j)));
        outliers.nSTR(j,2) = sum(outliers.STR(j,:)); 
        
        if outliers.DEG(j,i) == 1
            outliers.DEGwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
        else
            outliers.DEGwhich(j,i) = 0;
        end
        outliers.nDEG(j,1) = str2num(cell2mat(subjs(j)));
        outliers.nDEG(j,2) = sum(outliers.DEG(j,:));

    end
end

outliers_ya = struct();
for i = 1:164
    outliers_ya.STR(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,1),i+5},'mean'); 
    outliers_ya.DEG(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,1),i+168},'mean'); 

    for j = 1:41
        if outliers_ya.STR(j,i) == 1
            outliers_ya.STRwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
        end
        outliers_ya.nSTR(j,1) = str2num(cell2mat(subjs(j)));
        outliers_ya.nSTR(j,2) = sum(outliers_ya.STR(j,:)); 
        
        if outliers_ya.DEG(j,i) == 1
            outliers_ya.DEGwhich(j,i) = str2num(cell2mat(subjs(j))); % which ID
        end
        outliers_ya.nDEG(j,1) = str2num(cell2mat(subjs(j)));
        outliers_ya.nDEG(j,2) = sum(outliers_ya.DEG(j,:));

    end
end

outliers_oa = struct();
for i = 1:164
    outliers_oa.STR(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,2),i+5},'mean'); 
    outliers_oa.DEG(:,i) = isoutlier(ConTable_local{ismember(ConTable_local.AgeGroup,2),i+168},'mean'); 

    for j = 1:53
        if outliers_oa.STR(j,i) == 1
            outliers_oa.STRwhich(j,i) = str2num(cell2mat(subjs(j+41))); % which ID
        end
        outliers_oa.nSTR(j,1) = str2num(cell2mat(subjs(j+41)));
        outliers_oa.nSTR(j,2) = sum(outliers_oa.STR(j,:)); 
        
        if outliers_oa.DEG(j,i) == 1
            outliers_oa.DEGwhich(j,i) = str2num(cell2mat(subjs(j+41))); % which ID
        end
        outliers_oa.nDEG(j,1) = str2num(cell2mat(subjs(j+41)));
        outliers_oa.nDEG(j,2) = sum(outliers_oa.DEG(j,:));

    end
end

%% outliers across variables

addpath(genpath('~/Desktop/MATLAB/moutlier1'));
moutlier1(ConTable_local{:,[5:168]},.10) %STR none
moutlier1(ConTable_local{:,[169:end]},.10) %DEG none

moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,1)),[5:168]},.10) %within YA STR none
moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,1)),[169:end]},.10) %within YA DEG none

moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,2)),[5:168]},.10) %within OA STR none
moutlier1(ConTable_local{(ismember(ConTable_local.AgeGroup,2)),[169:end]},.10) %within OA DEG none

%% group comp
addpath(genpath('~/Desktop/MATLAB/mancovan_496'))

groupcomp = struct();

for i = 1:328
    [groupcomp(i,:).T,groupcomp(i,:).p,...
        groupcomp(i,:).FANCOVAN,groupcomp(i,:).pANCOVAN,...
        groupcomp(i,:).stats] = mancovan(ConTable_local{:,i+4},...
        ConTable_local.AgeGroup,ConTable_local.Sex); % ,{'verbose'}
end

%% correction for multiple comparisons
addpath(genpath('~/Desktop/MATLAB/fdr_bh'))

for i = 1:328
    local_p(i,[1:2]) = (groupcomp(i).p);
end


[STR_h, crit_p, adj_ci_cvrg, STR_adj_p] = fdr_bh(local_p([1:164],:),0.05);
[DEG_h, crit_p, adj_ci_cvrg, DEG_adj_p] = fdr_bh(local_p([165:end],:),0.05);

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
cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_Data

fileID = fopen('roi_labels.txt');
roi_labels = textscan(fileID,'%s');
fclose(fileID);

local_anova(:,1) = table(roi_labels{1,1});
local_anova(:,[2 3]) = array2table(STR_h);
local_anova(:,[4 5]) = array2table(STR_adj_p);
local_anova(:,[6 7]) = array2table(DEG_h);
local_anova(:,[8 9]) = array2table(DEG_adj_p);

local_anova.Properties.VariableNames = {'measure','h_STR_group','h_STR_sex',...
    'p_STR_group','p_STR_sex','h_DEG_group','h_DEG_sex','p_DEG_group','p_DEG_sex'};

%% clear

clearvars -except ConTable ConTable_local ConTable_excl global_anova local_anova subjs

