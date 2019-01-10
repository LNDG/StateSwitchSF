function SpecifyIndividualDCM_voi(DATADIR, OUTBATCHDIR, sigclustcoords, sigclustnames)

% Extract eigenvariate timeseries of significant clusters (from second-level GLM) for
% batching with tardis

BASEDIR = '/Volumes/lndg/Projects/StateSwitch/dynamic/data/mri/task/analyses/9_Alistair/D_DCM/';
OUTDIR = [BASEDIR, 'A_Scripts/batchFilesDCMvoi-', OUTBATCHDIR,'-tardis'];
mkdir(OUTDIR);

% N = 44 YA + 53 OA;
% AP remove 2131, 2237, 1215 (see oNe Note)
% These will need to match those from second-level GLM

yID = {'1117';'1118';'1120';'1124';'1125';'1131';'1132';'1135';'1136';'1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1216';'1219';'1223';'1228';'1233';'1234';'1237';'1239';'1240';'1243';'1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281'};
oID = {'2104';'2107';'2108';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2133';'2132';'2134';'2135';'2140';'2145';'2147';'2149';'2157';'2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';'2215';'2216';'2219';'2222';'2224';'2226';'2238';'2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

%concatentate all IDs

allIDs=cat(1,yID,oID);

%Extract cluster information into cell structure
sigclustcoords=dlmread(sigclustcoords);

nclusts=length(sigclustcoords(:,1));
roicoords=cell(1,nclusts);

for i = 1:length(sigclustcoords)
    roicoords{i}=sigclustcoords(i,:);
end

disp(['Creating files in ', OUTDIR]);

for indID = 1:numel(allIDs)
    
    disp(['Processing ', allIDs{indID}]);
    
    matlabbatch = cell(1);
    
    for iRoi = 1:nclusts
        
        matlabbatch{iRoi}.spm.util.voi.spmmat = {[DATADIR '/' allIDs{indID} '/SPM.mat']};
        % adjust for effects of interest: Try second contrast for now..
        matlabbatch{iRoi}.spm.util.voi.adjust = 6; %add in F contrast
        matlabbatch{iRoi}.spm.util.voi.session = 1;
        matlabbatch{iRoi}.spm.util.voi.name = sigclustnames{iRoi};
        matlabbatch{iRoi}.spm.util.voi.roi{1}.sphere.centre = roicoords{iRoi};
        matlabbatch{iRoi}.spm.util.voi.roi{1}.sphere.radius = 6;
        matlabbatch{iRoi}.spm.util.voi.roi{1}.sphere.move.fixed = 1;
        
        % add in threshold mask - circumvent spheres overlaying on
        % WM
        matlabbatch{iRoi}.spm.util.voi.roi{2}.mask.image = cellstr(fullfile(DATADIR, allIDs{indID},'mask.nii'));
        matlabbatch{iRoi}.spm.util.voi.roi{2}.mask.threshold = 0.5;
        
        matlabbatch{iRoi}.spm.util.voi.expression = 'i1 & i2';
        
    end
    
    save([OUTDIR, '/', allIDs{indID}, '_batchDCMvoi.mat'], 'matlabbatch');
    
end %subject loop

end % finish completely
