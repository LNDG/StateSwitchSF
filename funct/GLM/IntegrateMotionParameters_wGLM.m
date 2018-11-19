function IntegrateMotionParameters_wGLM(MotionDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Call from directory of GLM files (pre 1st-level analysis)
%   Note, assuming structure of files based upon ExtractFeatMotion script

workingdirectory = pwd;
files = dir(fullfile(workingdirectory, '*GLM.mat'));

for s = 1:length(files)

    load(files(s,1).name);
    
    matlabbatchold=matlabbatch;
    
    nruns=4;
    
    %Set up structure of non-onset information
    
    for i=1:nruns
        
    %Extract subject id
    
    subjid=files(s,1).name(1:4);

    %Add in motion regressors
    
    sessmotfname=[subjid '_sess-' int2str(i) '_motion_6dof.txt'];
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(i).multi_reg={[MotionDir '/' subjid '/' sessmotfname]};
    
    %finished, now save
    
    save([files(s,1).name], 'matlabbatch');
    
    end

end

