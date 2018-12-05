function IndividualActivations_phoc_batch_event_PM
% if running ad-hoc, be careful of contrast # (results.conspec.contasts)

spm('defaults','fmri')
spm_jobman('initcfg');

IDs = {'1117';'1118';'1120';'1124';'1125';'1126';'1131';'1132';'1135';'1136';...
    '1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';...
    '1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';...
    '1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281';...
    '2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2132';'2133';'2134';'2135';'2139';'2140';'2145';'2147';'2149';'2157';...
    '2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';...
    '2215';'2216';'2217';'2219';'2222';'2224';'2226';'2227';'2236';'2238';...
    '2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

for indID = 1:numel(IDs)
    
    disp(['Processing ', IDs{indID}]);
    
    %load(['/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/tardis/B_data/SPM_Mixed/' IDs{indID} '/' 'SPM.mat'], 'matlabbatch');
    
    matlabbatch{1}.spm.stats.results.spmmat = {['/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/tardis/B_data/v7219/SPM_wcueprobe_3Cue_wmask_wmot_PM/' IDs{indID} '/' 'SPM.mat']};
    matlabbatch{1}.spm.stats.results.conspec.titlestr = '';
    matlabbatch{1}.spm.stats.results.conspec.contrasts = 2;
    matlabbatch{1}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{1}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch{1}.spm.stats.results.conspec.extent = 20;
    matlabbatch{1}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{1}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{1}.spm.stats.results.units = 1;
    matlabbatch{1}.spm.stats.results.export{1}.pdf = true;
    spm_jobman('run', matlabbatch);
    
    clear matlabbatch;
    
end

end

