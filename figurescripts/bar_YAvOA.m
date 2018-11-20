function bar_YAvOA(metric,savewhere,savewhat,ftitle,ytitle)

% *************************************************

% run STSWD_master and STSWD_global_metrics first!

% INPUTS:   metric      - name of metric (numfibers, CPL, EFF, CC,
%                           InterHemC, TCOMM)
%           savewhere   - pathname of where to save
%           savewhat    - name of figure to save
%           ftitle      - figure title
%           ytitle      - y-axis label

% set up
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/

load for_beehives.mat

addpath(genpath('~/Desktop/MATLAB/raacampbell-sigstar-c1927a6')) % you might have to change the gap between the line and the 'n.s.'
addpath(genpath('~/Desktop/MATLAB/plotSpread/plotSpread'))

purple = [152,78,163]/255; %color1
orange = [255,127,0]/255; %color2

metric_i = find(ismember(global_means.metric,metric));

%% plot

f = figure('rend','painters','pos',[10 10 900 600]);

sp = plotSpread_incmarkersz(ConTable{:,metric_i+4},'distributionIdx',...
    ConTable.AgeGroup,'distributionColors',{orange,purple});

hold on;

y = [global_means{metric_i,2};global_means{metric_i,3}];
y_std = [global_means{metric_i,4};global_means{metric_i,5}];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .3;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.EdgeAlpha = 0;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title(ftitle,'FontSize',28);
xlabel ({[]},'FontSize',26);
ylabel (ytitle,'FontSize',26);
ylim([(min(ConTable{:,metric_i+4})-(mean((ConTable{:,metric_i+4})/50))) ...
    (max(ConTable{:,metric_i+4})+(mean((ConTable{:,metric_i+4})/50)))])

% hold on;
% ngroups = size(y, 1);
% nbars = size(y, 2);
% groupwidth = min(0.7, nbars/(nbars + 1.5));
% for i = 1:nbars
%     x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
%     e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
%     e.LineWidth = 1.3;
% end

hold on;

if global_anova.p_group(metric_i) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(metric_i);
end
    
sig = sigstar([1,2],psig);

if savewhat ~= 0
    saveas(gcf,fullfile(savewhere,savewhat),'png');
    close(f)
end

% return to script folder
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/A_Scripts/figures

end