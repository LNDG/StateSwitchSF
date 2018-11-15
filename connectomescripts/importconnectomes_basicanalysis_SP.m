function importconnectomes_basicanalysis_SP(parcnum, thr, sparsity, varargin)
%Import raw connectomes and basic network analyses
%Using new functions available within latest MRtrix package
%Copied from Alistair Perry, UNSW (2014)
%Adapted by Sarah Polk, MPIB (2018)

%% Calling the function

%Input arguments:
%parcnum = Number of parcellation regions
%thr = [0 or 1]: 0, no thresholding; 1, threshold matrices
%sparsity = Threshold level - for e.g. 10 for 0.10 percent

%Optional arguments:
%varagin = normtype - if empty, by default will use the non-normalized
%matrices for further analyses
  
    % Options: 
        %ORGinv (normalized by track length), 
        %ORGinvnodelength (normalized by both track length and node vol)

%N.B: Must call function from directory containing subject folders 

%Dependencies:
%Brain Connectivity Toolbox - https://sites.google.com/site/bctnet/ 
%Community Algorithm Toolbox - https://github.com/CarloNicolini/communityalg
    %For communicability calculations only

%% Batch Setup

cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_data/connectomes

% Find subject folders in the working directory
workingdirectory = pwd;
files = dir(workingdirectory);
dirFlags=[files.isdir];
subFolders=files(dirFlags);
subFolders(1:2)=[];

%% Run loop

for s = 1:length(subFolders)
    
    % Extract current subject informatiom    
    currentSubj= subFolders(s,1).name;
    currentSubjDir = char([workingdirectory '/' currentSubj]);

    % Setup output directory
    
    outdirname=int2str(sparsity);
    mkdir([currentSubjDir '/' outdirname]);

% Catch whether to perform thresolding of matrix    
    if thr==1
    
        %Pick up raw matrices stored as .csv files

        %Unfiltered track weights
    countfile = dir(fullfile(currentSubjDir, '*streamweights*'));
    countmtx = dlmread([currentSubjDir '/' countfile.name]);

        %Normalized by fiber length
    invcountfile = dir(fullfile(currentSubjDir, '*invlengthweights*'));
    invcountmtx = dlmread([currentSubjDir '/' invcountfile.name]);
 
        %Normalized by  node volume
    invnodelengthfile = dir(fullfile(currentSubjDir, '*invnodeweights*'));
    invnodelengthmtx = dlmread([currentSubjDir '/' invnodelengthfile.name]);
  
        %Remove for now
    %lengthfile = dir(fullfile(currentSubjDir, '*tracklengths*'));
    %lengthmtx = dlmread([currentSubjDir '/' lengthfile.name], '%f', 0, 0, [0 0 (parcnum-1) (parcnum-1)]);
    
    %parcload = load_untouch_nii([commondir '/' currentSubj '/' parcname '.nii']); 
    
 % Symmetrize matrices 
    for i = 1:parcnum
        for j = i+1:parcnum
            if i == parcnum break; end
        countmtx(j,i) = countmtx(i,j);
        %lengthmtx(j,i) = lengthmtx(i,j);
        invcountmtx(j,i)=invcountmtx(i,j);
        invnodelengthmtx(j,i)=invnodelengthmtx(i,j);
        end
    end
    
 % Setup subject structure    
    SubjStruct=struct;
    
 % Load in the raw matrices   
    SubjStruct.ORG=countmtx;
    SubjStruct.ORGinv=invcountmtx;
    SubjStruct.ORGinvnodelength=invnodelengthmtx;
    %SubjStruct.tckdistmat=lengthmtx;
    
    %BrainMask = load_untouch_nii([currentSubjDir '/' 'biasb0brain_mask.nii']);
    %SubjStruct.BrainSize = numel(find(BrainMask.img~=0));
 
 % Threshold the networks to desired sparsity    
        if ~isempty(varargin)
        %catches the chosen normalization of the connectomes

            normtype=varargin{1};   
    
            SubjStruct.thr = threshold_proportional(SubjStruct.(normtype), (sparsity./100));
        
        else
        %this assumes that you intend to process the non-normalized connectomes
        
            SubjStruct.thr = threshold_proportional(SubjStruct.ORG, (sparsity./100));
    
        end
    
 % Binarize   
    SubjStruct.CIJ = weight_conversion(SubjStruct.thr, 'binarize');   
    
 % Save matrices so network computations can follow independently at later stages
    save([currentSubjDir '/' outdirname '/' currentSubj  '' 'metrics.mat'], 'SubjStruct');
   
    end

%% Network computations start here
% Can skip the thresholding steps, if already performed.

    load([currentSubjDir '/' outdirname '/' currentSubj  '' 'metrics.mat']);
    
% Number of fibers within matrix    
    SubjStruct.numfibers = sum(sum(SubjStruct.ORG));

%Basic nodal connectivity calculatins
    SubjStruct.DEG  = degrees_und(SubjStruct.CIJ);
    SubjStruct.STR  = strengths_und(SubjStruct.thr);
    SubjStruct.BETC = betweenness_bin(SubjStruct.thr);

%Local efficiency
    SubjStruct.NodalEff = efficiency_bin(SubjStruct.CIJ,1);
    SubjStruct.NodalEff(isinf(SubjStruct.NodalEff))=0;

%Global Efficiency
    CIJd           = distance_bin(SubjStruct.CIJ);
    SubjStruct.CPL = charpath(CIJd,0,0);
    SubjStruct.EFF = efficiency_bin(SubjStruct.CIJ);
    
%Clustering
    SubjStruct.CCOEFF    = clustering_coef_bu(SubjStruct.CIJ);
    SubjStruct.avgCCOEFF = mean(SubjStruct.CCOEFF);
    
%Communicability
    COMM = communicability_wu(SubjStruct.CIJ);
    SubjStruct.TCOMM = sum(sum(triu(COMM)));
    
fprintf('\n %s completed \n' , currentSubj);

%Save output
    save([currentSubjDir '/' outdirname '/' currentSubj '' 'metrics.mat'], 'SubjStruct'); 
     
end

end
