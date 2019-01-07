function SpecifyIndividualRegressorMats_4tardis_woutmot_ICBM_PM_wconcat(OUTDIR)

% Create SPM experimental condition info for each subject for later
% batching with tardis

% v3: create Dim-Att regressors, include cue onset, probe onset regressors
% use FAST modelinstead of AR(1): Corbin, N., Todd, N., Friston, K. J., & Callaghan, M. F. (2018). Accurate modeling of temporal correlations in rapidly sampled fMRI time series. Human Brain Mapping, 26(3), 839?14. http://doi.org/10.1002/hbm.24218
% - AP to change back
% v4: AP remove -1 from design timing, but add durations to cue (1 volume) and
% probe (2).
% v5: Concatenate runs

% N = 44 YA + 53 OA;
% AP remove 2131, 2237 (see oNe Note)

IDs = {'1117';'1118';'1120';'1124';'1125';'1126';'1131';'1132';'1135';'1136';...
    '1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1215';...
    '1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';...
    '1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281';...
    '2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';...
    '2132';'2133';'2134';'2135';'2139';'2140';'2145';'2147';'2149';'2157';...
    '2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';...
    '2215';'2216';'2217';'2219';'2222';'2224';'2226';'2227';'2236';'2238';...
    '2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

%Path to Base Dir of local output
pn.root = '/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/';
mkdir([pn.root, 'B_data/D_batchFiles1stLevelGLM-', OUTDIR,'-tardis/']);

disp(['Creating files in ', [pn.root, 'B_data/D_batchFiles1stLevelGLM-', OUTDIR,'-tardis/']]);

%addpath([pn.root, 'T_tools/spm12/']); % add spm functions

for indID = 1:numel(IDs)
    
    disp(['Processing ', IDs{indID}]);
    
    matlabbatch = cell(1);
    
    % specify general parameters
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {['/home/beegfs/perry/working/StateSwitch-Alistair/funct/SPM/SPMfiles/SPM_' OUTDIR '/' IDs{indID} '/']};
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
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    % For the scans, we need to specify separate 3D images via comma seperator
    numOfRuns = 4;
    
    currvol=0;
    allFiles={};
    RegressorsAll=[];
    
    PMDimDur=[];
    PMDimOnsets=[];
    PM=[];
    
    for indSession = 1:numOfRuns
        
        basefile = ['/home/beegfs/perry/working/StateSwitch-Alistair/funct/SPM/Scans_ICBM/',IDs{indID},'/preproc/run-',num2str(indSession),'/',IDs{indID},'_run-',num2str(indSession),'_feat_detrended_bandpassed_FIX_2009c3mm.nii'];
        if strcmp(IDs{indID}, '2132') && indSession == 2
            disp(['Change #volumes for run2']);
            for indVol = 1:1040
                currvol=currvol+1;
                allFiles{currvol,1} = [basefile, ',', num2str(indVol)];                
            end
        else
            for indVol = 1:1054
                currvol=currvol+1;
                allFiles{currvol,1} = [basefile, ',', num2str(indVol)];
            end
        end       
        
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
        
        RegressorsAll=cat(1, RegressorsAll, Regressors);
        
    end
    
    % Add in scan information
    matlabbatch{1}.spm.stats.fmri_spec.sess.scans = allFiles;
    
    % stimulus viewing condition
    for indDim = 1:4
        
        DimOnsets = find(RegressorsAll(:,3) == 1 & RegressorsAll(:,4) == indDim);
        
        PMDimDur=cat(1,PMDimDur,repmat(4, numel(DimOnsets), 1));
        PMDimOnsets=cat(1,PMDimOnsets,DimOnsets);
        
        PM=cat(1,PM,repmat(indDim, numel(DimOnsets), 1));
        
    end
    
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).name = 'StimOnset';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).onset = PMDimOnsets;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).duration = PMDimDur;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod.name = 'Stim Load';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod.param = PM;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).pmod.poly = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(1).orth = 1;
    
    
    % add cue regressor
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).name = 'CueOnset';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset = find(RegressorsAll(:,2) == 1); % IMPORTANT: SPM starts counting at 0
    onsets = matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).onset;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).duration = repmat(3, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(2).orth = 0;
    
    
    % add probe regressor
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).name = 'ProbeOnset';
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset = find(RegressorsAll(:,11) == 1); % IMPORTANT: SPM starts counting at 0
    onsets = matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).onset;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).duration = repmat(2, numel(onsets), 1); clear onsets; % duration of 1 (VarToolbox) vs 0 (SPM convention)
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.cond(3).orth = 0;
    
    %% add regressors
    
    MotConfoundFile=['/home/beegfs/perry/working/StateSwitch-Alistair/funct/SPM/MotionParameters/' IDs{indID} '/' IDs{indID} '_motionout_scol_all.txt'];
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi_reg={MotConfoundFile
        ['/home/beegfs/perry/working/StateSwitch-Alistair/funct/SPM/MotionParameters/' IDs{indID} '/' IDs{indID} '_motion_6dof_all.txt']};
    
    
    %% add general session information
    matlabbatch{1}.spm.stats.fmri_spec.sess.multi = {''};
    matlabbatch{1}.spm.stats.fmri_spec.sess.regress = struct('name', {}, 'val', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess.hpf = 128;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [1 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {'/home/beegfs/perry/working/StateSwitch-Alistair/funct/SPM/Standards/mni_icbm152_gm_tal_nlin_sym_09c_thr025.nii'};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    %% concatenate sessions
    
    matlabbatch{2}.cfg_basicio.run_ops.call_matlab.inputs{1}.anyfile = {['/home/beegfs/perry/working/StateSwitch-Alistair/funct/SPM/SPMfiles/SPM_' OUTDIR '/' IDs{indID} '/' 'SPM.mat']};
    
    if strcmp(IDs{indID}, '2132')
        
        matlabbatch{2}.cfg_basicio.run_ops.call_matlab.inputs{2}.evaluated = [1054 1040 1054 1054];
        
    else
        
        matlabbatch{2}.cfg_basicio.run_ops.call_matlab.inputs{2}.evaluated = [1054 1054 1054 1054];
        
    end
    
    matlabbatch{2}.cfg_basicio.run_ops.call_matlab.outputs = {};
    matlabbatch{2}.cfg_basicio.run_ops.call_matlab.fun = 'spm_fmri_concatenate';
    
    %% Estimate Model
    
    matlabbatch{3}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{3}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{3}.spm.stats.fmri_est.method.Classical = 1;
    
    
    %% Now contrasts: Simple Contrast Effects (for now)
    matlabbatch{4}.spm.stats.con.spmmat(1) = cfg_dep('fMRI Model Estimation: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    
    matlabbatch{4}.spm.stats.con.consess{1}.tcon.name = 'Stimulus Condition';
    matlabbatch{4}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0];
    
    matlabbatch{4}.spm.stats.con.consess{2}.tcon.name = 'Load PM 1';
    matlabbatch{4}.spm.stats.con.consess{2}.tcon.weights = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0];
    
    %Sensory and load effects - for extracting DCM time series
    
    matlabbatch{4}.spm.stats.con.consess{3}.fcon.name = 'Stimulus and Load PM 1 F';
    matlabbatch{4}.spm.stats.con.consess{3}.fcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 1 0 0 0 0 0 0 0 0 0 0 0 0];
    
    matlabbatch{4}.spm.stats.con.consess{4}.fcon.name = 'Stimulus and Load PM 1 F - w time derivs';
    matlabbatch{4}.spm.stats.con.consess{4}.fcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 1 0 0 0 0 0 0 0 0 0 0 0];
    
    %F-statistic - all effects, again for extracting time series
    
    matlabbatch{4}.spm.stats.con.consess{5}.fcon.name = 'All effects F';
    matlabbatch{4}.spm.stats.con.consess{5}.fcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 0];
    
    matlabbatch{4}.spm.stats.con.consess{6}.fcon.name = 'All effects F - w time derivs';
    matlabbatch{4}.spm.stats.con.consess{6}.fcon.weights = [1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 1 0 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 1 0 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 1 0 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 1 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 1 0 0 0 0 0 0 0];
    
    %% Brief subject results - PM
    
    matlabbatch{5}.spm.stats.results.spmmat = cfg_dep('fMRI Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{5}.spm.stats.results.conspec.titlestr = 'Load PM';
    matlabbatch{5}.spm.stats.results.conspec.contrasts = 2;
    matlabbatch{5}.spm.stats.results.conspec.threshdesc = 'none';
    matlabbatch{5}.spm.stats.results.conspec.thresh = 0.05;
    matlabbatch{5}.spm.stats.results.conspec.extent = 20;
    matlabbatch{5}.spm.stats.results.conspec.conjunction = 1;
    matlabbatch{5}.spm.stats.results.conspec.mask.none = 1;
    matlabbatch{5}.spm.stats.results.units = 1;
    matlabbatch{5}.spm.stats.results.export{1}.pdf = true;
    
    save([pn.root, 'B_data/D_batchFiles1stLevelGLM-', OUTDIR,'-tardis/',IDs{indID},'_SPM1stBatchGLM.mat'], 'matlabbatch');
    
end % subject loop

end % finish completely