function runGLMfirstlevel_compile(DATADIR, subj)

spm_get_defaults('cmdline',true)

load([DATADIR '/' subj '_SPM1stBatchGLM.mat'])
spm_jobman('run', matlabbatch)

clear matlabbatch;

end

