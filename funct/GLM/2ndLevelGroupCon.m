% List of open inputs
% Factorial design specification: Scans - cfg_files
% Factorial design specification: Scans - cfg_files
nrun = X; % enter the number of runs here
jobfile = {'/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/G_GLM/A_scripts/2ndLevelGroupCon_job.m'};
jobs = repmat(jobfile, 1, nrun);
inputs = cell(2, nrun);
for crun = 1:nrun
    inputs{1, crun} = MATLAB_CODE_TO_FILL_INPUT; % Factorial design specification: Scans - cfg_files
    inputs{2, crun} = MATLAB_CODE_TO_FILL_INPUT; % Factorial design specification: Scans - cfg_files
end
spm('defaults', 'FMRI');
spm_jobman('run', jobs, inputs{:});
