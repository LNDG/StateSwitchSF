function PrepareGLMTardis
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


workingdirectory = pwd;
files = dir(fullfile(workingdirectory, '*GLM.mat'));

nruns=4;

for s = 1:length(files)
    
    subj = regexprep(files(s,1).name,'_.*','');
    
    %load matlab batch
    
    load(files(s,1).name);
    
    for n = 1:nruns
        
        %Directory
        
        matlabbatch{1, 1}.spm.stats.fmri_spec.dir={['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/SPMfiles/SPM/' subj]};
        
        
        %Scans
        
        basefile = ['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/Scans/' subj '/preproc/run-' int2str(n) '/' subj '_run-' int2str(n) '_feat_detrended_bandpassed_FIX_MNI3mm.nii'];
        basefileInfo = spm_vol(basefile);
        
        N = size(basefileInfo,1);
        allFiles = cell(1);
        for indVol = 1:N
            allFiles{indVol,1} = [basefile, ',', num2str(indVol)];
        end
        matlabbatch{1}.spm.stats.fmri_spec.sess(n).scans = allFiles;
        
        
        %Motion Parameters
        
        matlabbatch{1, 1}.spm.stats.fmri_spec.sess(n).multi_reg={['/home/mpib/perry/working/StateSwitch-Alistair/funct/SPM/MotionParameters/' subj '/' subj '_sess-' int2str(n) '_motion_6dof.txt']};
        
    end
    
    save([files(s,1).name], 'matlabbatch');
    
end

end

