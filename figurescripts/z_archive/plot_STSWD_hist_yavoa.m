function hist_YAvOA(metric,savewhere,savewhat,ftitle,xtitle)

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

purple = [152,78,163]/255;
orange = [255,127,0]/255;
blue = [55,126,184]/255;

ya = ismember(ConTable.AgeGroup,1);
oa = ismember(ConTable.AgeGroup,2);

metric_i = find(ismember(global_means.metric,metric));

savewhere = '/Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/C_Figures/global_metrics';

%% plot histogram with distributions per group/overall
f = figure('rend','painters','pos',[10 10 900 600]);
y = ConTable{:,metric_i+4};

h = histfit(y,30);
h(1).FaceAlpha = .3;
h(1).FaceColor = blue;
h(2).Color = blue;

hold on;

h1 = histfit(y(find(ya==1)));
delete(h1(1))
h1(2).Color = orange; 

hold on;

h2 = histfit(y(find(oa==1)));
delete(h2(1)) 
h2(2).Color = purple; 

set(gca,'FontName','Calibri','FontSize',18);

t = title(ftitle,'FontSize',28);
xlabel (xtitle,'FontSize',26);
ylabel ('Frequency','FontSize',26);

lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
lgd.FontSize = 20;
lgd.Location = 'northwest';

if savewhat ~= 0
    saveas(gcf,fullfile(savewhere,savewhat),'png');
    close(f)
end

end

% %% CPL
% f = figure('rend','painters','pos',[10 10 900 600]);
% y = ConTable.CPL;
% 
% h = histfit(y,30);
% h(1).FaceAlpha = .3;
% h(1).FaceColor = blue;
% h(2).Color = blue;
% 
% hold on;
% 
% h1 = histfit(y(find(ya==1)));
% delete(h1(1))
% h1(2).Color = orange; 
% 
% hold on;
% 
% h2 = histfit(y(find(oa==1)));
% delete(h2(1)) 
% h2(2).Color = purple; 
% 
% set(gca,'FontName','Calibri','FontSize',18);
% 
% t = title('Characteristic path length per age group','FontSize',28);
% xlabel ('Characteristic path length','FontSize',26);
% ylabel ('Frequency','FontSize',26);
% 
% lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
% lgd.FontSize = 20;
% lgd.Location = 'northwest';
% 
% saveas(gcf, fullfile(savewhere,'CPL_agediffs'),'png');
% close(f)
% 
% %% EFF
% f = figure('rend','painters','pos',[10 10 900 600]);
% y = ConTable.EFF;
% 
% h = histfit(y,30);
% h(1).FaceAlpha = .3;
% h(1).FaceColor = blue;
% h(2).Color = blue;
% 
% hold on;
% 
% h1 = histfit(y(find(ya==1)));
% delete(h1(1))
% h1(2).Color = orange; 
% 
% hold on;
% 
% h2 = histfit(y(find(oa==1)));
% delete(h2(1)) 
% h2(2).Color = purple; 
% 
% set(gca,'FontName','Calibri','FontSize',18);
% 
% t = title('Global efficiency per age group','FontSize',28);
% xlabel ('Global efficiency','FontSize',26);
% ylabel ('Frequency','FontSize',26);
% 
% lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
% lgd.FontSize = 20;
% lgd.Location = 'northwest';
% 
% saveas(gcf, fullfile(savewhere,'EFF_agediffs'),'png');
% close(f)
% 
% %% CC
% f = figure('rend','painters','pos',[10 10 900 600]);
% y = ConTable.CC;
% 
% h = histfit(y,30);
% h(1).FaceAlpha = .3;
% h(1).FaceColor = blue;
% h(2).Color = blue;
% 
% hold on;
% 
% h1 = histfit(y(find(ya==1)));
% delete(h1(1))
% h1(2).Color = orange; 
% 
% hold on;
% 
% h2 = histfit(y(find(oa==1)));
% delete(h2(1)) 
% h2(2).Color = purple; 
% 
% set(gca,'FontName','Calibri','FontSize',18);
% 
% t = title('Average clustering coefficient per age group','FontSize',28);
% xlabel ('Average clustering coefficient','FontSize',26);
% ylabel ('Frequency','FontSize',26);
% 
% lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
% lgd.FontSize = 20;
% lgd.Location = 'northwest';
% 
% saveas(gcf, fullfile(savewhere,'CC_agediffs'),'png');
% close(f)
% 
% %% InterHemC
% f = figure('rend','painters','pos',[10 10 900 600]);
% y = ConTable.InterHemC;
% 
% h = histfit(y,30);
% h(1).FaceAlpha = .3;
% h(1).FaceColor = blue;
% h(2).Color = blue;
% 
% hold on;
% 
% h1 = histfit(y(find(ya==1)));
% delete(h1(1))
% h1(2).Color = orange; 
% 
% hold on;
% 
% h2 = histfit(y(find(oa==1)));
% delete(h2(1)) 
% h2(2).Color = purple; 
% 
% set(gca,'FontName','Calibri','FontSize',18);
% 
% t = title('Interhemispheric connectivity per age group','FontSize',28);
% xlabel ('Interhemispheric connectivity','FontSize',26);
% ylabel ('Frequency','FontSize',26);
% 
% lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
% lgd.FontSize = 20;
% lgd.Location = 'northwest';
% 
% saveas(gcf, fullfile(savewhere,'InterHemC_agediffs'),'png');
% close(f)
% 
% %% TCOMM
% f = figure('rend','painters','pos',[10 10 900 600]);
% y = ConTable.TCOMM;
% 
% h = histfit(y,30);
% h(1).FaceAlpha = .3;
% h(1).FaceColor = blue;
% h(2).Color = blue;
% 
% hold on;
% 
% h1 = histfit(y(find(ya==1)));
% delete(h1(1))
% h1(2).Color = orange; 
% 
% hold on;
% 
% h2 = histfit(y(find(oa==1)));
% delete(h2(1)) 
% h2(2).Color = purple; 
% 
% set(gca,'FontName','Calibri','FontSize',18);
% 
% t = title('Communicability per age group','FontSize',28);
% xlabel ('Communicability','FontSize',26);
% ylabel ('Frequency','FontSize',26);
% 
% lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
% lgd.FontSize = 20;
% lgd.Location = 'northwest';
% 
% saveas(gcf, fullfile(savewhere,'TCOMM_agediffs'),'png');
% close(f)
% 
% %% MAD
% f = figure('rend','painters','pos',[10 10 900 600]);
% y = ConTable.MAD;
% 
% h = histfit(y,30);
% h(1).FaceAlpha = .3;
% h(1).FaceColor = blue;
% h(2).Color = blue;
% 
% hold on;
% 
% h1 = histfit(y(find(ya==1)));
% delete(h1(1))
% h1(2).Color = orange; 
% 
% hold on;
% 
% h2 = histfit(y(find(oa==1)));
% delete(h2(1)) 
% h2(2).Color = purple; 
% 
% set(gca,'FontName','Calibri','FontSize',18);
% 
% t = title('Mean anatomical distance per age group','FontSize',28);
% xlabel ('Mean anatomical distance','FontSize',26);
% ylabel ('Frequency','FontSize',26);
% 
% lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
% lgd.FontSize = 20;
% lgd.Location = 'northwest';
% 
% saveas(gcf, fullfile(savewhere,'MAD_agediffs'),'png');
% close(f)
