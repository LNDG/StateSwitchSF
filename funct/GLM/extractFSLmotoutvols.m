function extractFSLmotoutvols(DATADIR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

workingdirectory = DATADIR;
files = dir(workingdirectory);
dirFlags=[files.isdir];
subFolders=files(dirFlags);
subFolders(1:2)=[];

nruns=4;

for s = 1:length(subFolders)
    currentSubj= subFolders(s,1).name;
    currentSubjDir = char([workingdirectory '/' currentSubj]);
    
    motrowbinall=[];
    
    for i = 1:nruns
        
        currentSubjRunDir=[currentSubjDir '/' 'preproc' '/' 'run-' int2str(i)];
        
        if (exist([currentSubjRunDir '/' 'motionout' '/' currentSubj '_motionout.txt']))
            
            %Read in motion file
            motfile=dlmread([currentSubjRunDir '/' 'motionout' '/' currentSubj '_motionout.txt']);
            
            %Identify motion outlier volumes
            rowsum=sum(motfile,2);
            
            %Ensure max value is one within column
            motrowbin=rowsum;
            motrowbin(rowsum~=0)=1;
            
            motrowbinall=cat(1,motrowbinall,motrowbin);
            
            %Write out column
            dlmwrite([currentSubjRunDir '/' 'motionout' '/' currentSubj '_motionout_scol.txt'], motrowbin, 'delimiter', '\t');
            
        end
        
            dlmwrite([currentSubjDir '/' 'preproc' '/' currentSubj '_motionout_scol_all.txt'], motrowbinall, 'delimiter', '\t');
        
    end
    
end

end