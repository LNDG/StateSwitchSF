%Create SPM experimental condition info for each subject for variability toolbox

% Here: stick-function (i.e. 1 event stimulus onset)
% Some things need to be considered for the variability toolbox:
% - duration always needs to be poitive (vs. SPM convention of 0 for stick)
% - 4D images have to be listed as individual 3D images with 4D index

% v3: create Dim-Att regressors, include cue onset, probe onset regressors
% use FAST modelinstead of AR(1): Corbin, N., Todd, N., Friston, K. J., & Callaghan, M. F. (2018). Accurate modeling of temporal correlations in rapidly sampled fMRI time series. Human Brain Mapping, 26(3), 839?14. http://doi.org/10.1002/hbm.24218
% - Note, AP change back for now
% v4: AP remove -1 from design timing

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
    matlabbatch{1}.spm.stats.fmri_spec.dir = {['/Volumes/LNDG/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/A_SPMfiles_Mixed_noAR/',IDs{indID}, '/']};
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'scans';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.645;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 8;
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'none';
    
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
        
        nBlockDims=4;
        for BlockDim = 1:nBlockDims
            BlockEnd=[];
            BlockDur=[];
            FirstBlockOnsets=[];         
            
            % find pseudo onsets of Blocks
            uniBlockOnsets=find(Regressors(:,4) == BlockDim);
            
            % now modify to make first trial onset as the start
            for BlockDimTemp = 1:2
                
                % find proceeding trial onsets after the block "starts"
                SubTrialOnsets=find(Regressors(uniBlockOnsets(BlockDimTemp)+1:length(Regressors(:,2)),2) == 1);
                
                % take first trial onset                
                FirstBlockOnsets(BlockDimTemp,1) = uniBlockOnsets(BlockDimTemp,1)+SubTrialOnsets(1,1);
                
                % lastly, find where the block ends
                if ~isempty(find(nnz(Regressors(FirstBlockOnsets(BlockDimTemp)+112,:))))                    
                   BlockEnd(BlockDimTemp,1) = FirstBlockOnsets(BlockDimTemp)+112+1;
                   BlockDur(BlockDimTemp,1) = 112+1+1;
                    
                else
                   BlockEnd(BlockDimTemp,1) = FirstBlockOnsets(BlockDimTemp)+113+1;
                   BlockDur(BlockDimTemp,1) = 113+1+1;
                    
                end                    
                    
            end
                
                matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(BlockDim).name = ['DimBlock' '_' int2str(BlockDim)];
                matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(BlockDim).onset = FirstBlockOnsets;
                matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(BlockDim).duration = BlockDur; 
                matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(BlockDim).tmod = 0;
                matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(BlockDim).pmod = struct('name', {}, 'param', {}, 'poly', {});
                matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).cond(BlockDim).orth = 0;   
            
        end
        
        % add general session information
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).regress = struct('name', {}, 'val', {});
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).multi_reg = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(indSession).hpf = 128;
        matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
        %matlabbatch{1}.spm.stats.fmri_spec.bases.none = true;
        matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
        matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
        matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
        matlabbatch{1}.spm.stats.fmri_spec.mthresh = -Inf;
        matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
        matlabbatch{1}.spm.stats.fmri_spec.cvi = 'none';
        
    end % session loop (i.e. runs)
    
    %Estimate Model
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    %Now contrasts: Simple Block Load Effect (for now)
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep('fMRI Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));

    %% with no HRF, or no derivatives

    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Dim 1';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
    
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Dim 2';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 1 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';

    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Dim 3';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 1 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
    
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Dim 4';
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 1 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
    
    %% with time HRF derivative
    
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'Dim 1';
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.weights = [1 1 0 0 0 0 0 0 0 0 0 0 0 0];
%     matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'replsc';
%     
%     matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'Dim 2';
%     matlabbatch{3}.spm.stats.con.consess{2}.tcon.weights = [0 0 1 1 0 0 0 0 0 0 0 0 0 0];
%     matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'replsc';
% 
%     matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'Dim 3';
%     matlabbatch{3}.spm.stats.con.consess{3}.tcon.weights = [0 0 0 0 1 1 0 0 0 0 0 0 0 0];
%     matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'replsc';
%     
%     matlabbatch{3}.spm.stats.con.consess{4}.tcon.name = 'Dim 4';
%     matlabbatch{3}.spm.stats.con.consess{4}.tcon.weights = [0 0 0 0 0 0 1 1 0 0 0 0 0 0];
%     matlabbatch{3}.spm.stats.con.consess{4}.tcon.sessrep = 'replsc';
    
    %matlabbatch{3}.spm.stats.con.consess{5}.fcon.name = 'Load F-Test';
    %matlabbatch{3}.spm.stats.con.consess{5}.fcon.weights = [1 0 0 0 0 0 0 0 0 0
                                                        %0 1 0 0 0 0 0 0 0 0
                                                        %0 0 1 0 0 0 0 0 0 0
                                                        %0 0 0 1 0 0 0 0 0 0];
    %matlabbatch{3}.spm.stats.con.consess{5}.fcon.sessrep = 'replsc';
    %matlabbatch{3}.spm.stats.con.delete = 0;
    
    %% Single subject activations - with no HRF, or no derivatives
    
    %matlabbatch{3}.spm.stats.con.spmmat = cfg_dep('fMRI Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Dim 1 < Dim2-4';
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-3 1 1 1 0 0 0 0 0 0];
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
%     matlabbatch{3}.spm.stats.con.delete = 0;
    
    %% Single subject activations - w time HRF
    
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.name = 'Dim 1 < Dim2-4';
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.weights = [-3 -3 1 1 1 1 1 1 0 0 0 0 0 0];
%     matlabbatch{3}.spm.stats.con.consess{5}.tcon.sessrep = 'replsc';
%     matlabbatch{3}.spm.stats.con.delete = 0;
    
    %% Results report
    
    %% take out now due to crummy SPM version
%     
%     matlabbatch{4}.spm.stats.results.spmmat = cfg_dep('fMRI Results Report: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
%     matlabbatch{4}.spm.stats.results.conspec.titlestr = 'Dim 1 < Dim 2-4';
%     matlabbatch{4}.spm.stats.results.conspec.contrasts = 5;
%     matlabbatch{4}.spm.stats.results.conspec.threshdesc = 'FWE';
%     matlabbatch{4}.spm.stats.results.conspec.thresh = 0.05;
%     matlabbatch{4}.spm.stats.results.conspec.extent = 20;
%     matlabbatch{4}.spm.stats.results.conspec.conjunction = 1;
%     matlabbatch{4}.spm.stats.results.conspec.mask.none = 1;
%     matlabbatch{4}.spm.stats.results.units = 1;
%     matlabbatch{4}.spm.stats.results.export{1}.pdf = true;
    
    save([pn.root, 'B_data/D_batchFiles1stLevelGLM-Mixed_noAR/',IDs{indID},'_SPM1stBatchGLM.mat'], 'matlabbatch')
    
end % subject loop
