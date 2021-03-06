function SpecifyIndividualDCM_pebmodel(OUTBATCHDIR, ,VOInames, SPMDATADIR, OUTDIR)

%% Setup

BASEDIR = '/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/D_DCM';
OUTDIR = [BASEDIR, 'A_Scripts/batchFilesDCMpebmodel-', OUTBATCHDIR,'-tardis'];
mkdir(OUTDIR);

% N = 44 YA + 53 OA;
% AP remove 2131, 2237, 1215 (see oNe Note)
% These will need to match those from second-level GLM

yID = {'1117';'1118';'1120';'1124';'1125';'1131';'1132';'1135';'1136';'1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1216';'1219';'1223';'1228';'1233';'1234';'1237';'1239';'1240';'1243';'1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281'};
oID = {'2104';'2107';'2108';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2133';'2132';'2134';'2135';'2140';'2145';'2147';'2149';'2157';'2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';'2215';'2216';'2219';'2222';'2224';'2226';'2238';'2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

%concatentate all IDs

allIDs=cat(1,yID,oID);

for indID = 1:numel(allIDs)
    
    disp(['Processing ', allIDs{indID}]);
 
%% Load regions of interest
%--------------------------------------------------------------------------

nVOIs=length(VOInames);

for roi = 1:length(nVOIs)

load(fullfile([SPMDATADIR '/' indID '/' 'VOI_' VOInames(roi) '_1.mat']),'xY');
DCM.xY(roi) = xY;

end

DCM.n = length(DCM.xY);      % number of regions
DCM.v = length(DCM.xY(1).u); % number of time points

%% Time series
%--------------------------------------------------------------------------
DCM.Y.dt  = SPM.xY.RT;
DCM.Y.X0  = DCM.xY(1).X0;
for i = 1:DCM.n
    DCM.Y.y(:,i)  = DCM.xY(i).u;
    DCM.Y.name{i} = DCM.xY(i).name;
end

DCM.Y.Q    = spm_Ce(ones(1,DCM.n)*DCM.v);

%% Experimental inputs
%--------------------------------------------------------------------------
DCM.U.dt   =  SPM.Sess.U(1).dt;
DCM.U.name = [SPM.Sess.U.name];
DCM.U.u    = [SPM.Sess.U(1).u(33:end,1) ...
              SPM.Sess.U(1).u(33:end,2)];

%% DCM parameters and options
%--------------------------------------------------------------------------
DCM.delays = repmat(SPM.xY.RT/2,DCM.n,1);
DCM.TE     = 0.04;

DCM.options.nonlinear  = 0;
DCM.options.two_state  = 0;
DCM.options.stochastic = 0;
%DCM.options.nograph    = 1; - dosen't appear to be evident in latest SPM
%DCM version
DCM.options.centre     = 0;

%% Set up DCM A,B,C matrices
%-------------------------------------------------------------------------
DCM.a = ones(nVOIs, nVOIs);
DCM.b = zeros(nVOIs, nVOIs, 2);
DCM.c = zeros(nVOIs, 2);
DCM.d = zeros(nVOIs,nVOIs,0);

%% Connectivity matrices - set up full model now
%--------------------------------------------------------------------------

DCM.b(:,:,1) = 1; % need to change later for VOI V1 input
DCM.b(:,:,2) = 1; 
DCM.c = [1 0 0; 0 0 0; 0 0 0]; % need to change later for PM input

save([OUTDIR, '/', allIDs{indID}, '_DCMpebm.mat'], 'DCM');

%% DCM Estimation
%--------------------------------------------------------------------------
clear matlabbatch

matlabbatch{1}.spm.dcm.fmri.estimate.dcmmat = {...
    [OUTDIR, '/', allIDs{indID}, '_DCMpebm.mat']}; %looks like I'm going to have to rsync the batch and DCM files across individually

save([OUTDIR, '/', allIDs{indID}, '_batchDCMpebm.mat'], 'matlabbatch');

end

end