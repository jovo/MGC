function []=plot_simulation_powers(select)
% Used to plot figure 1-8 used in tex. Run like

% total is usually 20.
% pre1 specifies the location to load data.
% pre2 specifies the location to save pictures.

%%% File path searching
fpath = mfilename('fullpath');
fpath=strrep(fpath,'\','/');
findex=strfind(fpath,'/');
rootDir=fpath(1:findex(end-2));
addpath(genpath(strcat(rootDir,'Code/')));
pre1=strcat(rootDir,'Data/Results/'); % The folder to locate data
pre2=strcat(rootDir,'Figures/Fig');% The folder to save figures

%%
if nargin<1
    select=1;
end
total=20;

%% Set colors
map3 = brewermap(128,'PiYG'); % brewmap
MGC='green';
loca='cyan';
glob= [0.5,0.5,0.5];
HHG   = [0.6,0.6,0.6];
mcorr=[0.3,0.3,0.3];
mantel=[0.3,0.3,0.3];
dcorr=[0.3,0.3,0.3];
pcorr=[0.9,0.9,0.9];
mic   = [0.9,0.9,0.9];
kendall=[0.9,0.9,0.9];
spearman=[0.9,0.9,0.9];
hsic=[0.6,0.6,0.6];

lw=3;
ls{1}='-';
ls{2}='--';
ls{3}='-.';
ls{4}=':';

%% figure1-4
figNumber='1DPower';
if select~=1
    figNumber='1DPowerAll';
end
figure('units','normalized','position',[0 0 1 1])
s=4;
t=5;
% power_Mantel=zeros(20,20);
% power_DCorr=zeros(20,20);
% power_MCorr=zeros(20,20);
% power_MGC=zeros(20,20);
% power_MGC_Mantel=zeros(20,20);
% power_HHG=zeros(20,20);
% power_HSIC=zeros(20,20);
% power_Corr=zeros(20,20);
% power_MIC=zeros(20,20);
for j=1:total
    filename=strcat(pre1,'CorrIndTestType',num2str(j),'N100Dim1.mat');
    load(filename)
%         power_Mantel(j,:)=powerP;
%     power_DCorr(j,:)=powerD;
%     power_MCorr(j,:)=powerM;
%     power_MGC(j,:)=powerMGC;
%     power_MGC_Mantel(j,:)=powerMGC3;
%     power_HHG(j,:)=powerHHG;
%     power_HSIC(j,:)=powerHSIC;
%     power_Corr(j,:)=powerCorr;
%     power_MIC(j,:)=powerMIC;
%     subplot(s,t,j)
    titlechar=strcat(num2str(j),'.',{' '},CorrSimuTitle(j));
    %
    hold on
    if select==1
        h7=plot(numRange,powerP-powerMGC,ls{4},'LineWidth',3,'Color',mantel);
        h6=plot(numRange,powerD-powerMGC,ls{3},'LineWidth',3,'Color',dcorr);
        h5=plot(numRange,powerM-powerMGC,ls{2},'LineWidth',3,'Color',mcorr);
        %h4=plot(numRange,powerMGCP,ls{3},'LineWidth',3,'Color',loca);
        %h3=plot(numRange,powerMGCD,ls{2},'LineWidth',3,'Color',loca);
        %h2=plot(numRange,powerMGCM-powerMGC,ls{1},'LineWidth',3,'Color',loca);
        h8=plot(numRange,powerHHG-powerMGC,ls{2},'LineWidth',3,'Color',HHG);
        h9=plot(numRange,powerHSIC-powerMGC,ls{4},'LineWidth',3,'Color',hsic);
        h10=plot(numRange,powerCorr-powerMGC,ls{2},'LineWidth',3,'Color',pcorr);
        h11=plot(numRange,powerMIC-powerMGC,ls{4},'LineWidth',3,'Color',mic);
        h1=plot(numRange,powerMGC-powerMGC,ls{1},'LineWidth',3,'Color',MGC);
    else
        h7=plot(numRange,powerP,ls{3},'LineWidth',3,'Color',glob);
        h6=plot(numRange,powerD,ls{2},'LineWidth',3,'Color',glob);
        h5=plot(numRange,powerM,ls{1},'LineWidth',3,'Color',glob);
        h4=plot(numRange,powerMGCP,ls{3},'LineWidth',3,'Color',loca);
        h3=plot(numRange,powerMGCD,ls{2},'LineWidth',3,'Color',loca);
        h2=plot(numRange,powerMGCM,ls{1},'LineWidth',3,'Color',loca);
        h1=plot(numRange,powerMGC,ls{1},'LineWidth',3,'Color',MGC);
        h8=plot(numRange,powerHHG,ls{4},'LineWidth',3,'Color',HHG);
        h9=plot(numRange,powerHSIC,ls{3},'LineWidth',3,'Color',hsic);
        h10=plot(numRange,powerCorr,ls{2},'LineWidth',3,'Color',pcorr);
        h11=plot(numRange,powerMIC,ls{1},'LineWidth',3,'Color',mic);
    end
    hold off
    xlim([numRange(1) numRange(end)]);
    ylim([-1 1]);
    if j~=1 % Remove x&y axis ticks except type 16, which is at the left bottom
        set(gca,'YTick',[]); % Remove y axis ticks
        set(gca,'XTick',[]); % Remove x axis ticks
    else
        set(gca,'XTick',[numRange(1),numRange(end)]); % Remove x axis ticks
        set(gca,'YTick',[-1,-0.5,0,0.5,1]); % Remove x axis ticks
    end
    set(gca,'FontSize',14);
    title(titlechar,'FontSize',14, ...
        'Units', 'normalized','Position', [0 1.05], 'HorizontalAlignment', 'left')
    axis('square');
end
% save(strcat(pre1,'data1.mat'));
% xlabel('Sample Size','position',[-270 -0.2],'FontSize',24);
% ylabel('Power','position',[-687 2.7],'FontSize',24);
xlabel('Sample Size','position',[-270 -1.6],'FontSize',24);
ylabel('Power Relative to MGC','position',[-687 4.5],'FontSize',24);
h=suptitle('Testing Power for 20 Simulated 1-Dimensional Settings');
set(h,'FontSize',24,'FontWeight','normal');
lgdPosition = [0.03, 0.78, .05, .05]; %Legend Position
if select==1;
    h=legend([h1 h6 h5 h7 h8 h9 h10 h11],'MGC','Dcorr','Mcorr','Mantel','HHG','HSIC','Pearson','MIC','Location',lgdPosition);
else
    h=legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11],'Sample MGC','MGC_{M}','MGC_{D}','MGC_{P}','Mcorr','Dcorr','Mantel','HHG','HSIC','Pearson','MIC','Location',lgdPosition);
