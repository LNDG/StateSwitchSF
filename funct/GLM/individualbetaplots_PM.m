%% Invert structure of individual beta weights into separate clusters

nclusters=length(SPM.ResidualMS);
clusters=struct;
for i = 1:92
    for j = 1:nclusters
            clusters.(['c' int2str(j)])(i,1)=SPM.marsY.Y(i,j);
    end
end

%% Plot individual weights all

for j = 1:nclusters
    figure(2),subplot(3,2,j)
    bar(mean(clusters.(['c' int2str(j)])))
    cstringremun=strrep(SPM.marsY.regions{1,j}.name,'_',' ');
    cstringfinal=strrep(cstringremun,'Load Effect','');
    title(cstringfinal)
end

%% Plot separately for young and old
%Note AP removed from 
yID = {'1117';'1118';'1120';'1124';'1125';'1126';'1131';'1132';'1135';'1136';'1151';'1160';'1164';'1167';'1169';'1172';'1173';'1178';'1182';'1214';'1216';'1219';'1223';'1227';'1228';'1233';'1234';'1237';'1239';'1240';'1243';'1245';'1247';'1250';'1252';'1257';'1261';'1265';'1266';'1268';'1270';'1276';'1281'};
oID = {'2104';'2107';'2108';'2112';'2118';'2120';'2121';'2123';'2125';'2129';'2130';'2133';'2132';'2134';'2135';'2140';'2145';'2147';'2149';'2157';'2160';'2201';'2202';'2203';'2205';'2206';'2209';'2210';'2211';'2213';'2214';'2215';'2216';'2217';'2219';'2222';'2224';'2226';'2236';'2238';'2241';'2244';'2246';'2248';'2250';'2251';'2252';'2258';'2261'};

nYA = length(yID);
nOA = length(oID);
nsubjs = nYA+nOA;

for j = 1:nclusters
    
    figure(3),subplot(3,2,j)
    
    hold on
    
    bar(1 - 0.25,mean(clusters.(['c' int2str(j)])(1:nYA,1)),0.4,'FaceColor','k');
    bar(1 + 0.25,mean(clusters.(['c' int2str(j)])(nYA+1:nsubjs,1)),0.4,'FaceColor','r');
    
%     bar(2 - 0.25,mean(clusters.(['c' int2str(j)])(1:nYA,2)),0.4,'FaceColor','k');
%     bar(2 + 0.25,mean(clusters.(['c' int2str(j)])(nYA+1:nsubjs,2)),0.4,'FaceColor','r');
    
    cstringremun=strrep(SPM.marsY.regions{1,j}.name,'_',' ');
    cstringfinal=strrep(cstringremun,'Load Effect','');
    title(cstringfinal)
    
end

grpIDs(1:nYA,1)=1;
grpIDs(nYA+1:nYA+nOA)=2;

%%Distribution plots

for j = 1:nclusters
    
    figure(4),subplot(3,2,j)
    
    hold on
    
    plotSpread_incmarkersz(clusters.(['c' int2str(j)]),'distributionIdx',grpIDs,'distributionColors',{'black','red'});
    
%     bar(2 - 0.25,mean(clusters.(['c' int2str(j)])(1:nYA,2)),0.4,'FaceColor','k');
%     bar(2 + 0.25,mean(clusters.(['c' int2str(j)])(nYA+1:nsubjs,2)),0.4,'FaceColor','r');
    
    cstringremun=strrep(SPM.marsY.regions{1,j}.name,'_',' ');
    cstringfinal=strrep(cstringremun,'Load Effect','');
    title(cstringfinal)
    
end