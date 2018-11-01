%% plot bar plots for global metrics (excluded)

% dependencies: ConTable_excl, means_ya, means_oa, stds_ya, stds_oa
% (STSWD_master.m abd STSWD_global_metrics.m)

%setup 

addpath(genpath('~/Desktop/MATLAB/raacampbell-sigstar-c1927a6'))

purple = [152,78,163]/255;
orange = [255,127,0]/255;

ya_excl = ismember(ConTable_excl.AgeGroup,1);
oa_excl = ismember(ConTable_excl.AgeGroup,2);

savewhere = '~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/C_Figures';

%% numfibers

f = figure('rend','painters','pos',[10 10 900 600]);
y = [means_ya.numfibers;means_oa.numfibers];
y_std = [stds_ya.numfibers;stds_oa.numfibers];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .7;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.LineWidth = 1.3;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title('Number of fibers per age group','FontSize',28);
xlabel ('Age group','FontSize',26);
ylabel ('Number of fibers','FontSize',26);
ylim([0 4e+7]);

hold on;
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
    e.LineWidth = 1.3;
end

hold on;

if global_anova.p_group(1) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(1);
end
    
sig = sigstar([1,2],psig);

saveas(gcf, fullfile(savewhere,'numfibers_bar'),'png');
close(f)

%% CPL

f = figure('rend','painters','pos',[10 10 900 600]);
y = [means_ya.CPL;means_oa.CPL];
y_std = [stds_ya.CPL;stds_oa.CPL];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .7;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.LineWidth = 1.3;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title('Characteristic path length per age group','FontSize',28);
xlabel ('Age group','FontSize',26);
ylabel ('Characteristic path length','FontSize',26);
ylim([0 3.5]);

hold on;
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
    e.LineWidth = 1.3;
end

hold on;

if global_anova.p_group(2) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(2);
end
    
sig = sigstar([1,2],psig);

saveas(gcf, fullfile(savewhere,'CPL_bar'),'png');
close(f)

%% EFF

f = figure('rend','painters','pos',[10 10 900 600]);
y = [means_ya.EFF;means_oa.EFF];
y_std = [stds_ya.EFF;stds_oa.EFF];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .7;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.LineWidth = 1.3;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title('Global efficiency per age group','FontSize',28);
xlabel ('Age group','FontSize',26);
ylabel ('Global efficiency','FontSize',26);
ylim([0 .6]);

hold on;
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
    e.LineWidth = 1.3;
end

hold on;

if global_anova.p_group(3) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(3);
end
    
sig = sigstar([1,2],psig);

saveas(gcf, fullfile(savewhere,'EFF_bar'),'png');
close(f)

%% CC

f = figure('rend','painters','pos',[10 10 900 600]);
y = [means_ya.CC;means_oa.CC];
y_std = [stds_ya.CC;stds_oa.CC];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .7;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.LineWidth = 1.3;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title('Average clustering coefficient per age group','FontSize',28);
xlabel ('Age group','FontSize',26);
ylabel ('Average clustering coefficient','FontSize',26);
ylim([0 1]);

hold on;
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
    e.LineWidth = 1.3;
end

hold on;

if global_anova.p_group(4) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(4);
end
    
sig = sigstar([1,2],psig);

saveas(gcf, fullfile(savewhere,'CC_bar'),'png');
close(f)

%% InterHemC

f = figure('rend','painters','pos',[10 10 900 600]);
y = [means_ya.InterHemC;means_oa.InterHemC];
y_std = [stds_ya.InterHemC;stds_oa.InterHemC];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .7;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.LineWidth = 1.3;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title('Interhemispheric connectivity per age group','FontSize',28);
xlabel ('Age group','FontSize',26);
ylabel ('Interhemispheric connectivity','FontSize',26);

hold on;
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
    e.LineWidth = 1.3;
end

hold on;

if global_anova.p_group(5) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(5);
end
    
sig = sigstar([1,2],psig);

saveas(gcf, fullfile(savewhere,'InterHemC_bar'),'png');
close(f)

%% TCOMM

f = figure('rend','painters','pos',[10 10 900 600]);
y = [means_ya.TCOMM;means_oa.TCOMM];
y_std = [stds_ya.TCOMM;stds_oa.TCOMM];

b = bar(y,0.7);

b.FaceColor = 'flat';
b.FaceAlpha = .7;
b.CData(1,:) = orange; 
b.CData(2,:) = purple; 
b.LineWidth = 1.3;

set(gca,'FontName','Calibri');
set(gca,'XTickLabel',{'Young adults','Older adults'},'FontSize',22);
t = title('Communicability per age group','FontSize',28);
xlabel ('Age group','FontSize',26);
ylabel ('Communicability','FontSize',26);
ylim([0 9e11])

hold on;
ngroups = size(y, 1);
nbars = size(y, 2);
groupwidth = min(0.8, nbars/(nbars + 1.5));
for i = 1:nbars
    x = (1:ngroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*nbars);
    e = errorbar(x, y(:,i), y_std(:,i), 'k', 'linestyle', 'none');
    e.LineWidth = 1.3;
end

hold on;

if global_anova.p_group(6) > 0.05
    psig = NaN;
else
    psig = global_anova.p_group(6);
end
    
sig = sigstar([1,2],psig);

saveas(gcf, fullfile(savewhere,'TCOMM_bar'),'png');
close(f)