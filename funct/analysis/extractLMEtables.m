function LMEtable = extractLMEtables(behav, behavname)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

nsubjs=length(behav(:,1));
nconds=length(behav(1,:));

for i = 1:nsubjs
    if i == 1
        dataext(1:nconds,1)=ones(1,nconds);
        dataext(1:nconds,2)=1:nconds;
        dataext(1:nconds,3)=behav(i,:);
        
    else
        dataext([i-1]*nconds+1:[i-1]*nconds+nconds,1)=repmat(i,1,nconds);
        dataext([i-1]*nconds+1:[i-1]*nconds+nconds,2)=1:nconds;
        dataext([i-1]*nconds+1:[i-1]*nconds+nconds,3)=behav(i,:);
    end
end

LMEtable=table(dataext(:,1),dataext(:,2),dataext(:,3));
LMEtable.Properties.VariableNames{'Var1'}='ID';
LMEtable.Properties.VariableNames{'Var2'}='Load';
LMEtable.Properties.VariableNames{'Var3'}=behavname;

writetable(LMEtable, [behavname '_LMEtable.txt']);


end

