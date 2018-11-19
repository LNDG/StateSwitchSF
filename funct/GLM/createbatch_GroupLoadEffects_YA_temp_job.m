function createbatch_GroupLoadEffects_YA(DATADIR)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Note AP removed 1120, 2131, 2237, 1215 (see one note)
yID = {'1117';'1118';'1124';'1125';'1126';'1131';'1132';'1135';'1136';'1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';'1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281'};

%% Model spefication 
matlabbatch{1}.spm.stats.factorial_design.dir = {'/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/tardis/B_data/SPM_Mixed/SPM_YA/'};

%young ppl only
for i = 1:length(yID)   
subjID=yID(i); 
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(1).scans = {fullfile(DATADIR, subjID{1}, 'con_0001.nii,1');                                                                                 };
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(1).conds = [1 2 3 4];
end

matlabbatch{1}.spm.stats.factorial_design.des.anovaw.dept = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%% Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

mkdir([DATADIR '/' 'SPM_YA']);
save([DATADIR '/' 'SPM_YA' '/' 'SPM2ndBatchGroupLoadFGLM.mat'], 'matlabbatch');