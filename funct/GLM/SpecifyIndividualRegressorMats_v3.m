% Create SPM experimental condition info for each subject for variability toolbox

% Here: stick-function (i.e. 1 event stimulus onset)
% Some things need to be considered for the variability toolbox:
% - duration always needs to be poitive (vs. SPM convention of 0 for stick)
% - 4D images have to be listed as individual 3D images with 4D index

% v3: create Dim-Att regressors, include cue onset, probe onset regressors
% use FAST model instead of AR(1): Corbin, N., Todd, N., Friston, K. J., & Callaghan, M. F. (2018). Accurate modeling of temporal correlations in rapidly sampled fMRI time series. Human Brain Mapping, 26(3), 839?14. http://doi.org/10.1002/hbm.24218

% N = 44 YA + 53 OA;
% AP remove 2131, 2237, 1215 (see oNe Note)

IDs = {'1117';'1118';'1120';'1124';'1125';'1126';'1131';'1132';'1135';'1136';...
    '1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';...
    '1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';...
    '1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281';...
    '2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';...
    '2132';'2133';'2134';'2135';'2139';'2140';'2145';'2147';'2149';'2157';...
    '2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';...
    '2215';'2216';'2217';'2219';'2222';'2224';'2226';'2227';'2236';'2238';...
    '2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

pn.root = '/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/';
%addpath([pn.root, 'T_tools/spm12/']); % add spm functions

for indID = 1:numel(IDs)

    disp(['Processing ', IDs{indID}]);
    
    matlabbatch = cell(1);
    
        % specify general parameters
    matlabbatch{1}.spm.stats.fmri_spec.dir = {['/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/A_SPMfiles/',IDs{indID}, '/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.645;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 1];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'FAST';
    
    % load example batch to edit
    %load([pn.root, 'B_data/C_batchFiles/ExampleBatch.mat'])

    % include mask image
    % matlabbatch{1}.spm.stats.fmri_spec.mask={'/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/B_PLS/B_data/VoxelOverlap/coords_nozero_N97.nii'};
    
    if strcmp(IDs{indID}, '2131') || strcmp(IDs{indID}, '2237')
        numOfRuns = 2;
    else
        numOfRuns = 4;
    end
    
    for indSession = 1:numOfRuns
        
        % get regressor data
        pn.regressors = '/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/A_extractDesignTiming/B_data/A_regressors/';
        load([pn.regressors, IDs{indID}, '_Run',num2str(indSession),'_regressors.mat'])
        % change regressor matrix, such that column 4 represents trial-by-trial
        % indices of dimensionality
        blockOnsets=find(Regressors(:,1) == 1);
        for indBlock = 1:numel(blockOnsets)
           if indBlock == numel(blockOnsets)
               Regressors(blockOnsets(indBlock):end,4) = ...
                   Regressors(blockOnsets(indBlock),4);
           else
               Regressors(blockOnsets(indBlock):blockOnsets(indBlock+1)-1,4) = ...
                   Regressors(blockOnsets(indBlock),4);
           end
        end
        % For the scans, we need to specify separate 3D images via comma seperator
        % Under the hood: design-specified time points are extracted from 2D voxel*time matrix
        basefile = ['/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/B_PLS/B_data/BOLDin/',IDs{indID},'_run-',num2str(indSession),'_feat_detrended_bandpassed_FIX_MNI3mm.nii'];
        basefileInfo = spm_vol(basefile);
        N = size(basefileInfo,1);
        allFiles = cell(1);
        for indVol = 1:N
            allFiles{indVol,1} = [basefile, ',', num2str(indVol)];
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).scans = allFiles;
        indCond = 1;
        for indDim = 1:4
            for indAtt = 1:4
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).name = ['StimOnset_dim',num2str(indDim), '_Att',num2str(indAtt)];
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset = find(Regressors(:,3) == 1 & Regressors(:,4) == indDim & Regressors(:,6+indAtt) == 1); % IMPORTANT: SPM starts counting at 0
            onsets = matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset;
            %matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(1, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(5, numel(onsets), 1); clear onsets;
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).orth = 0;
            indCond = indCond + 1;
            end
        end
        % add cue regressor
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).name = 'CueOnset';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset = find(Regressors(:,2) == 1); % IMPORTANT: SPM starts counting at 0
        onsets = matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(0, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).orth = 0;
        indCond = indCond + 1;
        % add probe regressor
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).name = 'ProbeOnset';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset = find(Regressors(:,11) == 1); % IMPORTANT: SPM starts counting at 0
        onsets = matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(0, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).orth = 0;
        % add general session information
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi_reg = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 1];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'FAST';
    end % session loop (i.e. runs)

    save([pn.root, 'B_data/D_batchFiles1stLevelGLM-redo/',IDs{indID},'_SPM1stBatchGLM.mat'], 'matlabbatch')
    
end % subject loop
