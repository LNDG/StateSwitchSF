function IndividualActivations_batch

spm('defaults','fmri')
spm_jobman('initcfg');

IDs = {'1117';'1118';'1124';'1125';'1126';'1131';'1132';'1135';'1136';...
    '1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';...
    '1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';...
    '1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281';...
    '2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2132';'2133';'2134';'2135';'2139';'2140';'2145';'2147';'2149';'2157';...
    '2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';...
    '2215';'2216';'2217';'2219';'2222';'2224';'2226';'2227';'2236';'2238';...
    '2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

for indID = 1:numel(IDs)
    
    disp(['Processing ', IDs{indID}]);
    
    matlabbatch{1}.spm.stats.con.spmmat = {'/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/tardis/B_data/SPM_Mixed/1117/SPM.mat'};
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.name = 'Dim 1 < Dim2-4';
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.weights = [-3 1 1 1 0 0 0 0 0 0];
    matlabbatch{1}.spm.stats.con.consess{6}.tcon.sessrep = 'replsc';
    matlabbatch{1}.spm.stats.con.delete = 0;
    
    matlabbatch{2}.spm.stats.results.spmmat = {'/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/tardis/B_data/SPM_Mixed/1117/SPM.mat'};
    matlabbatch{2}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{2}.spm.stats.results.conspec.contrasts = 6;
    matlabbatch{2}.spm.stats.results.conspec.threshdesc = 'FWE';
    matlabbatch{2}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch{2}.spm.stats.results.conspec.extent = 20;
    matlabbatch{2}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{2}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{2}.spm.stats.results.units = 1;
    matlabbatch{2}.spm.stats.results.export{1}.ps = true;
    matlabbatch{2}.spm.stats.results.export{2}.pdf = true;
    
    spm_jobman('run', matlabbatch);
    
    clear matlabbatch;
    
end

end

