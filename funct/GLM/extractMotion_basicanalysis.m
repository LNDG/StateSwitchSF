function [MotionOut] = extractMotion_basicanalysis(varargin)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

workingdirectory = pwd;
files = dir(workingdirectory);
dirFlags=[files.isdir];
subFolders=files(dirFlags);
subFolders(1:2)=[];

%setup output files
MotionOut=struct;

for s = 1:length(subFolders)
    currentSubj= subFolders(s,1).name;
    MotionOut.allsubjs(s,1)=str2double(currentSubj);
    
    currentSubjDir = char([workingdirectory '/' currentSubj]);
    
    subjMot=dlmread([currentSubjDir '/' currentSubj '_avgsess_FD_abs.txt']);
    MotionOut.allFD(s,1)=subjMot; 

end

    weightscell=MotionOut.allFD;
    
    figure(1),plotSpread_incmarkersz(weightscell,'distributionColors',{'k'})
    
    MotionOut.meanFD=mean(MotionOut.allFD);
    MotionOut.stdFD=std(MotionOut.allFD);
    
    outlierthr=MotionOut.stdFD*3;     
    MotionOut.outliers=find(abs(MotionOut.allFD-MotionOut.meanFD)>outlierthr);
    MotionOut.outlierIDs=subFolders(MotionOut.outliers).name;
    
if (~isempty(varargin))
        
    grp1ids=varargin{1};
    grp2ids=varargin{2};
    
    grp1ids=str2double(grp1ids);
    grp2ids=str2double(grp2ids);
    
    grp1ind=ismember(MotionOut.allsubjs,grp1ids);
    grp2ind=ismember(MotionOut.allsubjs,grp2ids);
    
    MotionOut.grpanalysis.grp1FD=MotionOut.allFD(grp1ind);
    MotionOut.grpanalysis.grp2FD=MotionOut.allFD(grp2ind);
    
    MotionOut.grpanalysis.grpmeanFD(1,1)=mean(MotionOut.grpanalysis.grp1FD);
    MotionOut.grpanalysis.grpmeanFD(1,2)=mean(MotionOut.grpanalysis.grp2FD);
    
    MotionOut.grpanalysis.grpstdFD(1,1)=std(MotionOut.grpanalysis.grp1FD);
    MotionOut.grpanalysis.grpstdFD(1,2)=std(MotionOut.grpanalysis.grp2FD);
    
    weightscell={MotionOut.grpanalysis.grp1FD,MotionOut.grpanalysis.grp2FD};
    
    figure(2),plotSpread_incmarkersz(weightscell,'distributionColors',{'k','r'})
    
    %Viz improvement
    
    set(gca,'XTick',[1 2])
    set(gca,'box','off')
    
    ylabel('mean FD across sessions', 'FontSize', 14, 'FontWeight', 'Bold', 'Color', 'black')
    xlabel('Group', 'FontSize', 14, 'FontWeight', 'Bold', 'Color', 'black')
        
    ax=gca;
    ax.YColor = 'black';
    ax.XColor = 'black';
    ax.FontWeight = 'bold';
    ax.FontSize = 12;
    
    %now stats

    [~,MotionOut.grpanalysis.p,~,MotionOut.grpanalysis.stats] = ttest2(MotionOut.grpanalysis.grp1FD,MotionOut.grpanalysis.grp2FD);
    
    %now identify group outliers
    
    %grp1
    
    grpoutlierthr=MotionOut.grpanalysis.grpstdFD(1,1)*3;     
    MotionOut.grpanalysis.grp1outliers=find(abs(MotionOut.grpanalysis.grp1FD-MotionOut.grpanalysis.grpmeanFD(1,1))>grpoutlierthr);
    MotionOut.grpanalysis.grp1outlierIDs=grp1ids(MotionOut.grpanalysis.grp1outliers);
    
    grpoutlierthr=MotionOut.grpanalysis.grpstdFD(1,2)*3;     
    MotionOut.grpanalysis.grp2outliers=find(abs(MotionOut.grpanalysis.grp2FD-MotionOut.grpanalysis.grpmeanFD(1,2))>grpoutlierthr);
    MotionOut.grpanalysis.grp2outlierIDs=grp2ids(MotionOut.grpanalysis.grp2outliers);
    
end

%save output 

dlmwrite('allsubjsFD.dat', cat(2,MotionOut.allsubjs, MotionOut.allFD), 'delimiter', '\t');
save('MotionInfo.mat', 'MotionOut');

end



