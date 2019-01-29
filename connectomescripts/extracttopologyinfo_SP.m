function [ConTable,ConTable_local,subjs] = extracttopologyinfo_SIFT(path, textfilename, sparsity)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

cd(path)

workingdirectory = pwd;
files = dir(workingdirectory);
dirFlags = [files.isdir];
subFolders = files(dirFlags);
subFolders(1:2) = [];
cd /Volumes/LNDG/Projects/StateSwitch-Alistair/dynamic/data/mri/dwi/preproc/B_data/connectomes/
subjs = textread([textfilename],'%s');
cd(path)

for s = 1:length(subjs)
    currentSubj = subjs{s,1};
    currentSubjDir = char([workingdirectory '/' currentSubj]);
    load([currentSubjDir '/' int2str(sparsity) '/' currentSubj '' 'metrics.mat']); %Matrix file containing information of each subject

    %load whole brain topology metrices
    numfibers(s,1) = SubjStruct.numfibers;
    CPL(s,1) = SubjStruct.CPL; 
    EFF(s,1) = SubjStruct.EFF;
    CC(s,1)  = SubjStruct.avgCCOEFF;
    MAD(s,1) = SubjStruct.MAD;

    %inter-hemispheric connectivity
    parcnum = numelements(SubjStruct.thr);

    %assume that parc integers are asymmetric
    InterHemC(s,1) = sum(sum(SubjStruct.thr(1:(parcnum./2),(parcnum./2)+1:parcnum)));

    TCOMM(s,1) = SubjStruct.TCOMM;
    
    %local metrics
    STR(s,:) = SubjStruct.STR;
    DEG(s,:) = SubjStruct.DEG;
    STR_nothr(s,:) = SubjStruct.STR_nothr;

end

ConTable = table(subjs, numfibers, CPL, EFF, CC, InterHemC, TCOMM, MAD);

ConTable_local = table(subjs);

for i = 1:164
    ConTable_local{:,i+1} = STR(:,i);
end

for i = 1:164
    ConTable_local{:,i+165} = DEG(:,i);
end

for i = 1:164
    ConTable_local{:,i+329} = STR_nothr(:,i);
end

