%% quality control for movement

cd ~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/B_Data/QC/

meanFDs = load('Subjects_meanFD_newID.txt');
for i = 1:length(meanFDs)
    if meanFDs(i,1) < 2000
        meanFDs(i,3) = 1;
    else
        meanFDs(i,3) = 2;
    end
end

purple = [152,78,163]/255;
orange = [255,127,0]/255;
blue = [55,126,184]/255;

ya = ismember(meanFDs(:,3),1);
oa = ismember(meanFDs(:,3),2);

savewhere = '~/../../Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/analyses/Sarah/C_Figures';

%% check for outliers

outliers_all = isoutlier(meanFDs(:,2),'mean'); % overall 2157
outliers_ya = isoutlier(meanFDs((ismember(meanFDs(:,3),1)),2),'mean'); % within ya 1182
outliers_oa = isoutlier(meanFDs((ismember(meanFDs(:,3),2)),2),'mean'); % within oa 2157
outliers_yaoa = [outliers_ya;outliers_oa]; % concatentate within group lists

%% plot hist movement

f = figure('rend','painters','pos',[10 10 900 600]);
y = meanFDs(:,2);

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

t = title('Average FD across diffusion acquisition','FontSize',28);
xlabel ('Average Framewise Displacement (mm^{3})','FontSize',26);
xlim([-2 4])
ylabel ('Frequency','FontSize',26);
ylim([0 30]);

lgd = legend([h(2) h1(2) h2(2)],'Overall distribution','Young adults','Older adults');
lgd.FontSize = 20;
lgd.Location = 'northeast';

saveas(gcf, fullfile(savewhere,'FD_all'),'png');
close(f)

%% plot young

f = figure('rend','painters','pos',[10 10 900 600]);
y = meanFDs(:,2);

h = histfit(y(find(ya==1)),15);
h(1).FaceAlpha = .3;
h(1).FaceColor = orange;
h(2).Color = orange;

set(gca,'FontName','Calibri','FontSize',18);

t = title('Average FD across diffusion acquisition','FontSize',28);
xlabel ('Average Framewise Displacement (mm^{3})','FontSize',26);
xlim([-2 4])
ylabel ('Frequency','FontSize',26);
ylim([0 13]);

lgd = legend([h(1)],'Young adults');
lgd.FontSize = 20;
lgd.Location = 'northeast';

saveas(gcf, fullfile(savewhere,'FD_ya'),'png');
close(f)

%% plot old

f = figure('rend','painters','pos',[10 10 900 600]);
y = meanFDs(:,2);

h = histfit(y(find(oa==1)),30);
h(1).FaceAlpha = .3;
h(1).FaceColor = purple;
h(2).Color = purple;

set(gca,'FontName','Calibri','FontSize',18);

t = title('Average FD across diffusion acquisition','FontSize',28);
xlabel ('Average Framewise Displacement (mm^{3})','FontSize',26);
xlim([-2 4])
ylabel ('Frequency','FontSize',26);
ylim([0 13]);

lgd = legend([h(1)],'Older adults');
lgd.FontSize = 20;
lgd.Location = 'northeast';

saveas(gcf, fullfile(savewhere,'FD_oa'),'png');
close(f)