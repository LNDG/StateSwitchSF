function [allparcmatches, ParcFinalIndex, TopParcFinalIndex, Parcmatchstrings] = SPMcluster_parcmatch(clustermap, parcnii, parclabels)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here


[~, cmapdata] = read(clustermap);
numclusters = max(max(max(cmapdata)));

[~, parcdata] = read(parcnii);
nparcs = max(max(max(parcdata)));

ParcFinalIndex = cell(1,numclusters);
allparcmatches=[];

for i = 1:numclusters
    findparci = find(cmapdata==i);
    parcmatch = parcdata(findparci);
    [parcmatches, ~, ~] = unique(parcmatch);
    parcmatches(parcmatches==0)=[];
    parcmatches=double(parcmatches);
    
    allparcmatches=cat(1, allparcmatches, parcmatches);
    
    for j = 1:length(parcmatches);
        parcmatches(j,2) = length(find(parcmatch==parcmatches(j,1)));
    end
    
    if isempty(parcmatches)
    TopParcFinalIndex(i,1) = 0;   
    else
    parcmatches = sortrows(parcmatches,2);
    TopParcFinalIndex(i,1) = parcmatches(j,1);
    end
    
    ParcFinalIndex{1,i}=parcmatches(:,1);
    allparcmatches=cat(1, allparcmatches, parcmatches(:,1));
    
end

allparcmatches=unique(allparcmatches);

Parcmatchstrings = cell(numclusters,1);
for i = 1:nparcs
    [Parcmatch,~] = find(TopParcFinalIndex==i);
    for j = 1:length(Parcmatch)
        Parcmatchstrings(Parcmatch(j,1),1) = {[parclabels{i,1} '_' int2str(j)]};
    end
end

end

