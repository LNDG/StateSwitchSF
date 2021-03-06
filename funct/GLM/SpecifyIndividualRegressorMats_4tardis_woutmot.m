function SpecifyIndividualRegressorMats_4tardis_woutmot(PREPROCDIR, OUTDIR)

% Create SPM experimental condition info for each subject for later
% batching with tardis

% v3: create Dim-Att regressors, include cue onset, probe onset regressors
% use FAST modelinstead of AR(1): Corbin, N., Todd, N., Friston, K. J., & Callaghan, M. F. (2018). Accurate modeling of temporal correlations in rapidly sampled fMRI time series. Human Brain Mapping, 26(3), 839?14. http://doi.org/10.1002/hbm.24218
% - AP to change back
% v4: AP remove -1 from design timing, but add durations to cue (1 volume) and
% probe (2).

% N = 44 YA + 53 OA;
% AP remove 2131, 2237, 1215 (see oNe Note)

%fake update

IDs = {'1117';'1118';'1120';'1124';'1125';'1126';'1131';'1132';'1135';'1136';...
    '1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';...
    '1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';...
    '1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281';...
    '2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';...
    '2132';'2133';'2134';'2135';'2139';'2140';'2145';'2147';'2149';'2157';...
    '2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';...
    '2215';'2216';'2217';'2219';'2222';'2224';'2226';'2227';'2236';'2238';...
    '2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

%Path to Base Dir of local output
pn.root = '/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/';
mkdir([pn.root, 'B_data/D_batchFiles1stLevelGLM-', OUTDIR,'-tardis/']);
%addpath([pn.root, 'T_tools/spm12/']); % add spm functions

for indID = 1:numel(IDs)
    
    disp(['Processing ', IDs{indID}]);
    
    matlabbatch = cell(1);
    
    % specify general parameters
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/SPMfiles/SPM_' OUTDIR '/' IDs{indID} '/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.645;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'FAST';
    
    
    % subjects with different run number
    
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
        basefile = ['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/Scans/',IDs{indID},'/preproc/run-',num2str(indSession),'/',IDs{indID},'_run-',num2str(indSession),'_feat_detrended_bandpassed_FIX_MNI3mm.nii'];
        
        allFiles={};
        if strcmp(IDs{indID}, '2132') && indSession == 2
            disp(['Change #volumes for run2']);
            for indVol = 1:1040
                allFiles{indVol,1} = [basefile, ',', num2str(indVol)];
            end
        else
            for indVol = 1:1054
                allFiles{indVol,1} = [basefile, ',', num2str(indVol)];
            end
        end
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).scans = allFiles;
        
        % stimulus viewing condition
        indCond = 1;
        for indDim = 1:4
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).name = ['StimOnset_dim',num2str(indDim)];
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset = find(Regressors(:,3) == 1 & Regressors(:,4) == indDim); % IMPORTANT: SPM starts counting at 0
            onsets = matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset;
            %matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(1, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(4, numel(onsets), 1); clear onsets;
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).tmod = 0;
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).pmod = struct('name', {}, 'param', {}, 'poly', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).orth = 0;
            indCond = indCond + 1;
        end
        
        % add cue regressor
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).name = 'CueOnset';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset = find(Regressors(:,2) == 1); % IMPORTANT: SPM starts counting at 0
        onsets = matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(3, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).orth = 0;
        indCond = indCond + 1;
        
        % add probe regressor
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).name = 'ProbeOnset';
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset = find(Regressors(:,11) == 1); % IMPORTANT: SPM starts counting at 0
        onsets = matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).onset;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).duration = repmat(2, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).tmod = 0;
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).pmod = struct('name', {}, 'param', {}, 'poly', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(indCond).orth = 0;
        
        %% add regressors
        
        
        if(exist([PREPROCDIR '/' IDs{indID} '/' 'preproc' '/' 'run-' int2str(indSession) '/' 'motionout' '/' IDs{indID} '_motionout_scol.txt']))
            
            MotConfoundFile=['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/MotionParameters/' IDs{indID} '/' 'sess-' int2str(indSession) '/' IDs{indID} '_motionout_scol.txt'];
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi_reg={MotConfoundFile
                ['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/MotionParameters/' IDs{indID} '/' IDs{indID} '_sess-' int2str(indSession) '_motion_6dof.txt']};
            
            
        else
            
            matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi_reg={['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/MotionParameters/' IDs{indID} '/' IDs{indID} '_sess-' int2str(indSession) '_motion_6dof.txt']};
            
        end
        
        %% add general session information
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {'/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/Standards/GM_MNI3mm_mask.nii'};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'FAST';
    end % session loop (i.e. runs)
    
    %% Estimate Model
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    %% Now contrasts: Simple Contrast Effects (for now)
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('fMRI Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    % With only one HRF derivative
    % Have to meticulosuly setup the contrast weights (wait for Alex on
    % confirmation on those w/out outlier files)
    
    ConWeights=struct;
    
    for indSession = 1:numOfRuns
        
        if(exist([PREPROCDIR '/' IDs{indID} '/' 'preproc' '/' 'run-' int2str(indSession) '/' 'motionout' '/' IDs{indID} '_motionout_scol.txt']))
            
            ConWeights.(['Sess_' int2str(indSession) '_Con1']) = [0.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            ConWeights.(['Sess_' int2str(indSession) '_Con2']) = [0 0 0.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            ConWeights.(['Sess_' int2str(indSession) '_Con3']) = [0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            ConWeights.(['Sess_' int2str(indSession) '_Con4']) = [0 0 0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0 0 0];
            
        else
            
            ConWeights.(['Sess_' int2str(indSession) '_Con1']) = [0.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            ConWeights.(['Sess_' int2str(indSession) '_Con2']) = [0 0 0.25 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            ConWeights.(['Sess_' int2str(indSession) '_Con3']) = [0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0 0 0 0];
            
            ConWeights.(['Sess_' int2str(indSession) '_Con4']) = [0 0 0 0 0 0 0.25 0 0 0 0 0 0 0 0 0 0 0];
            
        end
        
    end
    
    
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
    
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Dim 1';
    
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = cat(2, ConWeights.(['Sess_' int2str(1) '_Con1']), ConWeights.(['Sess_' int2str(2) '_Con1']), ConWeights.(['Sess_' int2str(3) '_Con1']), ConWeights.(['Sess_' int2str(4) '_Con1']));
    
    
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'none';
    
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Dim 2';
    
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = cat(2, ConWeights.(['Sess_' int2str(1) '_Con2']), ConWeights.(['Sess_' int2str(2) '_Con2']), ConWeights.(['Sess_' int2str(3) '_Con2']), ConWeights.(['Sess_' int2str(4) '_Con2']));
    
    
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'none';
    
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Dim 3';
    
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = cat(2, ConWeights.(['Sess_' int2str(1) '_Con3']), ConWeights.(['Sess_' int2str(2) '_Con3']), ConWeights.(['Sess_' int2str(3) '_Con3']), ConWeights.(['Sess_' int2str(4) '_Con3']));
    
    
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'none';
    
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Dim 4';
    
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = cat(2, ConWeights.(['Sess_' int2str(1) '_Con4']), ConWeights.(['Sess_' int2str(2) '_Con4']), ConWeights.(['Sess_' int2str(3) '_Con4']), ConWeights.(['Sess_' int2str(4) '_Con4']));
    
    
    %     matlabbatch{4}.spm.stats.results.spmmat = cfg_dep('fMRI Results Report: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    %     matlabbatch{4}.spm.stats.results.conspec.titlestr = 'Dim 1 < Dim2-4';
    %     matlabbatch{4}.spm.stats.results.conspec.contrasts = 5;
    %     matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
    %     matlabbatch{4}.spm.stats.results.conspec.thresh = 0.05;
    %     matlabbatch{4}.spm.stats.results.conspec.extent = 20;
    %     matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
    %     matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
    %     matlabbatch{4}.spm.stats.results.units = 1;
    %     matlabbatch{4}.spm.stats.results.export{1}.pdf = true;
    
    save([pn.root, 'B_data/D_batchFiles1stLevelGLM-', OUTDIR,'-tardis/',IDs{indID},'_SPM1stBatchGLM.mat'], 'matlabbatch');
    
end % subject loop
