function IntegrateMotionParameters_wGLM_CatVers(MotionDir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
%   Call from directory of GLM files (pre 1st-level analysis)
%   Note, assuming structure of files based upon ExtractFeatMotion script

workingdirectory = pwd;
files = dir(fullfile(workingdirectory, '*GLM.mat'));

for s = 1:length(files)
    
    load(files(s,1).name);
    
    %Set up structure of non-onset information
    
    %Extract subject id
    
    subjid=files(s,1).name(1:4);
    
    %Add in motion regressors
    
    nruns=4;
    motrunall=[];
    
    for n=1:nruns
        
        motrun=[];
        motrun=dlmread([MotionDir '/' subjid '/' subjid '_sess-' int2str(n) '_motion_6dof.txt']);
        
        if n==1
            
            motrunall(1:length(motrun),:)=motrun;
            
        else
            
            motrunall((n-1)*length(motrun)+1:n*length(motrun),:)=motrun;
            
        end
        
        dlmwrite([MotionDir '/' subjid '/' subjid '_sesscat_motion_6dof.txt'], motrunall, 'delimiter', '\t');
        matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).multi_reg={[MotionDir '/' subjid '/' subjid '_sesscat_motion_6dof.txt']};
        
        %finished, now save
        
        save([files(s,1).name], 'matlabbatch');
        
    end
    
end
    
