function createbatch_BetGroup(DATADIR)

%Note AP removed 2131, 2237, 1215 (see one note)
%AP additionally remove 2132 (again, see onenote) - not 1124
%JK remove 2139, 2227 - anatomical abnormalities
%Actually remove 2203, for now (missing mot file)

yID = {'1117';'1118';'1120';'1124';'1125';'1126';'1131';'1132';'1135';'1136';'1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';'1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281'};
oID = {'2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2133';'2134';'2135';'2140';'2145';'2147';'2149';'2157';'2160';'2201';'2202';'2205';'2206';'2209';'2210';'2211';'2213';'2214';'2215';'2216';'2217';'2219';'2222';'2224';'2226';'2236';'2238';'2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

matlabbatch{1}.spm.stats.factorial_design.dir = {[DATADIR '/ SPM_all_betgrp/']};

for i = 1:length(yID)
    
    subjID=yID(i);
    Yscans(i,1)={fullfile(DATADIR, subjID{1}, 'con_0003.nii,1')};
    
end

matlabbatch{1}.spm.stats.factorial_design.des.t2.scans1 = Yscans;

for i = 1:length(oID)
    
    subjID=oID(i);
    Oscans(i,1)={fullfile(DATADIR, subjID{1}, 'con_0003.nii,1')};
    
end

matlabbatch{1}.spm.stats.factorial_design.des.t2.scans2 = Oscans;

matlabbatch{1}.spm.stats.factorial_design.des.t2.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.t2.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.t2.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;

%%Model estimation
matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('Factorial design specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;

mkdir([DATADIR '/' 'SPM_all_betgrp']);
save([DATADIR '/' 'SPM_all_betgrp' '/' 'SPM2ndBatchGroupLoadFGLM.mat'], 'matlabbatch');