end
legend boxoff
set(h,'FontSize',14);
%
F.fname=[strcat(pre2, figNumber)];
F.wh=[8 5]*2;
print_fig(gcf,F)

%% Plot 5-8
figNumber='HDPower';
if select~=1
    figNumber='HDPowerAll';
end
figure('units','normalized','position',[0 0 1 1])
s=4;
t=5;
% power_Mantel=zeros(20,21);
% power_DCorr=zeros(20,21);
% power_MCorr=zeros(20,21);
% power_MGC=zeros(20,21);
% power_MGC_Mantel=zeros(20,21);
% power_HHG=zeros(20,21);
% power_HSIC=zeros(20,21);
% power_Corr=zeros(20,21);
% power_MIC=zeros(20,21);
for j=1:total   
    filename=strcat(pre1,'CorrIndTestDimType',num2str(j),'N100Dim.mat');
    load(filename)
    numRange=dimRange;
%         power_Mantel(j,1:length(numRange))=powerP;
%     power_DCorr(j,1:length(numRange))=powerD;
%     power_MCorr(j,1:length(numRange))=powerM;
%     power_MGC(j,1:length(numRange))=powerMGC;
%     power_MGC_Mantel(j,1:length(numRange))=powerMGC3;
%     power_HHG(j,1:length(numRange))=powerHHG;
%     power_HSIC(j,1:length(numRange))=powerHSIC;
%     power_Corr(j,1:length(numRange))=powerCorr;
%     power_MIC(j,1:20)=powerMIC;
    subplot(s,t,j)
    titlechar=strcat(num2str(j),'.',{' '},CorrSimuTitle(j));
    hold on
    if select==1
        h7=plot(numRange,powerP-powerMGC,ls{4},'LineWidth',3,'Color',mantel);
        h6=plot(numRange,powerD-powerMGC,ls{3},'LineWidth',3,'Color',dcorr);
        h5=plot(numRange,powerM-powerMGC,ls{2},'LineWidth',3,'Color',mcorr);
        %h4=plot(numRange,powerMGCP,ls{3},'LineWidth',3,'Color',loca);
        %h3=plot(numRange,powerMGCD,ls{2},'LineWidth',3,'Color',loca);
        %h2=plot(numRange,powerMGCM-powerMGC,ls{1},'LineWidth',3,'Color',loca);
        
        h8=plot(numRange,powerHHG-powerMGC,ls{2},'LineWidth',3,'Color',HHG);
        h9=plot(numRange,powerHSIC-powerMGC,ls{4},'LineWidth',3,'Color',hsic);
        h10=plot(numRange,powerCorr-powerMGC,ls{2},'LineWidth',3,'Color',pcorr);
        h11=plot(numRange,powerCCA-powerMGC,ls{4},'LineWidth',3,'Color',pcorr);
        h1=plot(numRange,powerMGC-powerMGC,ls{1},'LineWidth',3,'Color',MGC);
    else
        h7=plot(numRange,powerP,ls{3},'LineWidth',3,'Color',glob);
        h6=plot(numRange,powerD,ls{2},'LineWidth',3,'Color',glob);
        h5=plot(numRange,powerM,ls{1},'LineWidth',3,'Color',glob);
        h4=plot(numRange,powerMGCP,ls{3},'LineWidth',3,'Color',loca);
        h3=plot(numRange,powerMGCD,ls{2},'LineWidth',3,'Color',loca);
        h2=plot(numRange,powerMGCM,ls{1},'LineWidth',3,'Color',loca);
        h1=plot(numRange,powerMGC,ls{1},'LineWidth',3,'Color',MGC);
        h8=plot(numRange,powerHHG,ls{4},'LineWidth',3,'Color',HHG);
        h9=plot(numRange,powerHSIC,ls{4},'LineWidth',3,'Color',hsic);
        h10=plot(numRange,powerCorr,ls{4},'LineWidth',3,'Color',pcorr);
        h11=plot(numRange,powerCCA,ls{3},'LineWidth',3,'Color',pcorr);
    end
    hold off
    xlim([numRange(1) numRange(end)]);
    ylim([-1 1]);
    if j~=1 % Remove x&y axis ticks except type 16, which is at the left bottom
        set(gca,'YTick',[]); % Remove y axis ticks
    else
        set(gca,'YTick',[-1,-0.5,0,0.5,1]); % Remove x axis ticks
    end
    set(gca,'XTick',[numRange(1),numRange(end)]); % Remove x axis ticks
    set(gca,'FontSize',14);
    title(titlechar,'FontSize',14, ...
        'Units', 'normalized','Position', [0 1.05], 'HorizontalAlignment', 'left')
    axis('square');
end
% save(strcat(pre1,'data2.mat'));
%xlabel('Dimension','position',[-290 -0.2],'FontSize',24);
%ylabel('Power','position',[-720 2.7],'FontSize',24);
xlabel('Dimension','position',[-290 -1.6],'FontSize',24);
ylabel('Power Relative to MGC','position',[-720 4.5],'FontSize',24);
h=suptitle('Testing Power for 20 Simulated High-Dimensional Settings');
set(h,'FontSize',24,'FontWeight','normal');
lgdPosition = [0.03, 0.78, .05, .05]; %Legend Position
if select==1;
    h=legend([h1 h6 h5 h7 h8 h9 h10 h11],'MGC','Dcorr','Mcorr','Mantel','HHG','HSIC','RV','CCA','Location',lgdPosition);
else
    h=legend([h1 h2 h3 h4 h5 h6 h7 h8 h9 h10 h11],'Sample MGC','MGC_{M}','MGC_{D}','MGC_{P}','Mcorr','Dcorr','Mantel','HHG','HSIC','Pearson','CCA','Location',lgdPosition);
end
set(h,'FontSize',14);
legend boxoff
%
F.fname=strcat(pre2, figNumber);
F.wh=[8 5]*2;
print_fig(gcf,F)