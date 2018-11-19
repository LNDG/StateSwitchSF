function createbatch_GroupLoadEffects_OA(DATADIR)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

%Note AP removed 1120, 2131, 2237, 1215 (see one note) - and now 2132
oID = {'2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2133';'2134';'2135';'2139';'2140';'2145';'2147';'2149';'2157';'2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';'2215';'2216';'2217';'2219';'2222';'2224';'2226';'2227';'2236';'2238';'2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

%% Model spefication 
matlabbatch{1}.spm.stats.factorial_design.dir = {'/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/tardis/B_data/v7219/SPM_Mixed_noAR_Julian/SPM_OA/'};

%old ppl only
for i = 1:length(oID)   
subjID=oID(i); 
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).scans = {fullfile(DATADIR, subjID{1}, 'con_0001.nii,1');
                                                                                    fullfile(DATADIR, subjID{1}, 'con_0002.nii,1');
                                                                                    fullfile(DATADIR, subjID{1}, 'con_0003.nii,1');
                                                                                    fullfile(DATADIR, subjID{1}, 'con_0004.nii,1');
                                                                                    };                                                                        
matlabbatch{1}.spm.stats.factorial_design.des.anovaw.fsubject(i).conds = [1 2 3 4];
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

mkdir([DATADIR '/' 'SPM_OA']);
save([DATADIR '/' 'SPM_OA' '/' 'SPM2ndBatchGroupLoadFGLM.mat'], 'matlabbatch');