ConTable_local.Properties.VariableNames = {'subjs','STR1','STR2','STR3','STR4',...
    'STR5','STR6','STR7','STR8','STR9','STR10','STR11','STR12','STR13',...
    'STR14','STR15','STR16','STR17','STR18','STR19','STR20','STR21',...
    'STR22','STR23','STR24','STR25','STR26','STR27','STR28','STR29',...
    'STR30','STR31','STR32','STR33','STR34','STR35','STR36','STR37',...
    'STR38','STR39','STR40','STR41','STR42','STR43','STR44','STR45',...
    'STR46','STR47','STR48','STR49','STR50','STR51','STR52','STR53',...
    'STR54','STR55','STR56','STR57','STR58','STR59','STR60','STR61',...
    'STR62','STR63','STR64','STR65','STR66','STR67','STR68','STR69',...
    'STR70','STR71','STR72','STR73','STR74','STR75','STR76','STR77',...
    'STR78','STR79','STR80','STR81','STR82','STR83','STR84','STR85',...
    'STR86','STR87','STR88','STR89','STR90','STR91','STR92','STR93',...
    'STR94','STR95','STR96','STR97','STR98','STR99','STR100','STR101',...
    'STR102','STR103','STR104','STR105','STR106','STR107','STR108',...
    'STR109','STR110','STR111','STR112','STR113','STR114','STR115',...
    'STR116','STR117','STR118','STR119','STR120','STR121','STR122',...
    'STR123','STR124','STR125','STR126','STR127','STR128','STR129',...
    'STR130','STR131','STR132','STR133','STR134','STR135','STR136',...
    'STR137','STR138','STR139','STR140','STR141','STR142','STR143',...
    'STR144','STR145','STR146','STR147','STR148','STR149','STR150',...
    'STR151','STR152','STR153','STR154','STR155','STR156','STR157',...
    'STR158','STR159','STR160','STR161','STR162','STR163','STR164',...
    'DEG1','DEG2','DEG3','DEG4','DEG5','DEG6','DEG7','DEG8','DEG9',...
    'DEG10','DEG11','DEG12','DEG13','DEG14','DEG15','DEG16','DEG17',...
    'DEG18','DEG19','DEG20','DEG21','DEG22','DEG23','DEG24','DEG25',...
    'DEG26','DEG27','DEG28','DEG29','DEG30','DEG31','DEG32','DEG33',...
    'DEG34','DEG35','DEG36','DEG37','DEG38','DEG39','DEG40','DEG41',...
    'DEG42','DEG43','DEG44','DEG45','DEG46','DEG47','DEG48','DEG49',...
    'DEG50','DEG51','DEG52','DEG53','DEG54','DEG55','DEG56','DEG57',...
    'DEG58','DEG59','DEG60','DEG61','DEG62','DEG63','DEG64','DEG65',...
    'DEG66','DEG67','DEG68','DEG69','DEG70','DEG71','DEG72','DEG73',...
    'DEG74','DEG75','DEG76','DEG77','DEG78','DEG79','DEG80','DEG81',...
    'DEG82','DEG83','DEG84','DEG85','DEG86','DEG87','DEG88','DEG89',...
    'DEG90','DEG91','DEG92','DEG93','DEG94','DEG95','DEG96','DEG97',...
    'DEG98','DEG99','DEG100','DEG101','DEG102','DEG103','DEG104',...
    'DEG105','DEG106','DEG107','DEG108','DEG109','DEG110','DEG111',...
    'DEG112','DEG113','DEG114','DEG115','DEG116','DEG117','DEG118',...
    'DEG119','DEG120','DEG121','DEG122','DEG123','DEG124','DEG125',...
    'DEG126','DEG127','DEG128','DEG129','DEG130','DEG131','DEG132',...
    'DEG133','DEG134','DEG135','DEG136','DEG137','DEG138','DEG139',...
    'DEG140','DEG141','DEG142','DEG143','DEG144','DEG145','DEG146',...
    'DEG147','DEG148','DEG149','DEG150','DEG151','DEG152','DEG153',...
    'DEG154','DEG155','DEG156','DEG157','DEG158','DEG159','DEG160',...
    'DEG161','DEG162','DEG163','DEG164','STRnt1','STRnt2','STRnt3','STRnt4',...
    'STRnt5','STRnt6','STRnt7','STRnt8','STRnt9','STRnt10','STRnt11','STRnt12','STRnt13',...
    'STRnt14','STRnt15','STRnt16','STRnt17','STRnt18','STRnt19','STRnt20','STRnt21',...
    'STRnt22','STRnt23','STRnt24','STRnt25','STRnt26','STRnt27','STRnt28','STRnt29',...
    'STRnt30','STRnt31','STRnt32','STRnt33','STRnt34','STRnt35','STRnt36','STRnt37',...
    'STRnt38','STRnt39','STRnt40','STRnt41','STRnt42','STRnt43','STRnt44','STRnt45',...
    'STRnt46','STRnt47','STRnt48','STRnt49','STRnt50','STRnt51','STRnt52','STRnt53',...
    'STRnt54','STRnt55','STRnt56','STRnt57','STRnt58','STRnt59','STRnt60','STRnt61',...
    'STRnt62','STRnt63','STRnt64','STRnt65','STRnt66','STRnt67','STRnt68','STRnt69',...
    'STRnt70','STRnt71','STRnt72','STRnt73','STRnt74','STRnt75','STRnt76','STRnt77',...
    'STRnt78','STRnt79','STRnt80','STRnt81','STRnt82','STRnt83','STRnt84','STRnt85',...
    'STRnt86','STRnt87','STRnt88','STRnt89','STRnt90','STRnt91','STRnt92','STRnt93',...
    'STRnt94','STRnt95','STRnt96','STRnt97','STRnt98','STRnt99','STRnt100','STRnt101',...
    'STRnt102','STRnt103','STRnt104','STRnt105','STRnt106','STRnt107','STRnt108',...
    'STRnt109','STRnt110','STRnt111','STRnt112','STRnt113','STRnt114','STRnt115',...
    'STRnt116','STRnt117','STRnt118','STRnt119','STRnt120','STRnt121','STRnt122',...
    'STRnt123','STRnt124','STRnt125','STRnt126','STRnt127','STRnt128','STRnt129',...
    'STRnt130','STRnt131','STRnt132','STRnt133','STRnt134','STRnt135','STRnt136',...
    'STRnt137','STRnt138','STRnt139','STRnt140','STRnt141','STRnt142','STRnt143',...
    'STRnt144','STRnt145','STRnt146','STRnt147','STRnt148','STRnt149','STRnt150',...
    'STRnt151','STRnt152','STRnt153','STRnt154','STRnt155','STRnt156','STRnt157',...
    'STRnt158','STRnt159','STRnt160','STRnt161','STRnt162','STRnt163','STRnt164'};


end

