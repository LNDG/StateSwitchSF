function betabehaviourcorrs
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Note AP removed 2131, 2237, 1215 (see one note)
%JK remove 2139, 2227 - anatomical abnormalities
%plus 2112, 2217, 2236 - poor baseline performers 

%potentially 1126, 1227 - no DWI

nclusters=9;

yID = {'1117';'1118';'1120';'1124';'1125';'1131';'1132';'1135';'1136';'1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1216';'1219';'1223';'1228';'1233';'1234';'1237';'1239';'1240';'1243';'1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281'};
oID = {'2104';'2107';'2108';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2133';'2132';'2134';'2135';'2140';'2145';'2147';'2149';'2157';'2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';'2215';'2216';'2219';'2222';'2224';'2226';'2238';'2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};
allIDs=cat(1,yID,oID);
load('/Volumes/lndg/Projects/StateSwitch/dynamic/data/behavior/STSW_dynamic/A_MergeIndividualData/B_data/SummaryData_N102.mat')
corrIDs=ismember(str2double(IDs_all),str2double(allIDs));

%extract relevant data points, and collapse across the stim attributes
RTs_ext=SummaryData.MRI.RTs_mean(corrIDs,:,:);
for i=1:4
RTs_dimmean(:,i)=mean(RTs_ext(:,:,i),2);
end
Acc_ext=SummaryData.MRI.Acc_mean(corrIDs,:,:);
for i=1:4
Acc_dimmean(:,i)=mean(Acc_ext(:,:,i),2);
end

nsubjs=length(allIDs);

%loop through scatter plots - combined and young old separately
%combined

%Baseline

for j = 1:nclusters
    
    %Accuracy baseline
    
    figure(2),subplot(3,3,j)
    
    hold on
    
    plot(SPM.marsY.Y(1:length(yID),j),Acc_dimmean(1:length(yID),1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),Acc_dimmean(length(yID)+1:nsubjs,1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')

    
    %young only
    
    figure(3),subplot(3,3,j)

    plot(SPM.marsY.Y(1:length(yID),j),Acc_dimmean(1:length(yID),1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    
    %old only
    
    figure(4),subplot(3,3,j)

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),Acc_dimmean(length(yID)+1:nsubjs,1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')


end

for j = 1:nclusters
    
    %RT baseline
    
    figure(5),subplot(3,3,j)
    
    hold on
    
    plot(SPM.marsY.Y(1:length(yID),j),RTs_dimmean(1:length(yID),1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),RTs_dimmean(length(yID)+1:nsubjs,1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')

    
    %young only
    
    figure(6),subplot(3,3,j)

    plot(SPM.marsY.Y(1:length(yID),j),RTs_dimmean(1:length(yID),1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    
    %old only
    
    figure(7),subplot(3,3,j)

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),RTs_dimmean(length(yID)+1:nsubjs,1),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')


end

%Dims 2-4 Collapsed

for j = 1:nclusters
    
    %Accuracy baseline
    
    figure(8),subplot(3,3,j)
    
    hold on
    
    plot(SPM.marsY.Y(1:length(yID),j),mean(Acc_dimmean(1:length(yID),2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),mean(Acc_dimmean(length(yID)+1:nsubjs,2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')

    
    %young only
    
    figure(9),subplot(3,3,j)

    plot(SPM.marsY.Y(1:length(yID),j),mean(Acc_dimmean(1:length(yID),2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    
    %old only
    
    figure(10),subplot(3,3,j)

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),mean(Acc_dimmean(length(yID)+1:nsubjs,2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')


end

for j = 1:nclusters
    
    %RT baseline
    
    figure(11),subplot(3,3,j)
    
    hold on
    
    hold on
    
    plot(SPM.marsY.Y(1:length(yID),j),mean(RTs_dimmean(1:length(yID),2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),mean(RTs_dimmean(length(yID)+1:nsubjs,2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')

    
    %young only
    
    figure(12),subplot(3,3,j)

    plot(SPM.marsY.Y(1:length(yID),j),mean(RTs_dimmean(1:length(yID),2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','black','MarkerFaceColor','black')

    
    %old only
    
    figure(13),subplot(3,3,j)

    plot(SPM.marsY.Y(length(yID)+1:nsubjs,j),mean(RTs_dimmean(length(yID)+1:nsubjs,2:4),2),'Marker','o','MarkerSize',8,'LineStyle','none','MarkerEdgeColor','red','MarkerFaceColor','red')


end

end

