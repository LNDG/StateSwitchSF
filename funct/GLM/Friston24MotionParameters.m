function Friston24MotionParameters(DATADIR)

workingdirectory = DATADIR;
files = dir(workingdirectory);
dirFlags=[files.isdir];
subFolders=files(dirFlags);
subFolders(1:2)=[];

nruns=4;

for s = 1:length(subFolders)
    currentSubj= subFolders(s,1).name;
    currentSubjDir = char([workingdirectory '/' currentSubj]);
    
    fmotprmsall=[];
    
    for i = 1:nruns
        
        fmotprms=[];
        
        if (exist([currentSubjDir '/'  currentSubj '_sess-' int2str(i) '_motion_6dof.txt']))
            
            motprms = dlmread([currentSubjDir '/'  currentSubj '_sess-' int2str(i) '_motion_6dof.txt']);
            fmotprms = motprms;
            
            fmotprms(1,13:18) = fmotprms(1,1:6).^2;
            
            nvols=length(fmotprms(:,1));
            for cvol = 2:nvols
                
                fmotprms(cvol,7:12)=fmotprms(cvol-1,1:6);
                fmotprms(cvol,13:24)=fmotprms(cvol,1:12).^2;
                
            end
            
            dlmwrite([currentSubjDir '/' currentSubj '_sess-' int2str(i) '_motion_24dof.txt'], fmotprms, 'delimiter', '\t');
            
            fmotprmsall=cat(1, fmotprmsall, fmotprms);
            
        end
        
    end % finish run loop
    
    dlmwrite([currentSubjDir '/' currentSubj '_motion_24dof_all.txt'], fmotprmsall, 'delimiter', '\t');
    
end % end subject loop

end