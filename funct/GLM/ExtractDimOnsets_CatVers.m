function ExtractDimOnsets_CatVers(outputdir)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%cd /Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/D_batchFiles1stLevelGLM-fix

workingdirectory = pwd;
files = dir(fullfile(workingdirectory, '*GLM.mat'));

mkdir(outputdir);

for s = 1:length(files)
    
    load(files(s,1).name);
    
    matlabbatchold=matlabbatch;
    
    %Extract subject id
    
    subjid=files(s,1).name(1:4);
    
    %Set up structure of non-onset information such as output directory and
    %factors (lets indent for now)
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.dir{1,1}=['/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/B_data/A_SPMfiles/' subjid];
    
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.fact=struct;
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.fact.name='Load';
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.fact.levels=4;
    
    %First basic information
    
    %Specific to the condition
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond=[];
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(1).name='Dim1';
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(2).name='Dim2';
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(3).name='Dim3';
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4).name='Dim4';
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(1).duration=[4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4];
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(2).duration=[4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4];
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(3).duration=[4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4];
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4).duration=[4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4;4];
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(1).tmod=0;
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(2).tmod=0;
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(3).tmod=0;
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4).tmod=0;
    
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.sess(i).cond(1).pmod=struct;
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.sess(i).cond(2).pmod=struct;
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.sess(i).cond(3).pmod=struct;
    %     matlabbatch{1, 1}.spm.stats.fmri_spec.sess(i).cond(4).pmod=struct;
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(1).orth=0;
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(2).orth=0;
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(3).orth=0;
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4).orth=0;
    
    
    %now timing information
    
    dim1=unique(cat(1,matlabbatchold{1, 1}.spm.stats.fmri_spec.sess(1).cond(1:4).onset));
    
    %dim1=unique(cat(1,att1,att2,att3,att4));
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(1).onset=sort(dim1);
    
    
    dim2=unique(cat(1,matlabbatchold{1, 1}.spm.stats.fmri_spec.sess(1).cond(5:8).onset));
    
    %dim2=unique(cat(1,att1,att2,att3,att4));
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(2).onset=sort(dim2);
    
    
    dim3=unique(cat(1,matlabbatchold{1, 1}.spm.stats.fmri_spec.sess(1).cond(9:12).onset));
    
    %dim3=unique(cat(1,att1,att2,att3,att4));
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(3).onset=sort(dim3);
   
    
    dim4=unique(cat(1,matlabbatchold{1, 1}.spm.stats.fmri_spec.sess(1).cond(13:16).onset));
    
    %dim4=unique(cat(1,att1,att2,att3,att4));
    
    matlabbatch{1, 1}.spm.stats.fmri_spec.sess(1).cond(4).onset=sort(dim4);
    
    
    %Estimate model
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep('fMRI model specification: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    matlabbatch{2}.spm.stats.fmri_est.write_residuals = 0;
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    %Within-subject analyses
    
    %matlabbatch{3}.spm.stats.con = cfg_dep('Contrast Manager: SPM.mat File', substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1}), substruct('.','spmmat'));
    %matlabbatch{3}.spm.stats.con.consess{1}.fcon.name = 'Load';
    %matlabbatch{3}.spm.stats.con.consess{1}.fcon.weights = [1 1 1 1];
    %matlabbatch{3}.spm.stats.con.consess{1}.fcon.sessrep = 'repl';
    %matlabbatch{3}.spm.stats.con.delete = 1;
    
    
    save([outputdir '/' files(s,1).name], 'matlabbatch');
    
end

